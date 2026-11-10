/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * 96 Genesis skill level on 95 PC (the Game page's Skill level row).
 * 96 PC's User Setup has no skill/difficulty row; the 96-family option is 96 Genesis OptSkill.
 */
#ifndef NHL95_SKILL_H
#define NHL95_SKILL_H

void skill_install(void);

/* 96G OptSkill: 0 pro, 1 all-star, 2 rookie. */
enum { SKILL_PRO = 0, SKILL_ALLSTAR = 1, SKILL_ROOKIE = 2 };

/* 96G SkillLevelTbl NTSC ($15, $15, $14). Rookie + pfjoycon: addq #2. */
int skill_gravity(int skill, int human);

/* 95 PC updateplayers multiplies velocity by 16; 96G multiplies by skillspeed (21 on pro). */
int skill_step(int skill, int human);

#endif
