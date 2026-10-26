/* The mixer: an SDL audio device plus the list of sound devices that render into it. NHL95_WAV=file.wav also writes everything
 * that was mixed to a WAV file (16-bit stereo), which is how the sound code is tested without speakers. */
#include "host.h"
#include "audio.h"
#include <stdarg.h>

#define MAX_SOURCES 8
#define CHUNK 1024

static audio_render_fn sources[MAX_SOURCES];
static int nsources;
static SDL_AudioDeviceID dev;
static SDL_mutex *mutex;
static int out_rate = 44100;
static FILE *wav;
static uint32_t wav_bytes;
static int64_t pump_last;

int audio_rate(void) { return out_rate; }
void audio_lock(void) { if (mutex) SDL_LockMutex(mutex); }
void audio_unlock(void) { if (mutex) SDL_UnlockMutex(mutex); }
void audio_add_source(audio_render_fn fn) { if (nsources < MAX_SOURCES) sources[nsources++] = fn; }

static void wav_header(void)
{
    uint32_t v;
    uint16_t h;
    if (!wav) return;
    fseek(wav, 0, SEEK_SET);
    fwrite("RIFF", 1, 4, wav); v = 36 + wav_bytes; fwrite(&v, 4, 1, wav);
    fwrite("WAVEfmt ", 1, 8, wav); v = 16; fwrite(&v, 4, 1, wav);
    h = 1; fwrite(&h, 2, 1, wav); h = 2; fwrite(&h, 2, 1, wav);
    v = out_rate; fwrite(&v, 4, 1, wav); v = out_rate * 4; fwrite(&v, 4, 1, wav);
    h = 4; fwrite(&h, 2, 1, wav); h = 16; fwrite(&h, 2, 1, wav);
    fwrite("data", 1, 4, wav); fwrite(&wav_bytes, 4, 1, wav);
}

/* Where the program writes its own files (the diagnostics log and the captures): next to the program, or the current folder. */
static void out_path(char *buf, size_t n, const char *name)
{
    const char *base = SDL_GetBasePath();
    snprintf(buf, n, "%s%s", base ? base : "", name);
}

/* nhl95-audio.log: timing facts about the sound emulation, appended, for finding out what goes wrong on a machine that cannot be
 * attached to a debugger. */
void audio_log(const char *fmt, ...)
{
    char path[1100];
    FILE *f;
    va_list ap;
    static int64_t t0;
    if (!t0) t0 = plat_now_ns();
    out_path(path, sizeof path, "nhl95-audio.log");
    f = fopen(path, "a");
    if (!f) f = fopen("nhl95-audio.log", "a");
    if (!f) return;
    fprintf(f, "[%7.1f s] ", (plat_now_ns() - t0) / 1e9);
    va_start(ap, fmt);
    vfprintf(f, fmt, ap);
    va_end(ap);
    fputc('\n', f);
    fclose(f);
}

/* Ctrl+F11: start or stop recording what is mixed to nhl95-capture-N.wav (16-bit stereo) */
void audio_capture_toggle(void)
{
    static int n;
    char path[1100], name[64];
    audio_lock();
    if (wav) {
        wav_header();
        fclose(wav);
        wav = 0;
        audio_log("capture stopped (%u bytes)", wav_bytes);
        video_set_title("NHL Hockey 95 - capture saved");
    } else {
        snprintf(name, sizeof name, "nhl95-capture-%d.wav", ++n);
        out_path(path, sizeof path, name);
        wav_bytes = 0;
        wav = fopen(path, "wb");
        if (wav) { wav_header(); audio_log("capture started: %s", path); video_set_title("NHL Hockey 95 - RECORDING (Ctrl+F11 stops)"); }
        else audio_log("cannot create %s", path);
    }
    audio_unlock();
}

/* mix `frames` stereo frames into out (interleaved int16) */
static void mix(int16_t *out, int frames)
{
    static int32_t acc[CHUNK * 2];
    while (frames > 0) {
        int n = frames < CHUNK ? frames : CHUNK, i;
        memset(acc, 0, n * 2 * sizeof(int32_t));
        SDL_LockMutex(mutex);
        for (i = 0; i < nsources; i++) sources[i](acc, n, out_rate);
        SDL_UnlockMutex(mutex);
        for (i = 0; i < n * 2; i++) {
            int32_t v = acc[i];
            out[i] = v > 32767 ? 32767 : v < -32768 ? -32768 : (int16_t)v;
        }
        SDL_LockMutex(mutex);
        if (wav) { fwrite(out, 4, n, wav); wav_bytes += n * 4; wav_header(); fseek(wav, 0, SEEK_END); }
        SDL_UnlockMutex(mutex);
        out += n * 2;
        frames -= n;
    }
}

static void SDLCALL callback(void *user, Uint8 *stream, int len)
{
    (void)user;
    mix((int16_t *)stream, len / 4);
}

void audio_init(void)
{
    SDL_AudioSpec want, have;
    const char *w = getenv("NHL95_WAV");
    mutex = SDL_CreateMutex();
    memset(&want, 0, sizeof want);
    want.freq = 44100; want.format = AUDIO_S16SYS; want.channels = 2; want.samples = 1024; want.callback = callback;
    dev = SDL_OpenAudioDevice(0, 0, &want, &have, 0);
    if (dev) { out_rate = have.freq; SDL_PauseAudioDevice(dev, 0); }
    else fprintf(stderr, "no audio device (%s): sound is mixed but not played\n", SDL_GetError());
    if (w) { wav = fopen(w, "wb"); if (wav) wav_header(); }
    pump_last = plat_now_ns();
    speaker_init();
    opl_init();
}

/* Without an audio device nothing calls the mixer, so the devices that count samples (the Sound Blaster's block interrupts) would
 * never finish: run it from the main thread at the pace of the clock. */
void audio_pump(void)
{
    static int16_t scratch[CHUNK * 2];
    int64_t now = plat_now_ns();
    int frames;
    if (dev) return;
    frames = (int)((now - pump_last) * out_rate / 1000000000LL);
    if (frames > CHUNK) frames = CHUNK;
    if (frames <= 0) return;
    pump_last += (int64_t)frames * 1000000000LL / out_rate;
    mix(scratch, frames);
}
