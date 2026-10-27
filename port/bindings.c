/* Input bindings: which key, mouse button or controller button does what in the game (see bindings.h). Kept in hockey-win32.ini under [input]. */
#include "host.h"
#include "bindings.h"
#include <SDL.h>

struct bindings bind;

static const char *names[NACT] = { "up", "down", "left", "right", "pass", "shoot", "hold", "numbers",
                                   "home1", "home2", "home3", "home4", "away1", "away2", "away3", "away4", "pause", "replay" };
static const char *labels[NACT] = { "Move up", "Move down", "Move left", "Move right", "Pass / change player", "Shoot / speed burst", "Hold / change line",
                                    "Show all player numbers", "Home team line 1", "Home team line 2", "Home team line 3", "Home team line 4",
                                    "Away team line 1", "Away team line 2", "Away team line 3", "Away team line 4", "Pause", "Replay" };
static const int defkeys[NACT] = { 0x148, 0x150, 0x14B, 0x14D, 0x38, 0x39, 0, 0x0F, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F, 0x40, 0x41, 0x42, 0x01, 0x13 };

const char *act_name(int a) { return names[a]; }
const char *act_label(int a) { return labels[a]; }
int act_default_key(int a) { return defkeys[a]; }

void bindings_defaults(struct bindings *b)
{
    int a, j;
    memset(b, 0, sizeof *b);
    for (a = 0; a < NACT; a++) b->kb[a] = defkeys[a];
    b->ms[0] = SDL_BUTTON_LEFT; b->ms[1] = SDL_BUTTON_RIGHT; b->ms[2] = 0;
    for (j = 0; j < 2; j++) { b->joy[j][ACT_PASS] = PAD_DEFAULT; b->joy[j][ACT_SHOOT] = PAD_DEFAULT; }
}

void bindings_load(void)
{
    char path[1100], line[256], *base = SDL_GetBasePath();
    FILE *f;
    bindings_defaults(&bind);
    snprintf(path, sizeof path, "%s%s", base ? base : "", "hockey-win32.ini");
    SDL_free(base);
    f = fopen(path, "r");
    if (!f) return;
    while (fgets(line, sizeof line, f)) {
        char *k = line, *v = strchr(line, '='), *e;
        int a, val;
        if (!v || line[0] == ';' || line[0] == '[') continue;
        *v++ = 0;
        for (e = v + strlen(v); e > v && (e[-1] == '\n' || e[-1] == '\r' || e[-1] == ' '); ) *--e = 0;
        val = (int)strtol(v, NULL, 0);
        for (a = 0; a < NACT; a++) {
            char key[48];
            snprintf(key, sizeof key, "kb_%s", names[a]);
            if (!strcmp(k, key)) bind.kb[a] = val;
            snprintf(key, sizeof key, "joy1_%s", names[a]);
            if (!strcmp(k, key)) bind.joy[0][a] = val;
            snprintf(key, sizeof key, "joy2_%s", names[a]);
            if (!strcmp(k, key)) bind.joy[1][a] = val;
        }
        if (!strcmp(k, "ms_pass")) bind.ms[0] = val;
        else if (!strcmp(k, "ms_shoot")) bind.ms[1] = val;
        else if (!strcmp(k, "ms_hold")) bind.ms[2] = val;
    }
    fclose(f);
}

void bindings_save(FILE *f)
{
    int a;
    fprintf(f, "[input]\n; Which key, mouse button or controller button does what in a game (set from the Input bindings window). Keys are XT scan codes\n");
    fprintf(f, "; (hex, 0x100 added for the extended ones), mouse buttons are SDL numbers (1 left, 2 middle, 3 right, 4, 5), controller buttons are 0 none,\n");
    fprintf(f, "; 1 the default (pass: A or X, shoot: B or Y), or the SDL controller button plus 2 (20 and 21 are the triggers, plus 2).\n");
    for (a = 0; a < NACT; a++) fprintf(f, "kb_%s=0x%X\n", names[a], bind.kb[a]);
    fprintf(f, "ms_pass=%d\nms_shoot=%d\nms_hold=%d\n", bind.ms[0], bind.ms[1], bind.ms[2]);
    for (a = 0; a < NACT; a++) if (a >= ACT_PASS) fprintf(f, "joy1_%s=%d\n", names[a], bind.joy[0][a]);
    for (a = 0; a < NACT; a++) if (a >= ACT_PASS) fprintf(f, "joy2_%s=%d\n", names[a], bind.joy[1][a]);
}

/* The keys the game sees for a physical key during a game. An action's game key is sent for the key bound to it; the game's own key of an action
 * that is bound to another key does not work any more (the numeric pad is the same key as the arrows to the game, so it goes too); every other key
 * goes through. Outside a game (the menus and their text fields) nothing is changed: the caller does not ask. */
int bindings_kb(int xt, int *out)
{
    int a, n = 0, matched = 0;
    for (a = 0; a < NACT; a++) {
        if (!bind.kb[a] || bind.kb[a] != xt) continue;
        matched = 1;
        if (a == ACT_HOLD) { out[n++] = 0x38; out[n++] = 0x39; }
        else if (n < 4) out[n++] = defkeys[a];
    }
    if (matched) return n;
    for (a = 0; a < NACT; a++)
        if (a != ACT_HOLD && bind.kb[a] != defkeys[a] && (defkeys[a] & 0xFF) == (xt & 0xFF)) return 0;
    return -1;
}

int bindings_mouse(const unsigned char *down)
{
    int bits = 0;
    if (bind.ms[0] && down[bind.ms[0]]) bits |= 1;
    if (bind.ms[1] && down[bind.ms[1]]) bits |= 2;
    if (bind.ms[2] && down[bind.ms[2]]) bits |= 3;
    return bits;
}
