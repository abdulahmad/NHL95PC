#ifndef AUDIO_H
#define AUDIO_H
#include <stdint.h>
#include <SDL.h>

/* Every sound device mixes into 32-bit stereo accumulators at the output rate. render() runs on the audio thread (or the main
 * thread without an audio device) with the audio lock held; port reads and writes from the game thread take the same lock. */
typedef void (*audio_render_fn)(int32_t *stereo, int frames, int rate);

/* Where the emulated cards are when the host does not set BLASTER / ULTRASND; the game is given the same values (cstart.c), since its
 * drivers look for the cards there. */
#define DEFAULT_BLASTER "A220 I7 D1 T3"
#define DEFAULT_ULTRASND "240,1,1,5,5"

void audio_init(void);
void audio_add_source(audio_render_fn fn);
void audio_lock(void);
void audio_unlock(void);
void audio_pump(void);                 /* main thread: runs the mixer when there is no audio device */
int audio_rate(void);

/* devices (each has ports in sound_ports.c) */
void speaker_init(void);
uint32_t speaker_in(unsigned port);
void speaker_out(unsigned port, uint32_t val);

void opl_init(void);
uint32_t opl_in(unsigned port);
void opl_out(unsigned port, uint32_t val);

void sb_init(int base, int irq, int dma, int version);
uint32_t sb_in(unsigned port);
void sb_out(unsigned port, uint32_t val);
int sb_base(void);

void mpu_init(int base);
uint32_t mpu_in(unsigned port);
void mpu_out(unsigned port, uint32_t val);

void gus_init(int base, int irq1, int irq2, int dma1, int dma2);
uint32_t gus_in(unsigned port);
void gus_out(unsigned port, uint32_t val);
int gus_base(void);

/* controllers */
uint32_t dma_in(unsigned port);
void dma_out(unsigned port, uint32_t val);
int dma_masked(int ch);
int dma_is_autoinit(int ch);
uint32_t dma_address(int ch);
uint32_t dma_remaining(int ch);
uint32_t dma_advance(int ch, uint32_t n);
uint32_t pic_in(unsigned port);
void pic_out(unsigned port, uint32_t val);
#endif
