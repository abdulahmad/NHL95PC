/* Keyboard (port 60h and IRQ 1), mouse and joystick ports. SDL key events become XT scan codes in a queue; the game's own
 * keyboard handler (vector 9) reads them from port 60h exactly like it did from the keyboard controller. */
#include "host.h"
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
static struct { int64_t at; SDL_Scancode key; int down; int kind, x, y; } script[256];     /* kind 0: key, 1: move the mouse, 2: left button */
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

/* main thread */
void input_poll(void)
{
    SDL_Event e;
    script_poll();
    while (SDL_PollEvent(&e)) {
        switch (e.type) {
        case SDL_QUIT: quit_requested = 1; break;
        case SDL_KEYDOWN: if (!e.key.repeat) key_event(e.key.keysym.scancode, 1); break;
        case SDL_KEYUP: key_event(e.key.keysym.scancode, 0); break;
        case SDL_MOUSEMOTION: {
            int gx, gy;
            video_window_to_game(e.motion.x, e.motion.y, &gx, &gy);
            mouse_x = gx; mouse_y = gy;
            mickey_x += e.motion.xrel; mickey_y += e.motion.yrel;
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

uint32_t input_port_in(unsigned port)
{
    switch (port) {
    case 0x60:
        if (qhead != qtail) { last_scan = queue[qhead]; qhead = (qhead + 1) % QSIZE; if (qhead != qtail) irq_raise(1); }
        return last_scan;
    case 0x64: return qhead != qtail ? 1 : 0;
    case 0x201: return 0xFF;                    /* no joystick: no button, axes never time out */
    }
    return 0xFF;
}

int input_port_out(unsigned port, uint32_t val)
{
    (void)port; (void)val;
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
        R(c, ECX) = (R(c, ECX) & ~0xFFFFu) | (mickey_x & 0xFFFF); R(c, EDX) = (R(c, EDX) & ~0xFFFFu) | (mickey_y & 0xFFFF);
        mickey_x = mickey_y = 0;
        return 1;
    case 0x1B: R(c, EBX) = (R(c, EBX) & ~0xFFFFu) | 8; R(c, ECX) = (R(c, ECX) & ~0xFFFFu) | 8; R(c, EDX) = (R(c, EDX) & ~0xFFFFu) | 8; return 1;
    }
    return 1;
}
