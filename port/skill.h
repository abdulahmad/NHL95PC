/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * 96 PC main-menu LEVEL (GAME SETUP) on 95 PC (the Game page's Skill level row).
 * Rookie / Pro / All-Star; default Pro. Not 96 Genesis OptSkill.
 *
 * Pro is 1× the current feel (unscaled 94G or unscaled 95 PC). All-Star and Rookie
 * scale off that same baseline. 96 PC's 3/4 is not applied to Pro.
 */
#ifndef NHL95_SKILL_H
#define NHL95_SKILL_H

void skill_install(void);

/* 96 PC dword_17C9A8 bits 7-8: 0 Rookie, 1 Pro (default), 2 All-Star. */
enum { SKILL_ROOKIE = 0, SKILL_PRO = 1, SKILL_ALLSTAR = 2 };

/* Exact 96 PC playeracc scales (documentation / tests only, not live):
 * Rookie/Pro v - v/4 (sar 2), All-Star v + v/8 (sar 3). */
int skill_scale_96(int skill, int v);

/* Live playeracc: Pro and Rookie leave v (the feel-mode term) alone; All-Star is 3/2.
 * v is already 94G or 95 PC stock from feel_playeracc. */
int skill_scale_action(int skill, int v);

/* Live Game-page wrapper. */
int skill_scale_now(int v);

/* 95 PC feel: checkcheck 150 Rookie/Pro, 100 All-Star. */
int skill_hit_base(int skill);

/* Pro hit base for this feel: 150 on 95 PC, 0x78 (94G CCStart d0) on 94G. */
int skill_hit_pro_base(int feel94);

/* All-Star is 100/150 of pro_base; Rookie equals Pro. */
int skill_hit_base_on(int skill, int pro_base);

/* 96 PC AI proximity (sub_43605): 3 Rookie, 4 Pro/All-Star. Not hooked. */
int skill_ai_near(int skill);

#endif
