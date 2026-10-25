/* The MPU-401 MIDI interface (UART mode) at 330h/331h, with a Roland MT-32 behind it when the Munt library and the MT-32 ROM images
 * are available. Without them the interface answers like the real one and the notes go nowhere. */
#include "host.h"
#include "audio.h"
#include <dirent.h>
#include <strings.h>

#ifdef HAVE_MUNT
#include "c_interface/c_interface.h"
static mt32emu_context synth;
#endif

static int base = 0x330;
static uint8_t queue[16];
static int qn;
static int uart;
static int synth_ok;

static void push(uint8_t b)
{
    if (qn < (int)sizeof queue) queue[qn++] = b;
}

#ifdef HAVE_MUNT
static int add_roms_from(const char *dir)
{
    DIR *d = opendir(dir);
    struct dirent *e;
    int n = 0;
    if (!d) return 0;
    while ((e = readdir(d))) {
        size_t l = strlen(e->d_name);
        if (l > 4 && !strcasecmp(e->d_name + l - 4, ".rom")) {
            char path[1024];
            snprintf(path, sizeof path, "%s/%s", dir, e->d_name);
            if (mt32emu_add_rom_file(synth, path) >= 0) n++;
        }
    }
    closedir(d);
    return n;
}

static void synth_open(void)
{
    const char *dirs[] = { getenv("NHL95_MT32_ROMS"), getenv("NHL95_ROOT"), ".", "./roms", "./ROMS", "/usr/share/mt32-rom-data",
                           "/usr/local/share/mt32-rom-data", 0 };
    int i;
    { mt32emu_report_handler_i rh; memset(&rh, 0, sizeof rh); synth = mt32emu_create_context(rh, 0); }
    mt32emu_set_stereo_output_samplerate(synth, audio_rate());
    for (i = 0; dirs[i]; i++) add_roms_from(dirs[i]);
    if (mt32emu_open_synth(synth) == MT32EMU_RC_OK) {
        synth_ok = 1;
        TRACE("MT-32: synth open\n");
    } else {
        fprintf(stderr, "MT-32: no usable ROM images found (MT32_CONTROL.ROM and MT32_PCM.ROM); set NHL95_MT32_ROMS to their folder\n");
    }
}
#endif

static void mpu_render(int32_t *out, int frames, int rate)
{
    (void)rate;
#ifdef HAVE_MUNT
    if (synth_ok) {
        static int16_t buf[2048 * 2];
        while (frames > 0) {
            int n = frames < 2048 ? frames : 2048, i;
            mt32emu_render_bit16s(synth, buf, n);
            for (i = 0; i < n * 2; i++) out[i] += buf[i];
            out += n * 2;
            frames -= n;
        }
    }
#else
    (void)out; (void)frames;
#endif
}

void mpu_init(int b)
{
    base = b;
    audio_add_source(mpu_render);
}

uint32_t mpu_in(unsigned port)
{
    uint32_t v;
    audio_lock();
    if (port == (unsigned)base) {
        v = qn ? queue[0] : 0xFE;
        if (qn) memmove(queue, queue + 1, --qn);
    } else v = (qn ? 0x00 : 0x80) | 0x3F;           /* bit 7 set: nothing to read; bit 6 clear: ready for a byte */
    audio_unlock();
    return v;
}

void mpu_out(unsigned port, uint32_t val)
{
    audio_lock();
    if (port == (unsigned)base + 1) {
        if (val == 0xFF) uart = 0;
        else if (val == 0x3F) uart = 1;
        push(0xFE);                                  /* every command is acknowledged */
        TRACE("mpu: command %02x\n", (unsigned)val);
    } else if (uart) {
#ifdef HAVE_MUNT
        uint8_t b = val;
        if (!synth) synth_open();
        if (synth_ok) mt32emu_parse_stream(synth, &b, 1);
#endif
    }
    audio_unlock();
}
