/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * 95 PC hooks for Overbar's one select-sides screen (every connected controller;
 * online the same module). The drawing, model and SIDES messages stay in Overbar;
 * apply writes ctl1team / ctl1side / ctl1dev and ctl2*.
 */
#include "sides.h"
#include "pads4.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef SIDES_TEST
#include "host.h"
#include "overbar_client.h"
#include "overbar/net.h"
#include "overbar/plat.h"
#include "overbar/room.h"
#include "overbar/sides.h"
#include "mdrt/menu.h"
#endif

void sides_seat_ctl(int team, int32_t home, int32_t vis, int32_t *ctl_team, uint32_t *ctl_side)
{
    if (team == 1) { *ctl_team = home; *ctl_side = 0; }     /* Home */
    else { *ctl_team = vis; *ctl_side = 1; }                /* Away */
}

uint32_t sides_dev_for_slot(int slot, int local)
{
    if (local == 0) return 8;               /* keyboard */
    if (local == SIDES_LOCAL_MOUSE) return 1;   /* mouse */
    return slot == 0 ? 2u : 4u;             /* Joystick One / Two: the seat's game-port slot */
}

int sides_pad_index(int local)
{
    if (local <= 0 || local == SIDES_LOCAL_MOUSE) return -1;
    return local - 1;
}

/* Overbar's ob_sides_draw (pinned commit): the panel, then team 0 | middle | the other teams. */
int sides_panel(int w, int h, int teams, int ndev, int *x0, int *y0, int *bw, int *cw)
{
    int cols, bh;
    if (w < 120 || h < 80 || teams < 1) return 0;
    cols = teams + 1;
    *bw = w - 16 > 360 ? 360 : w - 16;
    bh = 40 + (ndev > 0 ? ndev : 1) * 14;
    if (bh > h - 8) bh = h - 8;
    *x0 = (w - *bw) / 2;
    *y0 = (h - bh) / 2;
    *cw = (*bw - 8) / cols;
    return bh;
}

int sides_drop_team(int x, int y, int w, int h, int teams, int ndev)
{
    int x0, y0, bw, cw, bh, cols, t, rel;
    bh = sides_panel(w, h, teams, ndev, &x0, &y0, &bw, &cw);
    if (!bh || cw < 1) return -2;
    if (x < x0 || y < y0 || x >= x0 + bw || y >= y0 + bh) return -2;
    cols = teams + 1;
    rel = x - (x0 + 4);
    if (rel < 0) rel = 0;
    t = rel / cw;
    if (t >= cols) t = cols - 1;
    if (teams == 1) return t == 0 ? -1 : 0;
    if (t <= 0) return 0;
    if (t == 1) return -1;
    return t - 1;
}

int sides_device_hit(int x, int y, int index, int team, int w, int h, int teams, int ndev)
{
    int x0, y0, bw, cw, bh, col, rx, ry;
    bh = sides_panel(w, h, teams, ndev, &x0, &y0, &bw, &cw);
    if (!bh || index < 0 || cw < 6) return 0;
    if (teams == 1) col = team < 0 ? 0 : 1;
    else col = team < 0 ? 1 : team == 0 ? 0 : team + 1;
    rx = x0 + 4 + col * cw + 2;
    ry = y0 + 30 + index * 14;
    return x >= rx && x < rx + (cw - 4) && y >= ry && y < ry + 12;
}

int sides_move_inputs(int from, int to, int *out)
{
    int n = 0;
    if (!out || from == to) return 0;
    if (to < 0) { out[n++] = from == 0 ? 1 : 0; return n; }          /* a side back to the middle */
    if (from < 0) { out[n++] = to == 0 ? 0 : 1; return n; }          /* the middle out to a side */
    out[n++] = from == 0 ? 1 : 0;                                    /* through the middle */
    out[n++] = to == 0 ? 0 : 1;
    return n;
}

unsigned sides_filter_hot(unsigned sc, unsigned teams)
{
    /* F1-F4 home, F5-F8 away, F9 home goalie, F10 away (HandleHotKey) */
    static const int team_of[10] = { 1, 1, 1, 1, 0, 0, 0, 0, 1, 0 };
    if (sc < 0x3Bu || sc > 0x44u) return sc;
    if (teams & (1u << team_of[sc - 0x3Bu])) return sc;
    return 0;
}

#ifdef SIDES_TEST
#else

extern int16_t HomeTeam, VisTeam, cont1team, cont2team;
extern int32_t ctl1team, ctl2team;
extern uint32_t ctl1side, ctl2side, ctl1dev, ctl2dev, samesideflag;
extern uint8_t pad1dev, pad2dev;
extern volatile int quit_requested;

void input_bind_stick(int stick, int pad);
int input_pad_count(void);
const char *input_pad_name(int i);

static ob_sides g_sides;
static int g_fake[2];                       /* the game's pad 1 / 2 is a pretend controller (no input) */
static int g_slot[4] = { 0, 1, 2, 3 };    /* each seat's game slot (pads4_map_seats); online the step's pad k is seat k */
static struct ob_net *g_net;
static volatile int g_want;         /* game thread asks the main thread to open */
static volatile int g_left;         /* BACK in the middle: leave without applying */
static int drag_on;                 /* the Mouse row is being dragged */
static void add_devices(void);

static uint8_t pad_dev(uint32_t ctl) { return ctl == 1 || ctl == 2 || ctl == 4 || ctl == 8 ? (uint8_t)ctl : 0; }
static void setup_controllers(void)
{
    cont1team = ctl1team < 0 ? 0 : ctl1side == 0 ? 1 : 2;
    cont2team = ctl2team < 0 ? 0 : ctl2side == 0 ? 1 : 2;
    samesideflag = ctl1side == ctl2side;
    pad1dev = pad_dev(ctl1dev);
    pad2dev = pad_dev(ctl2dev);
}

int feel_four_players(void);

static ob_sides_game game95(void)
{
    ob_sides_game g;
    memset(&g, 0, sizeof g);
    g.teams = 2;
    /* offline, Four players off is the game's own two pads. Online both machines keep 4 seats so the
     * host's model and the guest's copy agree; the match then drops pads 3 and 4 if the host has it off. */
    g.seats = (g_net || feel_four_players()) ? 4 : 2;
    g.per_team = 2;
    g.team_name[0] = "Away";
    g.team_name[1] = "Home";
    return g;
}

int feel_fake_pads(void);
int feel_four_players(void);
#define FAKE_LOCAL 100              /* the Game page's pretend controllers (added at the start, not on the screen) */

static void apply_seats(void *ud, const ob_sides_seat *seat, int n)
{
    int i, m, team[4], kb[4], mine[4], local[4], slot[4], count[3] = { 0, 0, 0 };
    (void)ud;
    ctl1team = ctl2team = -1;
    ctl1dev = ctl2dev = 0x10;
    ctl1side = 0;
    ctl2side = 1;
    input_bind_stick(0, -1);
    input_bind_stick(1, -1);
    pads4_clear();
    g_fake[0] = g_fake[1] = 0;
    for (m = 0; m < n && m < 4; m++) {
        team[m] = seat[m].team == 1 ? 1 : 2;                /* column 1 Home (cont 1), 0 Away (cont 2) */
        mine[m] = seat[m].owner == g_sides.me;
        local[m] = seat[m].local;
        /* keyboard and mouse are read by the game's own two slots, on every machine the same way
         * (the host's seat table is the one both sides apply) */
        kb[m] = local[m] == 0 || local[m] == SIDES_LOCAL_MOUSE;
        count[team[m]]++;
    }
    /* Debug: pretend controllers fill both teams to two (one person: three of them, a 2 v 2) */
    if (!g_net && m > 0 && feel_four_players() && feel_fake_pads()) {
        int t;
        for (t = 1; t <= 2; t++)
            while (count[t] < 2 && m < 4) {
                team[m] = t; mine[m] = 1; local[m] = FAKE_LOCAL; kb[m] = 0;
                count[t]++;
                m++;
            }
    }
    pads4_map_seats(m, team, kb, slot);
    for (i = 0; i < 4; i++) g_slot[i] = i < n && i < m ? slot[i] : -1;
    for (i = 0; i < m; i++) {
        int s = slot[i], pad;
        int32_t *t;
        uint32_t *side, *dev;
        if (s < 0) continue;
        if (s >= 2) {                                       /* pads 3 and 4: pads4.c */
            int src = !mine[i] ? PADS4_REMOTE : local[i] >= FAKE_LOCAL ? PADS4_FAKE : sides_pad_index(local[i]);
            pads4_set(s - 2, team[i], src);
            continue;
        }
        t = s == 0 ? &ctl1team : &ctl2team;
        side = s == 0 ? &ctl1side : &ctl2side;
        dev = s == 0 ? &ctl1dev : &ctl2dev;
        sides_seat_ctl(team[i] == 1 ? 1 : 0, HomeTeam, VisTeam, t, side);
        /* the other machine's: the records; a pretend pad: no device (the game reads it as no direction, no button) */
        if (!mine[i] || local[i] >= FAKE_LOCAL) { *dev = 0x10; g_fake[s] = mine[i]; continue; }
        *dev = sides_dev_for_slot(s, local[i]);
        pad = sides_pad_index(local[i]);
        if (pad >= 0) input_bind_stick(*dev == 2 ? 0 : 1, pad);
    }
    setup_controllers();
}

static void reinit(struct ob_net *n)
{
    ob_sides_game g = game95();
    g.apply = apply_seats;
    ob_sides_init(&g_sides, &g, n ? ob_net_me(n) : 0, n ? ob_room_sides_send : NULL, n);
    ob_plat_room(&g_sides, NULL);
}

void port_sides_init(void)
{
    reinit(NULL);
}

void port_sides_bind_net(struct ob_net *n)
{
    g_net = n;
    reinit(n);
    if (n) add_devices();
}

void port_sides_unbind_net(void)
{
    g_net = NULL;
    reinit(NULL);
}

struct ob_sides *port_sides_ob(void) { return &g_sides; }

int port_sides_slot_of_seat(int seat)
{
    if (!g_sides.done) return seat;
    return seat >= 0 && seat < 4 ? g_slot[seat] : -1;
}

int port_sides_slot_fake(int slot)
{
    return slot >= 0 && slot < 2 && g_fake[slot];
}

static int skip_screen(void)
{
    const char *e = getenv("NHL95_SIDES");
    if (e && (*e == '0' || *e == 'n' || *e == 'N')) return 1;
    if (e && *e && *e != '0') return 0;             /* NHL95_SIDES=1: show even under a test aid */
    if (getenv("NHL95_NOSIDES")) return 1;
    if (getenv("NHL95_AUTOSKIP")) return 1;
    if (getenv("NHL95_KEYS")) return 1;
    if (getenv("NHL95_SNAPTEST")) return 1;
    return 0;
}

static void add_devices(void)
{
    int i, n = input_pad_count();
    ob_sides_add(&g_sides, 0, "Keyboard");
    ob_sides_add(&g_sides, SIDES_LOCAL_MOUSE, "Mouse");
    for (i = 0; i < n; i++) {
        const char *name = input_pad_name(i);
        ob_sides_add(&g_sides, 1 + i, name && name[0] ? name : "Controller");
    }
}

static void place(int local, int team)
{
    if (local < 0 || ob_sides_find(&g_sides, g_sides.me, local) < 0) return;
    if (team == 0) ob_sides_input(&g_sides, local, MDRT_MENU_LEFT);
    else if (team == 1) ob_sides_input(&g_sides, local, MDRT_MENU_RIGHT);
}

static int local_of_dev(uint32_t dev)
{
    if (dev == 8) return 0;
    if (dev == 1) return SIDES_LOCAL_MOUSE;
    if (dev == 2) return 1;                         /* Joystick One: first pad until a bind says else */
    if (dev == 4) return input_pad_count() > 1 ? 2 : 1;
    return -1;
}

static void restore_from_ctl(void)
{
    if (ctl1team >= 0) place(local_of_dev(ctl1dev), ctl1side == 0 ? 1 : 0);
    if (ctl2team >= 0) place(local_of_dev(ctl2dev), ctl2side == 0 ? 1 : 0);
}

void port_sides_poll(void)
{
    if (!g_want) return;
    if (g_sides.open || g_sides.done) return;
    add_devices();
    ob_sides_open(&g_sides);
    restore_from_ctl();
}

int port_sides_wait(void)
{
    drag_on = 0;
    pads4_clear();
    if (skip_screen()) {
        if (!g_net) pads4_fake_fill();                      /* the game's own set-up plus the pretend pads */
        return 0;
    }
    g_left = 0;
    reinit(g_net);
    g_want = 1;
    while (!quit_requested && !g_left && !g_sides.done)
        plat_sleep_ms(2);
    g_want = 0;
    drag_on = 0;
    if (!g_sides.done) {
        ob_sides_close(&g_sides);
        return 0;
    }
    return 1;
}

int port_sides_is_open(void) { return g_sides.open; }

/* drag of the Mouse row: the port draws the rectangle under the cursor; Overbar's row moves on drop */
static int drag_x, drag_y, drag_x0, drag_y0, drag_moved;

static void box_fill(uint32_t *px, int w, int h, int pitch, int x, int y, int rw, int rh, uint32_t rgb)
{
    int i, j;
    for (j = 0; j < rh; j++) {
        if (y + j < 0 || y + j >= h) continue;
        for (i = 0; i < rw; i++)
            if (x + i >= 0 && x + i < w) px[(size_t)(y + j) * (size_t)pitch + x + i] = rgb;
    }
}

static void mouse_move_to(int to)
{
    int i = ob_sides_find(&g_sides, g_sides.me, SIDES_LOCAL_MOUSE);
    int from, step[2], n, k;
    if (i < 0 || to < -1) return;
    from = g_sides.d[i].team;
    n = sides_move_inputs(from, to, step);
    for (k = 0; k < n; k++)
        ob_sides_input(&g_sides, SIDES_LOCAL_MOUSE, step[k] ? MDRT_MENU_RIGHT : MDRT_MENU_LEFT);
}

int port_sides_pointer(int x, int y, int button, int what)
{
    int i, w = 0, h = 0, team;
    if (!g_sides.open) { drag_on = 0; return 0; }
    video_mode_size(&w, &h);
    i = ob_sides_find(&g_sides, g_sides.me, SIDES_LOCAL_MOUSE);
    if (what == 0) {
        if (!drag_on) return 0;
        if (x < drag_x0 - 6 || x > drag_x0 + 6 || y < drag_y0 - 6 || y > drag_y0 + 6) drag_moved = 1;
        drag_x = x; drag_y = y;
        return 1;
    }
    if (button == 3 && what == 1 && i >= 0 &&
        sides_device_hit(x, y, i, g_sides.d[i].team, w, h, g_sides.g.teams, g_sides.n)) {
        ob_sides_input(&g_sides, SIDES_LOCAL_MOUSE, MDRT_MENU_BACK);
        return 1;
    }
    if (button != 1) return 0;
    if (what == 1) {
        if (i < 0 || !sides_device_hit(x, y, i, g_sides.d[i].team, w, h, g_sides.g.teams, g_sides.n)) return 0;
        drag_on = 1; drag_moved = 0; drag_x = drag_x0 = x; drag_y = drag_y0 = y;
        return 1;
    }
    if (!drag_on) return 0;
    drag_on = 0;
    team = sides_drop_team(x, y, w, h, g_sides.g.teams, g_sides.n);
    if (!drag_moved && i >= 0 && g_sides.d[i].team >= 0)
        ob_sides_input(&g_sides, SIDES_LOCAL_MOUSE, MDRT_MENU_OK);   /* a click readies it */
    else if (drag_moved && team != -2)
        mouse_move_to(team);
    return 1;
}

void port_sides_draw(uint32_t *px, int w, int h, int pitch)
{
    ob_plat_room_draw(px, w, h, pitch);
    if (!drag_on || !px) return;
    /* the row under the cursor; on release it is the one Overbar draws, in the column it was dropped on */
    box_fill(px, w, h, pitch, drag_x - 36, drag_y - 6, 72, 14, 0xFF303860u);
    mdrt_menu_text(px, w, h, pitch, drag_x - 15, drag_y - 4, "Mouse", 0xFFFFFFFFu);
}

int port_sides_pad_input(int local, int mdrt_input)
{
    int r;
    if (!g_sides.open) return 0;
    r = ob_sides_input(&g_sides, local, mdrt_input);
    if (r == 0 && mdrt_input == MDRT_MENU_BACK) g_left = 1;
    return r ? 1 : (mdrt_input == MDRT_MENU_BACK);
}

unsigned port_sides_filter_hot(unsigned sc, int machine)
{
    static const ob_sides_hotkey key[10] = {
        { 1u << 0, 1 }, { 1u << 1, 1 }, { 1u << 2, 1 }, { 1u << 3, 1 },
        { 1u << 4, 0 }, { 1u << 5, 0 }, { 1u << 6, 0 }, { 1u << 7, 0 },
        { 1u << 8, 1 }, { 1u << 9, 0 }
    };
    unsigned teams = ob_sides_teams_of(&g_sides, machine);
    uint32_t bit;
    if (sc < 0x3Bu || sc > 0x44u) return sc;
    bit = 1u << (sc - 0x3Bu);
    return ob_sides_hotkeys_filter(bit, key, 10, teams) ? sc : 0;
}

#endif
