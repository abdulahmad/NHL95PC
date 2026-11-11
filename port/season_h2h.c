/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors */
#include "season_h2h.h"

#include <stdio.h>
#include <string.h>

static void cut_league(char *out, int size, const char *league)
{
    int n = 0;
    if (!out || size < 1) return;
    if (league) {
        while (league[n] && league[n] != '.' && n < size - 1) {
            out[n] = league[n];
            n++;
        }
    }
    out[n] = 0;
}

static int league_same(const char *a, const char *b)
{
    int i;
    if (!a || !b || !a[0] || !b[0]) return 0;
    for (i = 0; a[i] || b[i]; i++) {
        unsigned ca = (unsigned char)a[i], cb = (unsigned char)b[i];
        if (ca >= 'A' && ca <= 'Z') ca += 32;
        if (cb >= 'A' && cb <= 'Z') cb += 32;
        if (ca != cb) return 0;
    }
    return 1;
}

int season_h2h_same(const season_h2h *a, const season_h2h *b)
{
    int a_ok, b_ok;
    if (!a || !b) return 0;
    if (a->game != b->game) return 0;
    if (a->home != b->home || a->vis != b->vis) return 0;
    if (a->home > 25 || a->vis > 25 || a->home == a->vis) return 0;
    if (!league_same(a->league, b->league)) return 0;
    if (a->mine == b->mine) return 0;
    a_ok = a->mine == a->home || a->mine == a->vis;
    b_ok = b->mine == b->home || b->mine == b->vis;
    if (!a_ok || !b_ok) return 0;
    return (a->mine == a->home && b->mine == a->vis) ||
           (a->mine == a->vis && b->mine == a->home);
}

void season_h2h_fill(season_h2h *o, int kind, int home, int vis, int mine, int game,
                     const char *league)
{
    if (!o) return;
    memset(o, 0, sizeof *o);
    o->kind = (uint8_t)kind;
    o->home = home >= 0 && home < 26 ? (uint8_t)home : 255;
    o->vis = vis >= 0 && vis < 26 ? (uint8_t)vis : 255;
    o->mine = mine >= 0 && mine < 26 ? (uint8_t)mine : 255;
    o->game = game < 0 ? 0 : (uint16_t)game;
    cut_league(o->league, (int)sizeof o->league, league);
}

void season_h2h_lines(char out[4][SEASON_H2H_LINE], const char *player)
{
    int i, n;
    if (!out) return;
    snprintf(out[0], SEASON_H2H_LINE, "Please connect to");
    n = 0;
    if (player) {
        for (i = 0; player[i] && n < 11 && n < SEASON_H2H_LINE - 1; i++) {
            if (player[i] >= 32 && player[i] < 127) out[1][n++] = player[i];
        }
    }
    out[1][n] = 0;
    if (!out[1][0]) snprintf(out[1], SEASON_H2H_LINE, "the other player");
    snprintf(out[2], SEASON_H2H_LINE, "and have them start this game");
    snprintf(out[3], SEASON_H2H_LINE, "while this message is open to play.");
}

int season_h2h_lines_fit(const char lines[4][SEASON_H2H_LINE])
{
    int i;
    if (!lines) return 0;
    for (i = 0; i < 4; i++) {
        int n = (int)strlen(lines[i]);
        if (n < 1 || n > 40) return 0;
    }
    return 1;
}
