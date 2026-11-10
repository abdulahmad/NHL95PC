/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * 96 PC main-menu LEVEL (GAME SETUP) on 95 PC (the Game page's Skill level row).
 * Rookie / Pro / All-Star; default Pro. Not 96 Genesis OptSkill.
 */
#ifndef NHL95_SKILL_H
#define NHL95_SKILL_H

void skill_install(void);

/* 96 PC dword_17C9A8 bits 7-8: 0 Rookie, 1 Pro (default), 2 All-Star. */
enum { SKILL_ROOKIE = 0, SKILL_PRO = 1, SKILL_ALLSTAR = 2 };

/* Exact 96 PC playeracc scales: Rookie/Pro v - v/4 (sar 2), All-Star v + v/8 (sar 3). */
int skill_scale_96(int skill, int v);

/* 95 PC vs its own unscaled playeracc (Pro). 96 PC All-Star is 9/8 over Pro's 3/4 = 3/2. */
int skill_scale_action(int skill, int v);

/* Live Game-page wrapper. */
int skill_scale_now(int v);

/* 96 PC checkcheck hit base: 150 Rookie/Pro, 100 All-Star (replaces 95 PC's 160/100 human/CPU). */
int skill_hit_base(int skill);

/* 96 PC AI proximity (sub_43605): 3 Rookie, 4 Pro/All-Star. */
int skill_ai_near(int skill);

#endif
