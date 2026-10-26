/* Keyboard (port 60h and IRQ 1), mouse and joystick ports. SDL key events become XT scan codes in a queue; the game's own
 * keyboard handler (vector 9) reads them from port 60h exactly like it did from the keyboard controller. */
#include "host.h"
#include "audio.h"
#include <SDL.h>

#define QSIZE 256
static volatile uint8_t queue[QSIZE];
static volatile unsigned qhead, qtail;
static uint8_t last_scan;
static int quit_requested;
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

static void key_event(SDL_Scancode s, int down)
{
    int xt = xt_scancode(s);
    if (!xt) return;
    if (xt & 0x100) push_byte(0xE0);
    push_byte((xt & 0x7F) | (down ? 0 : 0x80));
    irq_raise(1);
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
            key_event(script[script_pos].key, script[script_pos].down);
        }
        script_pos++;
    }
}

/* ---- the host's mouse pointer ----
 * The game moves its pointer by the mouse driver's mickeys (int 33h function 0Bh: x by half a mickey, y by a whole one, clamped to its
 * own range). To make the game's pointer sit under the host's, the motion events only remember where the host's pointer is in the window
 * (win_x, win_y); the next function 0Bh reports the mickeys the game needs to get its pointer (mousex, mousey, read from its memory)
 * from where it is to there. The host's pointer is hidden only while it is over the 4:3 picture of the active window and the game is
 * drawing a pointer of its own (the glove in the menus, which call their pointer routine, the green one in play with the mouse chosen as a controller);
 * otherwise, in the bars, outside the window or while the window is not active, it shows. In fullscreen it stays on the picture. */
extern int32_t mousex, mousey, dword_D2FEC, dword_D2FF0, dword_D2FF4, dword_D2FF8, dword_D3028;
extern uint8_t pad1dev, pad2dev;                /* 1 is the mouse */
extern char sub_B2DCA[];                        /* the menus' pointer routine: it calls function 0Bh from its first instructions */
static volatile int win_x, win_y, win_moved;
static volatile int64_t glove_ns;

static void cursor_update(void)
{
    static int hidden = -1;
    int active = SDL_GetKeyboardFocus() != 0, fs = video_is_fullscreen(), mw, mh, vx, vy, vw, vh, px, py, over, drawn, hide;
    video_mode_size(&mw, &mh);
    video_view(&vx, &vy, &vw, &vh);
    drawn = mw == 320 ? (pad1dev == 1 || pad2dev == 1) : glove_ns && plat_now_ns() - glove_ns < 300000000LL;
    video_confine_mouse(active && (fs || (mw == 320 && drawn)));   /* in play with the mouse as controller it may not leave the picture */
    SDL_GetMouseState(&px, &py);
    over = active && SDL_GetMouseFocus() != 0 && px >= vx && px < vx + vw && py >= vy && py < vy + vh;
    hide = over && drawn;
    if (hide != hidden) { SDL_ShowCursor(hide ? SDL_DISABLE : SDL_ENABLE); hidden = hide; }
}

/* mickeys that take the game's pointer to the host's pointer */
static void mouse_follow(int *cx, int *cy)
{
    int vx, vy, vw, vh, rx = dword_D2FF4 - dword_D2FEC, ry = dword_D2FF8 - dword_D2FF0, tx, ty;
    video_view(&vx, &vy, &vw, &vh);
    if (rx <= 0 || ry <= 0 || vw <= 0 || vh <= 0) { *cx = *cy = 0; return; }
    tx = dword_D2FEC + (win_x - vx) * rx / vw; ty = dword_D2FF0 + (win_y - vy) * ry / vh;
    if (tx < dword_D2FEC) tx = dword_D2FEC;
    if (tx > dword_D2FF4 - 1) tx = dword_D2FF4 - 1;
    if (ty < dword_D2FF0) ty = dword_D2FF0;
    if (ty > dword_D2FF8 - 1) ty = dword_D2FF8 - 1;
    *cx = 2 * (tx - mousex); *cy = ty - mousey;     /* x counts half */
}

/* main thread */
void input_poll(void)
{
    SDL_Event e;
    script_poll();
    joy_update();
    cursor_update();
    while (SDL_PollEvent(&e)) {
        switch (e.type) {
        case SDL_QUIT: quit_requested = 1; break;
        case SDL_JOYDEVICEADDED: case SDL_JOYDEVICEREMOVED: case SDL_CONTROLLERDEVICEADDED: case SDL_CONTROLLERDEVICEREMOVED:
            if (!getenv("NHL95_JOY")) joy_scan();
            break;
        case SDL_KEYDOWN:
            if (e.key.keysym.scancode == SDL_SCANCODE_RETURN && (e.key.keysym.mod & KMOD_ALT)) {    /* Alt+Enter: fullscreen */
                if (!e.key.repeat) video_toggle_fullscreen();
                break;
            }
            if (e.key.keysym.scancode == SDL_SCANCODE_F11 && (e.key.keysym.mod & KMOD_CTRL)) {      /* Ctrl+F11: record the sound */
                if (!e.key.repeat) audio_capture_toggle();
                break;
            }
            if (!e.key.repeat) key_event(e.key.keysym.scancode, 1);
            break;
        case SDL_KEYUP: key_event(e.key.keysym.scancode, 0); break;
        case SDL_MOUSEMOTION: {
            int gx, gy;
            video_window_to_game(e.motion.x, e.motion.y, &gx, &gy);
            mouse_x = gx; mouse_y = gy;
            win_x = e.motion.x; win_y = e.motion.y; win_moved = 1;
            break;
        }
        case SDL_MOUSEBUTTONDOWN: case SDL_MOUSEBUTTONUP: {
            int bit = e.button.button == SDL_BUTTON_LEFT ? 1 : e.button.button == SDL_BUTTON_RIGHT ? 2 : e.button.button == SDL_BUTTON_MIDDLE ? 4 : 0;
            if (e.type == SDL_MOUSEBUTTONDOWN) mouse_buttons |= bit; else mouse_buttons &= ~bit;
            break;
        }
        }
    }
    if (quit_requested) host_exit(0);
}

/* ---- joystick: the PC game port (201h) ----
 * Writing to the port starts one-shot timers; an axis bit (0 and 1: stick A, x and y; 2 and 3: stick B) stays set for a time that grows with
 * the stick's position, and the game counts how long (`in al, dx` in a loop, interrupts off); here the time is a number of reads. The buttons are active-low bits 4 and 5
 * (stick A) and 6 and 7 (stick B). The first game controller (or joystick) SDL finds is stick A, the second one stick B. A stick that is
 * not there reads as 1 on all of its bits (the axes never time out), which is how the game finds out that it is missing. */
#define JOY_MIN_READS 20                        /* an axis at its left / top end stays set for 20 reads of the port after the write, at the other end */
#define JOY_SPAN_READS 200                      /* for 220, in the middle 120: counted in reads, not in time, so the game's calibration does not depend on the speed of the host */
static struct { int present, x, y, b1, b2; SDL_GameController *gc; SDL_Joystick *js; } joy[2];     /* x, y: -1000 to 1000 */
static int joy_reads;                           /* reads of the port since the last write */

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
    for (i = 0; i < 2; i++) {
        if (joy[i].gc) SDL_GameControllerClose(joy[i].gc);
        if (joy[i].js) SDL_JoystickClose(joy[i].js);
        memset(&joy[i], 0, sizeof joy[i]);
    }
}

static void joy_scan(void)                      /* at start and when a device is plugged in or removed */
{
    int n = SDL_NumJoysticks(), i, k = 0;
    joy_close_all();
    if (getenv("NHL95_NOJOY")) return;                          /* some PCs list odd devices as joysticks */
    for (i = 0; i < n && k < 2; i++) {
        if (SDL_IsGameController(i)) joy[k].gc = SDL_GameControllerOpen(i);
        else joy[k].js = SDL_JoystickOpen(i);
        if (joy[k].gc || joy[k].js) {
            joy[k].present = 1;
            fprintf(stderr, "joystick %c: %s\n", 'A' + k, joy[k].gc ? SDL_GameControllerName(joy[k].gc) : SDL_JoystickName(joy[k].js));
            k++;
        }
    }
}

static void joy_update(void)                    /* main thread, every pass of the loop */
{
    int i;
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
            b1 = SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_A) || SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_X);
            b2 = SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_B) || SDL_GameControllerGetButton(g, SDL_CONTROLLER_BUTTON_Y);
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
        if (*(uint32_t *)R(c, ESP) == (uint32_t)(uintptr_t)sub_B2DCA + 8) glove_ns = plat_now_ns();   /* called by the menus' pointer routine */
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
