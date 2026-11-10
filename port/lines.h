/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * NHL 96 PC auto line changes on 95 PC (the Game page row plus the engine hooks in port/lines.c).
 */
#ifndef NHL95_LINES_H
#define NHL95_LINES_H

#include <stdint.h>

void lines_install(void);

/* 96 PC faceoff CompLine: Auto always, else only a team with no human controller.
 * team is 1 home / 2 away (puckfaceoff's [regd0]). */
int lines_team_gets_compline(int auto_on, int team, int cont1, int cont2);

/* 94 Genesis CompLine (logic94.asm) on 95 PC's line numbers: 0-2 even strength (94G never uses 95's line 4),
 * 4-5 power play, 6-7 penalty kill. diff = own tmap - other tmap; score = own score compared with the other's
 * (-1/0/1), used only in the 3rd period; other_line is the other team's tmline; energy[8] is getlinee per line. */
int lines_pick94(int home, int diff, int third, int score, int other_line, const int energy[8]);

#endif
