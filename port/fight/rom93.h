/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * The player's own NHLPA Hockey 93 Genesis ROM, for the fight and injury frames and the punch sound (port/fight/).
 * Nothing from 93 is in this repository: the port finds the ROM beside the program or in the game folder, under any
 * file name, and reads the pieces it needs at start-up. Rev 0 (v1.0), Rev A (v1.1) and Rev B (v1.2) are known; the
 * addresses come from the NHLPA93Genesis disassembly (src/graphics93.asm, src/teamdata93.asm, src/sound/sound93.asm).
 */
#ifndef NHL95_ROM93_H
#define NHL95_ROM93_H

#include <stddef.h>
#include <stdint.h>

/* frame numbers in Sprites.anim (NHLPA93Genesis src/frames93.asm) */
enum {
    F93_GLOVES = 353,           /* 1 frame: the gloves on the ice */
    F93_FIGHT = 354,            /* 17: drop the gloves, ready, punches, grab, hit, fall */
    F93_FINJURY = 371,          /* 6: the bloody fight injury, lying on the ice */
    F93_INJURY1 = 633,          /* 12: injured on the ice (blood), 93's check injury */
    F93_NTEAMS = 26             /* TeamList: 24 teams and the two All-Star teams */
};

typedef struct rom93 {
    uint8_t *data;              /* the whole ROM (malloc'd) */
    size_t size;
    int rev;                    /* 0, 1 (A) or 2 (B) */
    uint32_t sprites;           /* Sprites.anim */
    uint32_t icerink;           /* IceRink.map.jim: palette lines 0 and 1 */
    uint32_t teamlist;          /* TeamList: a long per team record */
    uint32_t punch;             /* sfx_hithigh_pcm: unsigned 8-bit, a 0 ends it */
} rom93;

/* a frame as pixels: 0 clear, else palette line x 16 + colour (1-15); line 2 is the player's team */
typedef struct f93_frame {
    int x0, y0;                 /* the top left corner, from the frame's origin (the player's feet) */
    int w, h;
    uint8_t *pix;               /* w x h (malloc'd; f93_frame_free) */
} f93_frame;

/* the ROM in data (taken over on success): 0, or -1 when it is not a known NHLPA 93 ROM */
int rom93_identify(uint8_t *data, size_t size, rom93 *out);
/* looks in each folder of dirs (NULL-ended) for the ROM, any file name: 0 found, -1 none */
int rom93_find(const char *const *dirs, rom93 *out, char *path, size_t pathsize);
void rom93_free(rom93 *r);

int rom93_nframes(const rom93 *r);
/* frame n (1 up): 0, or -1 (no such frame, or a broken one) */
int f93_decode(const rom93 *r, int n, f93_frame *out);
void f93_frame_free(f93_frame *f);

/* 0x00RRGGBB colours of the four lines: 0 and 1 the rink's, 2 team t's home (home=1) or visitor colours, 3 the same */
void f93_palette(const rom93 *r, int team, int home, uint32_t rgb[64]);
/* the team's three letters in TeamList order, for matching 95 PC's teams */
const char *f93_team_abbrev(int team);
/* 95 PC's own colours for the parts every skater shares, written over a palette from f93_palette (lines 2 and 3):
 * the shadow (index 15: 95 PC's rink entry 99, 40A0E0), the skin (6 light DC9468, 7 medium C8845C, Abdul's reading
 * of 95 PC's skaters), the stick (14: entry 6, A06060), the skate blade (1: 004080) and the eyes (F93_EYE, 60381C).
 * Read from 95 PC's skater frames through HOMEPALS.BIN's remap and Abdul's colour list (2026-11-09). */
void f93_pc95_colours(uint32_t rgb[64]);
/* 93 draws the eye with grey 13, also a team colour: the pixel of 13 between two skin pixels becomes F93_EYE (line 0
 * colour 15, which no fight or injury frame uses), so f93_pc95_colours can give it 95 PC's eye colour */
#define F93_EYE 15
void f93_pc95_frame(f93_frame *f);

/* the punch sample (bytes before its 0, unsigned 8-bit) and the rates the 93 sound driver plays it at:
 * a high punch (sound 9) and a low one (sound 10) */
const uint8_t *rom93_punch(const rom93 *r, size_t *len);
#define F93_PUNCH_HIGH_HZ 4780  /* DAC writes at 30594 a second, step 40/256 a write */
#define F93_PUNCH_LOW_HZ 6454   /* step 54/256 */

#endif
