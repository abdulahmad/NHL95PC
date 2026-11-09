/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * NHLPA 93's punch, from the player's ROM (port/fight/rom93.h), mixed into the port's sound output. 93 plays the one
 * sample for both punches, a high punch slower than a low one (sounds 9 and 10: rates measured from the 93 sound
 * driver run in NHL9XStudio). The YM2612's DAC takes the bytes as they are (unsigned, 80h the middle).
 */
#include "punch.h"

#include "../audio.h"

static const uint8_t *pcm;
static size_t pcm_len;
static double pos, step_hz;
static int playing;
static int volume = 64;                 /* x (byte - 80h) */

static void punch_render(int32_t *out, int frames, int rate)
{
    int i;
    double step;
    if (!playing || !pcm || rate <= 0) return;
    step = step_hz / rate;
    for (i = 0; i < frames; i++) {
        size_t k = (size_t)pos;
        int32_t v;
        if (k >= pcm_len) { playing = 0; break; }
        v = ((int32_t)pcm[k] - 0x80) * volume;
        out[2 * i] += v;
        out[2 * i + 1] += v;
        pos += step;
    }
}

void punch_init(const rom93 *r)
{
    pcm = rom93_punch(r, &pcm_len);
    if (pcm && pcm_len) audio_add_source(punch_render);
}

int punch_ready(void) { return pcm && pcm_len; }

void punch_play(int low)
{
    if (!punch_ready()) return;
    audio_lock();
    pos = 0;
    step_hz = low ? F93_PUNCH_LOW_HZ : F93_PUNCH_HIGH_HZ;
    playing = 1;
    audio_unlock();
}
