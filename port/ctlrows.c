/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * The game's Player 1 Controls / Player 2 Controls rows (exhibition, league, playoff, in-game).
 * on1 is the handler. Both on1 and on2 clear draws the row grey and the click does nothing.
 */
#include "ctlrows.h"

#include <stdint.h>
#include <stdio.h>

void ctlrows_set(int *on1, int handler, int *saved, int *have, int four)
{
    if (!on1 || !saved || !have) return;
    if (four) {
        if (*on1 == handler) {
            *saved = handler;
            *have = 1;
            *on1 = 0;
        }
        return;
    }
    if (*have && *on1 == 0) *on1 = *saved;
}

#ifndef CTLROWS_TEST

extern char gamemenu[], unk_C854F[], unk_CF9AF[], unk_CED6F[];
extern char MenuP1ControlsExh[], MenuP2ControlsExh[];
extern char MenuP1ControlsLeague[], MenuP2ControlsLeague[];
extern char MenuP1ControlsPlayoff[], MenuP2ControlsPlayoff[];
extern char MenuP1ControlsInGame[], MenuP2ControlsInGame[];

static int *row_on1(char *menu, int index)
{
    return (int *)(menu + index * 32 + 20);     /* MenuItem: x1 y1 x2 y2 text on1 */
}

void ctlrows_sync(int four)
{
    static const struct { char *menu; int index; char *fn; } row[] = {
        { gamemenu, 3, MenuP1ControlsExh }, { gamemenu, 4, MenuP2ControlsExh },
        { unk_C854F, 0, MenuP1ControlsLeague }, { unk_C854F, 1, MenuP2ControlsLeague },
        { unk_CF9AF, 0, MenuP1ControlsPlayoff }, { unk_CF9AF, 1, MenuP2ControlsPlayoff },
        { unk_CED6F, 0, MenuP1ControlsInGame }, { unk_CED6F, 1, MenuP2ControlsInGame }
    };
    static int saved[8], have[8], complained;
    int i;
    for (i = 0; i < 8; i++) {
        int *on1 = row_on1(row[i].menu, row[i].index);
        int fn = (int)(intptr_t)row[i].fn;
        if (!have[i] && *on1 != fn && *on1 != 0 && !complained) {
            fprintf(stderr, "Player controls: a menu row is not the expected handler, it stays as it is\n");
            complained = 1;
        }
        ctlrows_set(on1, fn, &saved[i], &have[i], four);
    }
}

#endif
