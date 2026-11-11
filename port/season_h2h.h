/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Human-vs-human calendar handshake. Two machines that pick the same scheduled
 * game send this while the connect dialog is open. Same league + date (month
 * and day packed in `game`) + home/vis with complementary teams means they
 * play each other. Do not use CalendarScreen's schedule slot: each copy's
 * SCHEDULE.nn can number the same night differently. Type 20 is a game
 * message (0..239); Overbar's own types start at 240.
 */
#ifndef PORT_SEASON_H2H_H
#define PORT_SEASON_H2H_H

#include <stdint.h>

enum {
    SEASON_H2H_TYPE = 20,
    SEASON_H2H_WANT = 1,
    SEASON_H2H_PLAYING = 3,
    SEASON_H2H_GONE = 2
};

#define SEASON_H2H_LEAGUE 12
#define SEASON_H2H_LINE 48

typedef struct season_h2h {
    uint8_t kind;
    uint8_t home;
    uint8_t vis;
    uint8_t mine;
    uint16_t game;                          /* (month << 8) | day from the 6-byte schedule record */
    char league[SEASON_H2H_LEAGUE];
} __attribute__((packed)) season_h2h;

/* 1 when a and b are the two sides of one scheduled game. */
int season_h2h_same(const season_h2h *a, const season_h2h *b);
/* fill a WANT/PLAYING/GONE from this machine's pick. game is (month<<8)|day.
 * league may be "FOO.LP". */
void season_h2h_fill(season_h2h *o, int kind, int home, int vis, int mine, int game,
                     const char *league);
/* four centred MessageBox lines. player is the other human's 11-byte name. */
void season_h2h_lines(char out[4][SEASON_H2H_LINE], const char *player);
/* 1 if every line fits a 640-wide retail box (~40 glyphs). */
int season_h2h_lines_fit(const char lines[4][SEASON_H2H_LINE]);

#endif
