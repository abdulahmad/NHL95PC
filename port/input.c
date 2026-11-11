/* Keyboard (port 60h and IRQ 1), mouse and joystick ports. SDL key events become XT scan codes in a queue; the game's own
 * keyboard handler (vector 9) reads them from port 60h exactly like it did from the keyboard controller. */
#include "host.h"
#include "pads4.h"
#include "audio.h"
#include "bindings.h"
#include "overbar_client.h"
#include "sides.h"
#include <SDL.h>
#include <overbar/plat.h>
#include "mdrt/menu.h"

#define QSIZE 256
static volatile uint8_t queue[QSIZE];
static volatile unsigned qhead, qtail;
static uint8_t last_scan;

static volatile int mouse_x, mouse_y, mouse_buttons, mickey_x, mickey_y;
static int mouse_range_x = 640, mouse_range_y = 480;

/* SDL scancode (USB usage) to set 1 scancode; 0x100 = extended (E0 prefix) */
static int xt_scancode(SDL_Scancode s)
{
    static const uint8_t letters[26] = { 0x1E, 0x30, 0x2E, 0x20, 0x12, 0x21, 0x22, 0x23, 0x17, 0x24, 0x25, 0x26, 0x32, 0x31, 0x18, 0x19, 0x10, 0x13, 0x1F, 0x14, 0x16, 0x2F, 0x11, 0x2D, 0x15, 0x2C };
    static const uint8_t digits[10] = { 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B };   /* 1..9, 0 */
    if (s >= SDL_SCANCODE_A && s <= SDL_SCANCODE_Z) return letters[s - SDL_SCANCODE_A];
    if (s >= SDL_SCANCODE_1 && s <= SDL_SCANCODE_0) return digits[s - SDL_SCANCODE_1];
    if (s >= SDL_SCANCODE_F1 && s <= SDL_SCANCODE_F10) return 0x3B + (s - SDL_SCANCODE_F1);
    switch (s) {
    case SDL_SCANCODE_F11: return 0x57;
    case SDL_SCANCODE_F12: return 0x58;
    case SDL_SCANCODE_RETURN: return 0x1C;
    case SDL_SCANCODE_ESCAPE: return 0x01;
    case SDL_SCANCODE_BACKSPACE: return 0x0E;
    case SDL_SCANCODE_TAB: return 0x0F;
    case SDL_SCANCODE_SPACE: return 0x39;
    case SDL_SCANCODE_MINUS: return 0x0C;
    case SDL_SCANCODE_EQUALS: return 0x0D;
    case SDL_SCANCODE_LEFTBRACKET: return 0x1A;
    case SDL_SCANCODE_RIGHTBRACKET: return 0x1B;
    case SDL_SCANCODE_BACKSLASH: return 0x2B;
    case SDL_SCANCODE_SEMICOLON: return 0x27;
    case SDL_SCANCODE_APOSTROPHE: return 0x28;
    case SDL_SCANCODE_GRAVE: return 0x29;
    case SDL_SCANCODE_COMMA: return 0x33;
    case SDL_SCANCODE_PERIOD: return 0x34;
    case SDL_SCANCODE_SLASH: return 0x35;
    case SDL_SCANCODE_LSHIFT: return 0x2A;
    case SDL_SCANCODE_RSHIFT: return 0x36;
    case SDL_SCANCODE_LCTRL: return 0x1D;
    case SDL_SCANCODE_RCTRL: return 0x11D;
    case SDL_SCANCODE_LALT: return 0x38;
    case SDL_SCANCODE_RALT: return 0x138;
    case SDL_SCANCODE_CAPSLOCK: return 0x3A;
    case SDL_SCANCODE_UP: return 0x148;
    case SDL_SCANCODE_DOWN: return 0x150;
    case SDL_SCANCODE_LEFT: return 0x14B;
    case SDL_SCANCODE_RIGHT: return 0x14D;
    case SDL_SCANCODE_HOME: return 0x147;
    case SDL_SCANCODE_END: return 0x14F;
    case SDL_SCANCODE_PAGEUP: return 0x149;
    case SDL_SCANCODE_PAGEDOWN: return 0x151;
    case SDL_SCANCODE_INSERT: return 0x152;
    case SDL_SCANCODE_DELETE: return 0x153;
    case SDL_SCANCODE_KP_0: return 0x52;
    case SDL_SCANCODE_KP_1: return 0x4F;
    case SDL_SCANCODE_KP_2: return 0x50;
    case SDL_SCANCODE_KP_3: return 0x51;
    case SDL_SCANCODE_KP_4: return 0x4B;
    case SDL_SCANCODE_KP_5: return 0x4C;
    case SDL_SCANCODE_KP_6: return 0x4D;
    case SDL_SCANCODE_KP_7: return 0x47;
    case SDL_SCANCODE_KP_8: return 0x48;
    case SDL_SCANCODE_KP_9: return 0x49;
    case SDL_SCANCODE_KP_ENTER: return 0x11C;
    case SDL_SCANCODE_KP_PLUS: return 0x4E;
    case SDL_SCANCODE_KP_MINUS: return 0x4A;
    case SDL_SCANCODE_KP_MULTIPLY: return 0x37;
    case SDL_SCANCODE_KP_DIVIDE: return 0x135;
    default: return 0;
    }
}

static void push_byte(uint8_t b)
{
    unsigned next = (qtail + 1) % QSIZE;
    if (next == qhead) return;
    queue[qtail] = b;
    qtail = next;
}

static void key_xt(int xt, int down)
{
    if (!xt) return;
    if (xt & 0x100) push_byte(0xE0);
    push_byte((xt & 0x7F) | (down ? 0 : 0x80));
    irq_raise(1);
}

static void key_event(SDL_Scancode s, int down) { key_xt(xt_scancode(s), down); }

extern int32_t curperiod, dword_CCC9C;          /* curperiod: -1 when no game is on; 0 before any game. CCC9C: paused or replaying */
extern volatile int osk_text_wanted;            /* osk_hook.c: inside EditTextField */

/* custom keys only while a period is being played. A menu (the glove loop, the desk, select-sides,
 * the overlay) and a text field keep the key that was pressed. */
static int kb_remap(void)
{
    int w = 0, h = 0, menu = 0;
    int64_t ns = game_pointer_ns();
    video_mode_size(&w, &h);
    if (port_sides_is_open() || overbar_client_open() || w != 320 || dword_CCC9C) menu = 1;
    if (ns && plat_now_ns() - ns < 300000000LL) menu = 1;
    return bindings_remap_on((int)curperiod, osk_text_wanted, menu);
}

/* Alt and Space, as the game sees them. Both down is Hold; pass and shoot each hold one. */
static int btn_down[3], btn_sent;

static void buttons_sync(int mask)
{
    int rel = btn_sent & ~mask, add = mask & ~btn_sent;
    if (rel & 1) key_xt(0x38, 0);
    if (rel & 2) key_xt(0x39, 0);
    if (add & 1) key_xt(0x38, 1);
    if (add & 2) key_xt(0x39, 1);
    btn_sent = mask;
}

static void buttons_clear(void)
{
    buttons_sync(0);
    btn_down[0] = btn_down[1] = btn_down[2] = 0;
}

/* a key of the keyboard: during play the bindings (bindings.c) may send other keys of the game for it */
static void key_physical(SDL_Scancode s, int down)
{
    int xt = xt_scancode(s), out[4], n, i, swallow = 0, act;
    if (!xt) return;
    if (!kb_remap()) {
        if (btn_sent || btn_down[0] || btn_down[1] || btn_down[2]) buttons_clear();
        key_xt(xt, down);
        return;
    }
    act = bindings_button_key(xt, &swallow);
    if (act >= ACT_PASS && act <= ACT_HOLD) {
        btn_down[act - ACT_PASS] = down ? 1 : 0;
        buttons_sync(bindings_button_mask(btn_down[0], btn_down[1], btn_down[2], bind.kb[ACT_HOLD] != 0));
        return;
    }
    if (swallow) return;
    n = bindings_kb(xt, out);
    if (n < 0) { key_xt(xt, down); return; }
    for (i = 0; i < n; i++) key_xt(out[i], down);
}

/* NHL95_KEYS="ms:Key[/hold] ...": presses keys at given times after start (SDL key names, hold in ms, default 100), for testing
 * without a display, e.g. NHL95_KEYS="9000:Return 12000:Down 12500:Return 20000:Up/2000". "ms:@x,y" puts the mouse at x,y (game screen
 * pixels) and "ms:@click[/hold]" presses the left button. */
static void joy_scan(void);
static void joy_update(void);
static void joy_set_test(int x, int y, int b1, int b2);
static struct { int64_t at; SDL_Scancode key; int down; int kind, x, y, b1, b2; } script[256];     /* kind 0: key, 1: move the mouse, 2: left button, 3: stick A */
static int script_n, script_pos;

static void script_load(void)
{
    const char *s = getenv("NHL95_KEYS");
    char name[64];
    long at, hold;
    int len, i, j;
    while (s && *s && script_n < 254) {
        hold = 100;
        if (sscanf(s, " %ld:%63[^/ ]%n", &at, name, &len) < 2) break;
        s += len;
        if (*s == '/') { hold = strtol(s + 1, (char **)&s, 10); }
        SDL_Scancode k;
        int mx, my;
        if (!strncmp(name, "@joy=", 5)) {                 /* "@joy=x,y,b1,b2": stick A at x,y percent with the buttons b1, b2 (0 or 1) */
            int jx, jy, jb1, jb2;
            if (sscanf(name + 5, "%d,%d,%d,%d", &jx, &jy, &jb1, &jb2) == 4) {
                script[script_n].at = at * 1000000LL; script[script_n].kind = 3; script[script_n].x = jx; script[script_n].y = jy;
                script[script_n].b1 = jb1; script[script_n++].b2 = jb2;
            } else fprintf(stderr, "NHL95_KEYS: bad %s\n", name);
            continue;
        }
        if (name[0] == '@') {                           /* "@x,y": the mouse goes there (game screen pixels); "@click": the left button */
            if (sscanf(name, "@%d,%d", &mx, &my) == 2) {
                script[script_n].at = at * 1000000LL; script[script_n].kind = 1; script[script_n].x = mx; script[script_n++].y = my;
            } else if (!strcmp(name, "@click")) {
                script[script_n].at = at * 1000000LL; script[script_n].kind = 2; script[script_n++].down = 1;
                script[script_n].at = (at + hold) * 1000000LL; script[script_n].kind = 2; script[script_n++].down = 0;
            } else fprintf(stderr, "NHL95_KEYS: unknown command %s\n", name);
            continue;
        }
        k = SDL_GetScancodeFromName(name);
        if (k == SDL_SCANCODE_UNKNOWN) { fprintf(stderr, "NHL95_KEYS: unknown key %s\n", name); continue; }
        script[script_n].at = at * 1000000LL; script[script_n].key = k; script[script_n++].down = 1;
        script[script_n].at = (at + hold) * 1000000LL; script[script_n].key = k; script[script_n++].down = 0;
    }
    for (i = 1; i < script_n; i++)                      /* by time */
        for (j = i; j > 0 && script[j].at < script[j - 1].at; j--) {
            __typeof__(script[0]) t = script[j]; script[j] = script[j - 1]; script[j - 1] = t;
        }
}

static void intro_skip_start(void);

static void script_poll(void)
{
    static int64_t start;
    if (!start) { start = plat_now_ns(); script_load(); }
    while (script_pos < script_n && plat_now_ns() - start >= script[script_pos].at) {
        if (script[script_pos].kind == 1) {
            mickey_x += script[script_pos].x - mouse_x; mickey_y += script[script_pos].y - mouse_y;
            mouse_x = script[script_pos].x; mouse_y = script[script_pos].y;
            TRACE("NHL95_KEYS: mouse %d,%d\n", mouse_x, mouse_y);
        } else if (script[script_pos].kind == 3) {
            joy_set_test(script[script_pos].x, script[script_pos].y, script[script_pos].b1, script[script_pos].b2);
            TRACE("NHL95_KEYS: stick %d,%d buttons %d %d\n", script[script_pos].x, script[script_pos].y, script[script_pos].b1, script[script_pos].b2);
        } else if (script[script_pos].kind == 2) {
            if (script[script_pos].down) mouse_buttons |= 1; else mouse_buttons &= ~1;
            TRACE("NHL95_KEYS: left button %s\n", script[script_pos].down ? "down" : "up");
        } else {
            TRACE("NHL95_KEYS: %s %s\n", SDL_GetScancodeName(script[script_pos].key), script[script_pos].down ? "down" : "up");
            if (script[script_pos].key == SDL_SCANCODE_GRAVE) { if (script[script_pos].down) video_command(CMD_STATS); }
            else { key_event(script[script_pos].key, script[script_pos].down); if (script[script_pos].down) intro_skip_start(); }
        }
        script_pos++;
    }
}

/* ---- the host's mouse pointer (docs/SDL2_PORT.md, "Mouse behaviour") ----
 * The game moves its pointer by the mouse driver's mickeys (int 33h function 0Bh: x by half a mickey, y by a whole one, clamped to its
 * own range). To make the game's pointer sit under the host's, the motion events only remember where the host's pointer is in the window
 * (win_x, win_y); the next function 0Bh reports the mickeys the game needs to get its pointer (mousex, mousey, read from its memory)
 * from where it is to there.
 *
 * The host's pointer is hidden while it is over the 4:3 picture of the active window and the game is drawing a pointer of its own:
 *   hi-res screens: the hockey glove, which the menus move by running EventToPointer (emu.c notes when); no other hi-res screen has one;
 *   lo-res screens: the glove of the replay (and of the other menus there: a mouse range other than the whole screen, or EventToPointer),
 *                   and the green pointer of play when a player has the mouse as a control device (pad1dev, pad2dev).
 * Otherwise it shows. It may leave the picture and the window, except in play with the mouse as a control device (the game is running:
 * curperiod is not -1, and dword_CCC9C, set while it is paused or replaying, is 0), where it is kept on the picture, and in fullscreen,
 * where it is always kept on the picture. */
extern int32_t mousex, mousey, dword_D2FEC, dword_D2FF0, dword_D2FF4, dword_D2FF8, dword_D3028, inputinstalled, curperiod, dword_CCC9C;
extern uint8_t pad1dev, pad2dev;                /* 1 is the mouse */
extern uint32_t ctl1dev, ctl2dev, ctl1side, ctl2side;        /* the game's controllers: the device (2 Joystick One, 4 Joystick Two, 8 keyboard, 1 mouse) and the side (0 home) */
static volatile int win_x, win_y, win_moved;

/* Any key or mouse button before the front end skips the pioneer and EA Sports screens and the title screen (see overrides.c): the waits are cut to
 * nothing, and F12, which nothing in the game uses, is pressed now and then for the title screen's "any key". It ends when the menus ask for input. */
extern volatile int intro_skip;
static int64_t skip_start, skip_next;

static int skipping;

static void intro_skip_poll(void)
{
    static int down;
    int64_t now = plat_now_ns();
    if (!skipping) return;
    if (game_pointer_ns() || now - skip_start > 15000000000LL) intro_skip = 0;      /* the front end is reached (or the time is up) */
    if (!intro_skip) {                           /* the screen that was skipped is over (the game says so: overrides.c, emu.c) */
        skipping = 0;
        audio_muted = 0;
        if (down) { key_event(SDL_SCANCODE_F12, 0); down = 0; }
        return;
    }
    if (now >= skip_next) {
        down = !down;
        key_event(SDL_SCANCODE_F12, down);
        skip_next = now + 100000000LL;                                   /* every 0.1 s */
    }
}

extern volatile int intro_title;

static void intro_skip_start(void)
{
    if (skipping || intro_title || game_pointer_ns()) return;       /* the title screen has its own skip */
    skipping = 1;
    intro_skip = 1;
    audio_muted = 1;                            /* the sound of the splash screens, sped up, is not worth hearing */
    skip_start = plat_now_ns();
    skip_next = skip_start + 300000000LL;
}

static void cursor_update(void)
{
    static int hidden = -1;
    int active = SDL_GetKeyboardFocus() != 0, fs = video_is_fullscreen(), mw, mh, vx, vy, vw, vh, px, py, over, drawn, hide, play_mouse;
    int64_t hk = game_pointer_ns();
    int mouse_pad = pad1dev == 1 || pad2dev == 1;
    video_mode_size(&mw, &mh);
    video_view(&vx, &vy, &vw, &vh);
    play_mouse = mw == 320 && mouse_pad && curperiod != -1 && dword_CCC9C == 0;
    drawn = (hk && plat_now_ns() - hk < 300000000LL) ||
            (mw == 320 && (mouse_pad || dword_D2FEC != 0 || dword_D2FF0 != 0 || dword_D2FF4 != mw || dword_D2FF8 != mh));
    video_confine_mouse(active && (fs || play_mouse));
    SDL_GetMouseState(&px, &py);
    over = active && SDL_GetMouseFocus() != 0 && px >= vx && px < vx + vw && py >= vy && py < vy + vh;
    if (overbar_client_open()) hide = 0;
    else {
        hide = over && (video_pointer_mode() == 0 ? drawn : video_pointer_mode() == 2);
        if (video_pointer_mode() == 0 && active && fs && curperiod != -1) hide = 1;    /* automatic: always hidden during a game in fullscreen */
    }
    { static int was = -1; if (drawn != was) TRACE("game pointer %d (play with the mouse %d)\n", drawn, play_mouse); was = drawn; }
    if (hide != hidden) { SDL_ShowCursor(hide ? SDL_DISABLE : SDL_ENABLE); hidden = hide; }
}

/* mickeys that take the game's pointer to the host's pointer */
static void mouse_follow(int *cx, int *cy)
{
    int vx, vy, vw, vh, mw, mh, tx, ty;
    video_view(&vx, &vy, &vw, &vh);
    video_mode_size(&mw, &mh);
    if (vw <= 0 || vh <= 0) { *cx = *cy = 0; return; }
    tx = (win_x - vx) * mw / vw; ty = (win_y - vy) * mh / vh;      /* screen pixels, then into the game's range (the pointer's size is taken off it) */
    if (tx < dword_D2FEC) tx = dword_D2FEC;
    if (tx > dword_D2FF4 - 1) tx = dword_D2FF4 - 1;
    if (ty < dword_D2FF0) ty = dword_D2FF0;
    if (ty > dword_D2FF8 - 1) ty = dword_D2FF8 - 1;
    *cx = 2 * (tx - mousex); *cy = ty - mousey;     /* x counts half */
}

/* main thread */
static void overlay_mouse(int wx, int wy, int what)
{
    int vx, vy, vw, vh, mw, mh, r;
    if (!overbar_client_open() || what < 0) return;
    video_view(&vx, &vy, &vw, &vh);
    video_mode_size(&mw, &mh);
    if (vw <= 0 || vh <= 0 || mw <= 0 || mh <= 0) return;
    if (wx < vx || wy < vy || wx >= vx + vw || wy >= vy + vh) return;
    r = overbar_client_pointer((wx - vx) * mw / vw, (wy - vy) * mh / vh, mw, mh, what);
#ifdef _WIN32
    if (what != 0 && r == OB_ID_CONTROLLERS) bindings_dialog_open(NULL);
#else
    (void)r;
#endif
}


/* NHL95_AUTOSKIP=1 (a test aid): skips the pioneer, EA Sports and title screens as a key press would, one after the other, until the
 * front end asks for input, so a test gets to the menus in a few seconds without a script */
extern volatile uint32_t trap_ring[256];
extern volatile unsigned trap_ring_n;
extern volatile int intro_title;
static void autoskip_poll(void)
{
    static int on = -1;
    static int64_t next;
    int64_t now = plat_now_ns();
    if (on < 0) { on = getenv("NHL95_AUTOSKIP") != NULL; next = now + 1500000000LL; }
    if (on > 0) {
        static int64_t beat;
        if (now - beat > 3000000000LL) { beat = now; fprintf(stderr, "autostart: alive, curperiod %d, front end %s, title %d\n", (int)curperiod, game_pointer_ns() ? "reached" : "not yet", intro_title);
            { unsigned i, n = trap_ring_n; fprintf(stderr, "  last traps:"); for (i = 0; i < 6; i++) { uint32_t a = trap_ring[(n - 1 - i) & 255]; fprintf(stderr, " %05X", a & 0x80000000u ? a : (unsigned)(a - (uint32_t)(uintptr_t)sub_10000 + 0x10000)); } fprintf(stderr, "\n"); } }
    }
    if (!on || game_pointer_ns() || now < next) return;
    next = now + 400000000LL;
    if (intro_title) {                          /* the title screen waits for its speech clip: skip it the way a key before the front end would */
        if (!skipping) { skipping = 1; intro_skip = 1; audio_muted = 1; skip_start = now; skip_next = now + 300000000LL; }
        return;
    }
    intro_skip_start();
}

/* The events Overbar's layer (shell.c) did not use: the overlay, its keys, text, Alt+Enter, quit and the bar's are the layer's. These are the game's. */
void input_event(const SDL_Event *ep)
{
    const SDL_Event e = *ep;
    switch (e.type) {
    case SDL_JOYDEVICEADDED: case SDL_JOYDEVICEREMOVED: case SDL_CONTROLLERDEVICEADDED: case SDL_CONTROLLERDEVICEREMOVED:
        if (!getenv("NHL95_JOY")) joy_scan();
        break;
    case SDL_KEYDOWN:
        if (port_sides_is_open() && !e.key.repeat && e.key.keysym.scancode == SDL_SCANCODE_ESCAPE) {
            port_sides_pad_input(0, MDRT_MENU_BACK);
            break;
        }
        if (!e.key.repeat) { key_physical(e.key.keysym.scancode, 1); intro_skip_start(); }
        break;
    case SDL_KEYUP:
        key_physical(e.key.keysym.scancode, 0);
        break;
    case SDL_MOUSEMOTION: {
        int gx, gy;
        if (overbar_client_open()) { overlay_mouse(e.motion.x, e.motion.y, 0); break; }
        video_window_to_game(e.motion.x, e.motion.y, &gx, &gy);
        if (port_sides_is_open()) port_sides_pointer(gx, gy, 0, 0);
        mouse_x = gx; mouse_y = gy;
        win_x = e.motion.x; win_y = e.motion.y; win_moved = 1;
        break;
    }
    case SDL_MOUSEWHEEL:
        if (overbar_client_open()) {
            int mx, my;
            SDL_GetMouseState(&mx, &my);
            overlay_mouse(mx, my, e.wheel.y > 0 ? 3 : e.wheel.y < 0 ? 4 : -1);
        }
        break;
    case SDL_MOUSEBUTTONDOWN: case SDL_MOUSEBUTTONUP: {
        static unsigned char mdown[8];
        int btn = e.button.button;
        if (overbar_client_open()) {
            if (e.type == SDL_MOUSEBUTTONDOWN)
                overlay_mouse(e.button.x, e.button.y, e.button.button == SDL_BUTTON_LEFT ? 1
                              : e.button.button == SDL_BUTTON_RIGHT ? 2 : -1);
            break;
        }
        if (btn >= 1 && btn <= 5) mdown[btn] = e.type == SDL_MOUSEBUTTONDOWN;
        if (port_sides_is_open()) {
            int gx, gy;
            video_window_to_game(e.button.x, e.button.y, &gx, &gy);
            port_sides_pointer(gx, gy, btn, e.type == SDL_MOUSEBUTTONDOWN ? 1 : 2);
            break;
        }
        if (kb_remap()) mouse_buttons = bindings_mouse(mdown);           /* during play: the bindings */
        else mouse_buttons = (mdown[SDL_BUTTON_LEFT] ? 1 : 0) | (mdown[SDL_BUTTON_RIGHT] ? 2 : 0) | (mdown[SDL_BUTTON_MIDDLE] ? 4 : 0);
        if (e.type == SDL_MOUSEBUTTONDOWN) intro_skip_start();
        break;
    }
    }
}

void input_osk_key(int scancode, int down) { key_physical((SDL_Scancode)scancode, down); }

void input_poll(void)
{
    script_poll();
    autoskip_poll();
    joy_update();
    cursor_update();
    intro_skip_poll();
    osk_poll();
    port_sides_poll();
    ob_plat_pump();
    if (quit_requested) host_exit(0);
}

/* ---- joystick: the PC game port (201h) ----
 * Writing to the port starts one-shot timers; an axis bit (0 and 1: stick A, x and y; 2 and 3: stick B) stays set for a time that grows with
 * the stick's position, and the game counts how long (`in al, dx` in a loop, interrupts off); here the time is a number of reads. The buttons are active-low bits 4 and 5
 * (stick A) and 6 and 7 (stick B). The first game controller (or joystick) SDL finds is stick A, the second one stick B. A stick that is
 * not there reads as 1 on all of its bits (the axes never time out), which is how the game finds out that it is missing. */
#define JOY_MIN_READS 20                        /* an axis at its left / top end stays set for 20 reads of the port after the write, at the other end */
#define JOY_SPAN_READS 200                      /* for 220, in the middle 120: counted in reads, not in time, so the game's calibration does not depend on the speed of the host */
#define INPUT_PADS 8                            /* every connected controller on the select-sides screen; the game port still has two sticks */
static struct { int present; SDL_GameController *gc; SDL_Joystick *js; char name[32]; } pads[INPUT_PADS];
static int npads;
static int stick_of[2] = { 0, 1 };              /* which pads[] index is stick A / B; -1 none */
static struct { int present, x, y, b1, b2; SDL_GameController *gc; SDL_Joystick *js; } joy[2];     /* x, y: -1000 to 1000 */
static int joy_reads;                           /* reads of the port since the last write */

int input_pad_count(void) { return npads; }
const char *input_pad_name(int i) { return i >= 0 && i < npads ? pads[i].name : ""; }
void input_bind_stick(int stick, int pad)
{
    if (stick >= 0 && stick < 2) stick_of[stick] = pad;
}

static int pad_button(SDL_GameController *g, int id)       /* a controller button of the bindings: 0-14 buttons, 20 and 21 the triggers */
{
    if (id <= 14) return SDL_GameControllerGetButton(g, (SDL_GameControllerButton)id);
    return SDL_GameControllerGetAxis(g, id == 20 ? SDL_CONTROLLER_AXIS_TRIGGERLEFT : SDL_CONTROLLER_AXIS_TRIGGERRIGHT) > 16000;
}

static int axis_value(int raw)                  /* SDL axis (-32768..32767) to -1000..1000 with a dead zone */
{
    int v = raw * 1000 / 32767, a = v < 0 ? -v : v;
    if (a < 120) return 0;
    a = (a - 120) * 1000 / 880;
    if (a > 1000) a = 1000;
    return v < 0 ? -a : a;
}

static void joy_close_all(void)
{
    int i;
    for (i = 0; i < INPUT_PADS; i++) {
        if (pads[i].gc) SDL_GameControllerClose(pads[i].gc);
        if (pads[i].js) SDL_JoystickClose(pads[i].js);
        memset(&pads[i], 0, sizeof pads[i]);
    }
    npads = 0;
    memset(joy, 0, sizeof joy);
}

static void joy_sync(void)                      /* the two game-port sticks follow stick_of[] (select-sides bind) */
{
    int i;
    for (i = 0; i < 2; i++) {
        int p = stick_of[i];
        if (joy[i].present && !joy[i].gc && !joy[i].js) continue;    /* NHL95_JOY: a fake stick A */
        if (p < 0 || p >= npads || !pads[p].present) {
            memset(&joy[i], 0, sizeof joy[i]);
            continue;
        }
        joy[i].present = 1;
        joy[i].gc = pads[p].gc;
        joy[i].js = pads[p].js;
    }
}

static void joy_scan(void)                      /* at start and when a device is plugged in or removed */
{
    int n = SDL_NumJoysticks(), i, k = 0;
    joy_close_all();
    if (getenv("NHL95_NOJOY")) return;                          /* some PCs list odd devices as joysticks */
    for (i = 0; i < n && k < INPUT_PADS; i++) {
        const char *name;
        if (SDL_IsGameController(i)) pads[k].gc = SDL_GameControllerOpen(i);
        else pads[k].js = SDL_JoystickOpen(i);
        if (!pads[k].gc && !pads[k].js) continue;
        pads[k].present = 1;
        name = pads[k].gc ? SDL_GameControllerName(pads[k].gc) : SDL_JoystickName(pads[k].js);
        snprintf(pads[k].name, sizeof pads[k].name, "%s", name && name[0] ? name : "Controller");
        fprintf(stderr, "joystick %d: %s\n", k, pads[k].name);
        k++;
    }
    npads = k;
    if (stick_of[0] >= npads) stick_of[0] = npads ? 0 : -1;
    if (stick_of[1] >= npads) stick_of[1] = npads > 1 ? 1 : -1;
    joy_sync();
}

static int pad_menu(SDL_GameController *g, SDL_Joystick *j)
{
    int left = 0, right = 0, ok = 0, back = 0;
    if (g) {
        left = SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_DPAD_LEFT)
            || SDL_GameControllerGetAxis(g, SDL_CONTROLLER_AXIS_LEFTX) < -16384;
        right = SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_DPAD_RIGHT)
            || SDL_GameControllerGetAxis(g, SDL_CONTROLLER_AXIS_LEFTX) > 16384;
        ok = SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_A)
            || SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_START);
        back = SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_B)
            || SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_BACK);
    } else if (j) {
        Uint8 hat = SDL_JoystickNumHats(j) ? SDL_JoystickGetHat(j, 0) : 0;
        left = (hat & SDL_HAT_LEFT) || (SDL_JoystickNumAxes(j) > 0 && SDL_JoystickGetAxis(j, 0) < -16384);
        right = (hat & SDL_HAT_RIGHT) || (SDL_JoystickNumAxes(j) > 0 && SDL_JoystickGetAxis(j, 0) > 16384);
        ok = SDL_JoystickNumButtons(j) > 0 && SDL_JoystickGetButton(j, 0);
        back = SDL_JoystickNumButtons(j) > 1 && SDL_JoystickGetButton(j, 1);
    }
    return (left ? 1 : 0) | (right ? 2 : 0) | (ok ? 4 : 0) | (back ? 8 : 0);
}

static void joy_overlay(void)
{
    static int prev, back_was, sides_prev[INPUT_PADS];
    int i, btns = 0, back = 0;
    if (port_sides_is_open()) {
        for (i = 0; i < npads; i++) {
            int now = pad_menu(pads[i].gc, pads[i].js), local = 1 + i;
            if ((now & 1) && !(sides_prev[i] & 1)) port_sides_pad_input(local, MDRT_MENU_LEFT);
            if ((now & 2) && !(sides_prev[i] & 2)) port_sides_pad_input(local, MDRT_MENU_RIGHT);
            if ((now & 4) && !(sides_prev[i] & 4)) port_sides_pad_input(local, MDRT_MENU_OK);
            if ((now & 8) && !(sides_prev[i] & 8)) port_sides_pad_input(local, MDRT_MENU_BACK);
            sides_prev[i] = now;
        }
        return;
    }
    memset(sides_prev, 0, sizeof sides_prev);
    for (i = 0; i < 2; i++) {
        SDL_GameController *g = joy[i].gc;
        if (!g) continue;
        if (SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_BACK)) back = 1;
        if (!overbar_client_open()) continue;
        if (SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_DPAD_UP)
            || SDL_GameControllerGetAxis(g, SDL_CONTROLLER_AXIS_LEFTY) < -16384) btns |= 1;
        if (SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_DPAD_DOWN)
            || SDL_GameControllerGetAxis(g, SDL_CONTROLLER_AXIS_LEFTY) > 16384) btns |= 2;
        if (SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_DPAD_LEFT)
            || SDL_GameControllerGetAxis(g, SDL_CONTROLLER_AXIS_LEFTX) < -16384) btns |= 4;
        if (SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_DPAD_RIGHT)
            || SDL_GameControllerGetAxis(g, SDL_CONTROLLER_AXIS_LEFTX) > 16384) btns |= 8;
        if (SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_A)
            || SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_START)) btns |= 16;
    }
    if (back && !back_was) overbar_client_pad_back();
    back_was = back;
    if (overbar_client_open()) {
        if ((btns & 1) && !(prev & 1)) overbar_client_input(MDRT_MENU_UP);
        if ((btns & 2) && !(prev & 2)) overbar_client_input(MDRT_MENU_DOWN);
        if ((btns & 4) && !(prev & 4)) overbar_client_input(MDRT_MENU_LEFT);
        if ((btns & 8) && !(prev & 8)) overbar_client_input(MDRT_MENU_RIGHT);
        if ((btns & 16) && !(prev & 16)) overbar_client_input(MDRT_MENU_OK);
    }
    prev = btns;
}

/* pads 3 and 4 (pads4.c) read any connected controller as the game's pad byte: direction and buttons as ReadJoyPad
 * makes them (pass A / X, shoot B / Y, both a shoulder button). Made here on the main thread, read by the game thread. */
static volatile uint8_t pad_bytes[INPUT_PADS];

int input_pad_byte(int pad)
{
    return pad >= 0 && pad < INPUT_PADS ? pad_bytes[pad] : 8;
}

static void pad_bytes_update(int paused)
{
    int i;
    for (i = 0; i < INPUT_PADS; i++) {
        int mask = 0, pass = 0, shoot = 0;
        if (!paused && i < npads && pads[i].present) {
            if (pads[i].gc) {
                SDL_GameController *g = pads[i].gc;
                int x = axis_value(SDL_GameControllerGetAxis(g, SDL_CONTROLLER_AXIS_LEFTX));
                int y = axis_value(SDL_GameControllerGetAxis(g, SDL_CONTROLLER_AXIS_LEFTY));
                if (x < -500 || SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_DPAD_LEFT)) mask |= 8;
                if (x > 500 || SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_DPAD_RIGHT)) mask |= 4;
                if (y < -500 || SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_DPAD_UP)) mask |= 1;
                if (y > 500 || SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_DPAD_DOWN)) mask |= 2;
                pass = SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_A) || SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_X);
                shoot = SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_B) || SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_Y);
                if (SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_LEFTSHOULDER) || SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_RIGHTSHOULDER)) pass = shoot = 1;
            } else if (pads[i].js) {
                SDL_Joystick *j = pads[i].js;
                Uint8 hat = SDL_JoystickNumHats(j) ? SDL_JoystickGetHat(j, 0) : 0;
                int x = SDL_JoystickNumAxes(j) > 1 ? axis_value(SDL_JoystickGetAxis(j, 0)) : 0;
                int y = SDL_JoystickNumAxes(j) > 1 ? axis_value(SDL_JoystickGetAxis(j, 1)) : 0;
                if (x < -500 || (hat & SDL_HAT_LEFT)) mask |= 8;
                if (x > 500 || (hat & SDL_HAT_RIGHT)) mask |= 4;
                if (y < -500 || (hat & SDL_HAT_UP)) mask |= 1;
                if (y > 500 || (hat & SDL_HAT_DOWN)) mask |= 2;
                pass = SDL_JoystickNumButtons(j) > 0 && (SDL_JoystickGetButton(j, 0) || (SDL_JoystickNumButtons(j) > 2 && SDL_JoystickGetButton(j, 2)));
                shoot = SDL_JoystickNumButtons(j) > 1 && (SDL_JoystickGetButton(j, 1) || (SDL_JoystickNumButtons(j) > 3 && SDL_JoystickGetButton(j, 3)));
            }
        }
        pad_bytes[i] = pads4_byte(mask, pass, shoot);
    }
}

static void joy_update(void)                    /* main thread, every pass of the loop */
{
    int i;
    joy_sync();
    joy_overlay();
    pad_bytes_update(overbar_client_open() || port_sides_is_open());
    if (overbar_client_open() || port_sides_is_open()) return;          /* the game is paused; do not feed the stick */
    for (i = 0; i < 2; i++) {
        int x = 0, y = 0, b1 = 0, b2 = 0;
        if (joy[i].gc) {
            SDL_GameController *g = joy[i].gc;
            x = axis_value(SDL_GameControllerGetAxis(g, SDL_CONTROLLER_AXIS_LEFTX));
            y = axis_value(SDL_GameControllerGetAxis(g, SDL_CONTROLLER_AXIS_LEFTY));
            if (SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_DPAD_LEFT)) x = -1000;
            if (SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_DPAD_RIGHT)) x = 1000;
            if (SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_DPAD_UP)) y = -1000;
            if (SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_DPAD_DOWN)) y = 1000;
            {
                int pv = bind.joy[i][ACT_PASS], sv = bind.joy[i][ACT_SHOOT], hv = bind.joy[i][ACT_HOLD], a, p, sh, h, bits;
                p = pv == PAD_DEFAULT ? (SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_A) || SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_X)) : pv >= 2 ? pad_button(g, PAD_ID(pv)) : 0;
                sh = sv == PAD_DEFAULT ? (SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_B) || SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_Y)) : sv >= 2 ? pad_button(g, PAD_ID(sv)) : 0;
                h = hv >= 2 ? pad_button(g, PAD_ID(hv)) : 0;
                bits = bindings_button_mask(p, sh, h, hv >= 2);               /* own Hold button: both game buttons; the chord does not */
                b1 = (bits & 1) != 0; b2 = (bits & 2) != 0;
                for (a = ACT_NUMBERS; a < NACT; a++) {                         /* the other keys of the game, from the controller */
                    static unsigned char was[2][NACT];
                    int v = bind.joy[i][a], now = v >= 2 && pad_button(g, PAD_ID(v)) && curperiod != -1, key = act_default_key(a);
                    if (now != was[i][a]) {
                        if (a >= ACT_HOME1 && a <= ACT_HOME4) {                /* the lines of the team this controller plays: home (side 0) or away */
                            int dev = i == 0 ? 2 : 4, side = ctl1dev == (uint32_t)dev ? ctl1side : ctl2dev == (uint32_t)dev ? ctl2side : 0;
                            if (side) key = act_default_key(ACT_AWAY1 + a - ACT_HOME1);
                        }
                        key_xt(key, now);
                        was[i][a] = (unsigned char)now;
                    }
                }
            }
        } else if (joy[i].js) {
            SDL_Joystick *j = joy[i].js;
            Uint8 hat = SDL_JoystickNumHats(j) ? SDL_JoystickGetHat(j, 0) : 0;
            if (SDL_JoystickNumAxes(j) > 1) { x = axis_value(SDL_JoystickGetAxis(j, 0)); y = axis_value(SDL_JoystickGetAxis(j, 1)); }
            if (hat & SDL_HAT_LEFT) x = -1000;
            if (hat & SDL_HAT_RIGHT) x = 1000;
            if (hat & SDL_HAT_UP) y = -1000;
            if (hat & SDL_HAT_DOWN) y = 1000;
            b1 = SDL_JoystickNumButtons(j) > 0 && (SDL_JoystickGetButton(j, 0) || (SDL_JoystickNumButtons(j) > 2 && SDL_JoystickGetButton(j, 2)));
            b2 = SDL_JoystickNumButtons(j) > 1 && (SDL_JoystickGetButton(j, 1) || (SDL_JoystickNumButtons(j) > 3 && SDL_JoystickGetButton(j, 3)));
        } else continue;
        joy[i].x = x; joy[i].y = y; joy[i].b1 = b1; joy[i].b2 = b2;
    }
}

static uint32_t joy_read(void)
{
    int n = ++joy_reads;
    uint32_t v = 0xFF;
    int i;
    for (i = 0; i < 2; i++) {
        int sh = i * 2;
        if (!joy[i].present) continue;
        if (n > JOY_MIN_READS + (joy[i].x + 1000) * JOY_SPAN_READS / 2000) v &= ~(1u << sh);
        if (n > JOY_MIN_READS + (joy[i].y + 1000) * JOY_SPAN_READS / 2000) v &= ~(2u << sh);
        if (joy[i].b1) v &= ~(0x10u << sh);
        if (joy[i].b2) v &= ~(0x20u << sh);
    }
    return v;
}

/* NHL95_JOY="x,y,b1,b2" (percent, then 0 or 1) makes stick A present with that fixed position and buttons, for testing without a pad;
 * the key script has the same as "ms:@joy x,y,b1,b2". */
static void joy_set_test(int x, int y, int b1, int b2)
{
    joy[0].present = 1;
    joy[0].x = x * 10; joy[0].y = y * 10; joy[0].b1 = b1; joy[0].b2 = b2;
    joy[0].gc = 0; joy[0].js = 0;
}

void input_init(void)
{
    const char *e = getenv("NHL95_JOY");
    int x, y, b1, b2;
    bindings_load();
    joy_scan();
    if (e && sscanf(e, "%d,%d,%d,%d", &x, &y, &b1, &b2) == 4) joy_set_test(x, y, b1, b2);
}

uint32_t input_port_in(unsigned port)
{
    switch (port) {
    case 0x60:
        if (qhead != qtail) { last_scan = queue[qhead]; qhead = (qhead + 1) % QSIZE; if (qhead != qtail) irq_raise(1); }
        return last_scan;
    case 0x64: return qhead != qtail ? 1 : 0;
    case 0x201: return joy_read();
    }
    return 0xFF;
}

int input_port_out(unsigned port, uint32_t val)
{
    (void)val;
    if (port == 0x201) joy_reads = 0;                           /* starts the one-shot timers of the axes */
    return 1;
}

/* int 33h, the mouse driver: position and buttons are in game screen pixels */
int input_mouse(ctx_t *c)
{
    switch (R(c, EAX) & 0xFFFF) {
    case 0x00: R(c, EAX) = (R(c, EAX) & ~0xFFFFu) | 0xFFFF; R(c, EBX) = (R(c, EBX) & ~0xFFFFu) | 2; return 1;
    case 0x01: case 0x02: case 0x0A: case 0x0C: case 0x10: case 0x13: case 0x1A: return 1;
    case 0x04:                                  /* set the position: the keyboard moves the game's pointer this way */
        mouse_x = R(c, ECX) & 0xFFFF; mouse_y = R(c, EDX) & 0xFFFF;
        return 1;
    case 0x03:
        R(c, EBX) = (R(c, EBX) & ~0xFFFFu) | mouse_buttons;
        R(c, ECX) = (R(c, ECX) & ~0xFFFFu) | mouse_x; R(c, EDX) = (R(c, EDX) & ~0xFFFFu) | mouse_y;
        return 1;
    case 0x07: mouse_range_x = (R(c, EDX) & 0xFFFF) + 1; return 1;
    case 0x08: mouse_range_y = (R(c, EDX) & 0xFFFF) + 1; return 1;
    case 0x0B:
        if (win_moved) {
            int cx, cy;
            win_moved = 0;
            mouse_follow(&cx, &cy);
            mickey_x = cx; mickey_y = cy;
        }
        R(c, ECX) = (R(c, ECX) & ~0xFFFFu) | (mickey_x & 0xFFFF); R(c, EDX) = (R(c, EDX) & ~0xFFFFu) | (mickey_y & 0xFFFF);
        mickey_x = mickey_y = 0;
        return 1;
    case 0x1B: R(c, EBX) = (R(c, EBX) & ~0xFFFFu) | 8; R(c, ECX) = (R(c, ECX) & ~0xFFFFu) | 8; R(c, EDX) = (R(c, EDX) & ~0xFFFFu) | 8; return 1;
    }
    return 1;
}
