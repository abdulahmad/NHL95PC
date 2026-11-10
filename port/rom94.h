/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * The player's own NHL Hockey '94 Genesis ROM (the retail release), for the pad stars and arrows (port/pads4.c) and
 * the team colours of the fights (port/fight/). Nothing from 94 is in this repository: the ROM is found beside the
 * program or in the game folder (or NHL94_ROM_DIR), under any file name. Addresses from the NHL94Genesis disassembly:
 * Sprites $5DE7A (graphics94.asm Sprites: as NHLPA 93's Sprites.anim, the frame table's offset at +4, tiles from +$A), IceRink94.map.jim $5605A
 * (setupIceRinkPal: palette lines 0 and 1), TeamList $30E (teamdata94.asm; a record's word at +2 is Palettedata:
 * 16 home colours, then 16 visitor colours, as 93's).
 */
#ifndef NHL95_ROM94_H
#define NHL95_ROM94_H

#include <stdint.h>

#include "fight/rom93.h"

/* frames in 94's Sprites (frames94.asm, setup94.asm, video94.asm checksso) */
enum {
    F94_ARROW1 = 384,           /* pad 1's off-screen arrows: up, up-right, right (other directions by flips) */
    F94_ARROW2 = 387,
    F94_STAR1 = 390,            /* SPFpad: pad 1's star, then pad 2's, then the puck carrier's */
    F94_STAR2 = 391,
    F94_STARPUCK = 392,
    F94_ARROW3 = 838,           /* $346 */
    F94_ARROW4 = 841,           /* $349 */
    F94_STAR3 = 844,            /* $34C */
    F94_STAR4 = 845,            /* $34D */
    F94_NTEAMS = 28             /* ANH ... WPG, ASE, ASW */
};

/* 0 loaded (once; later calls say the same), -1 no 94 ROM */
int rom94_load(void);
/* the sprite frames as a rom93 (f93_decode works on it), or NULL */
const rom93 *rom94_sprites(void);
/* 0x00RRGGBB colours of palette lines 0 and 1 (the rink's, which the stars and arrows use) */
void rom94_rink_palette(uint32_t rgb[32]);
/* the team with these letters (95 PC's: "bos", "ana", "ott" ...): its 16 home (home 1) or visitor colours. 0, or -1 */
int rom94_team_colours(const char *abbrev, int home, uint32_t rgb[16]);

#endif
