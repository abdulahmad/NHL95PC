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

#endif
