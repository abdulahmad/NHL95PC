/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * NHLPA 93's fight rules (port/fight/rules.h). Each block names the 93 routine it copies; 16-bit arithmetic is kept
 * where 93's words wrap. 93 rolls the instigator from the VDP's HV counter: here the game's generator, so a fight
 * replays the same and online play stays in step.
 */
#include "rules.h"

#include "rom93.h"

#include <string.h>

#define F F93_FIGHT
#define I F93_FINJURY

/* frame, duration pairs; a negative duration ends the list. [0] facing 0-2, [1] facing 3-7 (93's .2 and .7 lists) */
static const int16_t a_fight[2][8] = { { F, 8, F + 1, 8, F + 2, 8, F + 3, -6 }, { F, 8, F + 1, 8, F + 2, 8, F + 8, -6 } };
static const int16_t a_grab[2][4] = { { F + 4, 28, F + 3, -4 }, { F + 9, 28, F + 8, -4 } };
static const int16_t a_held[2][4] = { { F + 4, 30, F + 3, -4 }, { F + 9, 30, F + 8, -4 } };
static const int16_t a_high[2][8] = { { F + 5, 6, F + 6, 16, F + 5, 4, F + 3, -16 }, { F + 10, 6, F + 11, 16, F + 10, 4, F + 8, -16 } };
static const int16_t a_low[2][8] = { { F + 5, 6, F + 7, 16, F + 5, 4, F + 3, -16 }, { F + 10, 6, F + 12, 16, F + 10, 4, F + 8, -16 } };
static const int16_t a_hith[2][4] = { { F + 14, 16, F + 3, -8 }, { F + 14, 16, F + 8, -8 } };
static const int16_t a_hitl[2][4] = { { F + 13, 16, F + 3, -8 }, { F + 13, 16, F + 8, -8 } };
static const int16_t a_fall[8] = { F + 14, 8, F + 15, 8, F + 16, 200, F + 16, -2 };
static const int16_t a_injury[42] = {
    F + 14, 8, F + 15, 8, F + 16, 20, I, 8, I + 1, 8, I + 2, 8,
    I + 3, 10, I + 4, 10, I + 5, 10, I + 3, 10, I + 4, 10, I + 5, 10, I + 3, 10, I + 4, 10, I + 5, 10,
    I + 3, 10, I + 4, 10, I + 5, -400
};

static const int16_t *anim_list(int spa, int dirindex)
{
    int k = dirindex <= 2 ? 0 : 1;
    switch (spa) {
    case FA_FIGHT: return a_fight[k];
    case FA_GRAB: return a_grab[k];
    case FA_HELD: return a_held[k];
    case FA_HIGH: return a_high[k];
    case FA_LOW: return a_low[k];
    case FA_HITHIGH: return a_hith[k];
    case FA_HITLOW: return a_hitl[k];
    case FA_FALL: return a_fall;
    case FA_INJURY: return a_injury;
    default: return NULL;
    }
}

static int dir_index(const fighter *p)
{
    int d = p->facedir & 7;
    if (p->flip) d = (8 - d) & 7;               /* mirrored when x flipped (updateanim) */
    return d;
}

int fight_anim_frame(int spa, int facedir, int step, int *duration)
{
    fighter p;
    const int16_t *l;
    int i;
    memset(&p, 0, sizeof p);
    p.facedir = facedir;
    p.flip = facedir != 2;
    l = anim_list(spa, dir_index(&p));
    if (!l || step < 0) return -1;
    for (i = 0; i < step; i++) if (l[2 * i + 1] < 0) return -1;
    if (duration) *duration = l[2 * step + 1];
    return l[2 * step];
}

/* SetSPA */
static void set_spa(fighter *p, int spa)
{
    if (p->spa == spa) return;
    p->spanum = 0;
    p->spa = spa;
    p->spacnt = -1;                             /* st SPAcnt: restart */
}

/* updateanim (the fight animations do not loop) */
static void update_anim(fighter *p, int e)
{
    const int16_t *l;
    int n, d2, dur;
    if (!p->spa) { p->alock = 0; p->aip = 0; return; }
    l = anim_list(p->spa, dir_index(p));
    if (!l) { p->spa = 0; return; }
    n = p->spanum;
    d2 = l[2 * n];
    if (p->spacnt >= 0) {
        p->spacnt -= e;
        if (p->spacnt >= 0) goto cframe;
        p->spanum++;
        n = p->spanum;
        if (l[2 * n - 1] < 0) {                 /* the step just done was the last */
            n = 0;
            p->spanum = 0;
            p->alock = 0;
            p->aip = 0;
            p->spa = 0;
        }
    }
    dur = l[2 * n + 1];
    p->spacnt = dur < 0 ? -dur : dur;
cframe:
    p->glitch = (int8_t)(p->glitch - e);        /* at most one frame switch in 4 frames */
    if (p->glitch >= 0) return;
    p->glitch = 0;
    if (p->frame == d2) return;
    p->frame = d2;
    p->glitch = 4;
}

/* SetInst: may a3 fight a2? */
static int set_inst(const fighter *a3, const fighter *a2, int need, int checks_a2)
{
    if (need > a3->fighting) return 0;
    if (a2->fighting < 2) return 0;
    if ((int8_t)(0x10 - 2 * checks_a2) > a2->fighting) return 0;
    return 1;
}

int fight_rating_byte(int roster_byte)
{
    return roster_byte & 0xE;
}

int fight_check_weight(int fighting)
{
    return fighting == 0 ? 3 : 1;
}

int fight_wants(const fighter *a, const fighter *b, int chkcnt, int checks_a, int checks_b, int penalties_on,
                int (*random)(void *ctx, int range), void *ctx, int *instigator)
{
    int need = 40 - chkcnt, on = 0;
    if (need < 0) need = 0;
    need = (need >> 2) + 10;
    if (instigator) *instigator = -1;
    if (set_inst(a, b, need, checks_b)) {
        on = 1;                                 /* a was not fighting yet: a's team may get the instigator */
        if (penalties_on && random && random(ctx, 4) == 0 && instigator) *instigator = 0;
    }
    if (set_inst(b, a, need, checks_a)) {
        if (!on && penalties_on && random && random(ctx, 4) == 0 && instigator) *instigator = 1;
        on = 1;
    }
    return on;
}

/* checkfight .sf: start the fight for p */
static void start_one(fighter *p)
{
    p->flip = p->facedir != 2;
    p->xvel = p->facedir == 2 ? -0x400 : 0x400;
    p->gloves_on = 1;
    p->aip = 1;
    p->alock = 0;
    p->started = 0;
    p->strength = 0;
    p->spa = 0;
    set_spa(p, FA_FIGHT);
}

void fight_begin(fight *ft)
{
    fighter *a3 = &ft->f[0], *a2 = &ft->f[1];
    int d1 = 2;
    ft->on = 1;
    ft->events = 0;
    ft->crowd = 1000;
    ft->excite = 0x23;
    ft->yc1 = (int16_t)(a3->y + a2->y) >> 1;
    ft->xc1 = (int16_t)(a3->x + a2->x) >> 1;
    if (a3->x >= a2->x) d1 ^= 7;                /* face each other */
    a3->facedir = d1;
    a2->facedir = d1 ^ 7;
    start_one(a3);
    start_one(a2);
    ft->pencnt = 0x28 * 32;                     /* Fighting's stop delay ($28 half seconds, x 32 frames) */
    ft->winner = ft->loser = -1;
    ft->glove_x = ft->glove_y = 0;
}

/* chkhit .cwd: the crowd reacts; v knocked back by the puncher's strength */
static void knock(fight *ft, fighter *v, const fighter *puncher)
{
    int d0 = (int)(uint16_t)((5 + puncher->strength) * 500);
    ft->crowd += 0x50;
    ft->excite += 0xA;
    if (v->facedir == 2) d0 = -d0;
    v->xvel = (int16_t)(v->xvel + d0);
}

/* chkhit .fall: v lost */
static void lost(fight *ft, int vi)
{
    fighter *v = &ft->f[vi], *w = &ft->f[vi ^ 1];
    ft->events |= FE_WINNER;
    ft->winner = vi ^ 1;
    ft->loser = vi;
    ft->pencnt = 60;
    w->strength = -1;
    ft->crowd += 600;
    ft->excite += 30;
    if (ft->random(ft->ctx, 60) <= w->checking) {
        ft->pencnt = 180;
        v->injured = 1;
        set_spa(v, FA_INJURY);
        ft->events |= FE_INJURY;
        return;
    }
    set_spa(v, FA_FALL);
    ft->events |= v->away ? FE_CHEER : FE_BOO;
}

/* chkhit: did me's punch land on the other? */
static void chkhit(fight *ft, int mi)
{
    fighter *me = &ft->f[mi], *op = &ft->f[mi ^ 1];
    int d, fr = me->frame, hit = 0;
    if (fr == me->oldframe) return;
    if (fr == F + 2) {                          /* gloves off */
        int x = ft->xc1;
        me->gloves_on = 0;
        if (x >= 90) x = 90;
        if (x <= -90) x = -90;
        x >>= 2;
        if (!x) x = 1;
        ft->glove_x = (int8_t)x;
        ft->glove_y = (int8_t)(ft->yc1 >> 2);
        ft->events |= FE_GLOVES;
        return;
    }
    d = (int16_t)(me->x - op->x);
    if (d > 22 || d < -22) return;
    d = (int16_t)(me->y - op->y);
    if (d > 8 || d < -8) return;
    if (fr == F + 6 || fr == F + 11) hit = FA_HITHIGH;
    else if (fr == F + 7 || fr == F + 12) hit = FA_HITLOW;
    else if (fr == F + 4 || fr == F + 9) {
        op->aip = 1;
        set_spa(op, FA_HELD);
        return;
    }
    if (!hit) return;
    knock(ft, op, me);
    op->aip = 1;
    ft->events |= hit == FA_HITHIGH ? FE_PUNCH_HIGH : FE_PUNCH_LOW;    /* 93 is silent on the last punch; heard here */
    if (--op->strength < 0) { lost(ft, mi ^ 1); return; }
    set_spa(op, hit);
}

/* fightinput: a human fighter's pad */
static void fight_input(fight *ft, int mi, int pad, void (*accel)(void *ctx, int who, int dir))
{
    fighter *me = &ft->f[mi];
    int dir = pad & 15, buttons = pad >> 4, d0;
    if (me->strength < 0 || ft->pencnt < 0) return;
    if (me->spa == FA_FIGHT) return;            /* not ready yet */
    if (!(dir & 8) && accel) accel(ft->ctx, mi, dir & 7);
    d0 = ft->xc1 + 12;                          /* keep near the spot, face to face */
    if (me->facedir == 2) d0 -= 0x18;
    d0 = (int16_t)(d0 - me->x);
    if ((int16_t)(me->xvel ^ d0) < 0) {
        if (d0 < 0) d0 = -d0;
        me->xvel = (int16_t)(me->xvel - ((d0 * me->xvel) >> 4));
    }
    if (me->aip) return;
    me->aip = 1;
    if (buttons & FP_C) set_spa(me, FA_HIGH);
    else if (buttons & FP_B) set_spa(me, FA_LOW);
    else if (buttons & FP_A) set_spa(me, FA_GRAB);
    else me->aip = 0;
}

/* assfight */
static void ass_fight(fight *ft, int mi, int e)
{
    fighter *me = &ft->f[mi], *op = &ft->f[mi ^ 1];
    int d0, d1;
    if (me->alock) return;
    if (ft->pencnt < 0) return;
    if (!me->started) {
        me->started = 1;
        d0 = (me->energy * me->fighting) >> 12;     /* strength = energy x fighting / 4096, at least 5 */
        me->strength = d0 > 5 ? d0 : 5;
        me->banner = me->facedir == 2 ? 0x5A : 0xFFFF;
    }
    me->banner -= e;
    if (me->banner < 0) { ft->events |= FE_BANNER; me->banner = 0xFFFF; }
    if (me->strength < 0) return;
    ft->xc1 = (int16_t)(me->x + op->x) >> 1;
    if (!me->human && !me->aip) {
        me->aip = 1;
        d0 = (int16_t)(me->x - op->x + (me->xvel >> 8) - (op->xvel >> 8));
        if (d0 <= 20 && d0 >= -20) {
            static const int al[3] = { FA_HIGH, FA_LOW, FA_GRAB };
            int r = ft->random(ft->ctx, 8);
            if (r > 2) r &= 1;                  /* a grab 1 time in 8, else high or low */
            set_spa(me, al[r]);
        }
    }
    chkhit(ft, mi);
    if (me->spa == FA_HELD || (me->spa != FA_FIGHT && !me->human)) {
        d0 = ft->xc1 + 10;                      /* pulled toward the spot */
        if (me->facedir == 2) d0 -= 0x14;
        me->xvel = (int16_t)(me->xvel + (int16_t)((d0 - me->x) << 5));
    }
    d1 = (int16_t)((ft->yc1 - me->y) << 8);
    if (d1 >= 0x1000) d1 = 0x1000;
    if (d1 <= -0x1000) d1 = -0x1000;
    me->yvel = d1;
}

void fight_pass(fight *ft, int elapsed, const int pad[2], void (*accel)(void *ctx, int who, int dir))
{
    int i;
    ft->events = 0;
    ft->crowd = ft->excite = 0;
    if (!ft->on) return;
    for (i = 0; i < 2; i++) update_anim(&ft->f[i], elapsed);     /* the frame first: chkhit acts on a new one */
    for (i = 0; i < 2; i++) {
        if (ft->f[i].human) fight_input(ft, i, pad ? pad[i] : 8, accel);
        ass_fight(ft, i, elapsed);
    }
    {
        /* not 93: two players can skate past each other (two humans, or a big knock back), and then 93 leaves
         * them back to back. They turn to face each other again. */
        fighter *a = &ft->f[0], *b = &ft->f[1];
        if ((a->facedir == 2 && a->x > b->x) || (a->facedir != 2 && a->x < b->x)) {
            a->facedir = a->facedir == 2 ? 5 : 2;
            b->facedir = a->facedir ^ 7;
            a->flip = a->facedir != 2;
            b->flip = b->facedir != 2;
        }
    }
    ft->pencnt -= elapsed;                      /* chkprogress */
    if (ft->pencnt < 0) { ft->events |= FE_OVER; ft->on = 0; }
    for (i = 0; i < 2; i++) ft->f[i].oldframe = ft->f[i].frame;    /* drawn */
}
