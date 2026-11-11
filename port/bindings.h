#ifndef BINDINGS_H
#define BINDINGS_H
#include <stdio.h>

/* What the player can bind. The game reads the keyboard, the mouse buttons and the two game port joysticks; a binding says which key, mouse button or
 * controller button stands for one of the game's own keys or buttons (pass / change player = Alt, shoot / speed burst = Space, hold / change line =
 * both together, ...). The keys are XT scan codes (0x100 = extended), what the game reads from port 60h. */
enum { ACT_UP, ACT_DOWN, ACT_LEFT, ACT_RIGHT, ACT_PASS, ACT_SHOOT, ACT_HOLD, ACT_NUMBERS,
       ACT_HOME1, ACT_HOME2, ACT_HOME3, ACT_HOME4, ACT_AWAY1, ACT_AWAY2, ACT_AWAY3, ACT_AWAY4, ACT_PAUSE, ACT_REPLAY, ACT_GOALIE, NACT };

#define PAD_NONE 0
#define PAD_DEFAULT 1                           /* pass: A or X, shoot: B or Y (the first ones: nothing was bound) */
#define PAD_VALUE(id) ((id) + 2)                /* a controller button: SDL_CONTROLLER_BUTTON_* (0-14), 20 left trigger, 21 right trigger */
#define PAD_ID(v) ((v) - 2)

struct bindings {
    int kb[NACT];                               /* XT scan code of the key that does the action; 0 none */
    int ms[4];                                  /* SDL mouse button for pass, shoot, hold, manual goalie; 0 none */
    int joy[2][NACT];                           /* Joystick One and Two: PAD_NONE, PAD_DEFAULT or PAD_VALUE(button) */
};

extern struct bindings bind;

const char *act_name(int a);                    /* the name in the ini file */
const char *act_label(int a);                   /* the name on the screen */
int act_default_key(int a);                     /* the game's own key for the action (0 for hold: it is two keys) */
void bindings_defaults(struct bindings *b);
void bindings_load(void);                       /* from hockey-win32.ini */
void bindings_save(FILE *f);                    /* into the ini file the video settings are written to (video.c) */
void settings_save_all(void);                   /* video.c: rewrite the ini file */

/* a physical key while a game is on: the game's keys to send (at most 4), or -1 if the key is not bound and goes through as it is */
int bindings_kb(int xt, int *out);
/* the game's mouse buttons (bit 1 left, 2 right) for the physical buttons that are down (index 1-5) */
int bindings_mouse(const unsigned char *down, int *c_first);

/* the game's two buttons (bit 0 pass, bit 1 shoot). Both set is Hold / line change.
 * own: Hold has a button of its own. Then hold_down sets both. Pass together with shoot sets neither,
 * except fake_shot: C was already held and B came down on top of it (the wind-up fake). That still
 * reports both, so the game sees A during the shot and fakes, the way it did before A had its own button. */
int bindings_button_mask(int pass, int shoot, int hold_down, int own, int fake_shot);
/* remember that C (shoot) went down while B (pass) was up. Returns 1 when this sample is the fake:
 * C is still down and B is down too. *c_first is kept until C is released. NULL: not a fake. */
int bindings_note_shot(int *c_first, int pass, int shoot);
/* 1 when custom keys apply: a period is being played, and this is not a menu or a text field */
int bindings_remap_on(int period, int text_field, int in_menu);
/* ACT_PASS .. ACT_HOLD when xt is bound to that button, else -1.
 * *swallow is set when xt is a default button key that was moved and must not reach the game. */
int bindings_button_key(int xt, int *swallow);
/* 1 when some device has Manual goalie assigned (the host sends this at the start of an online match) */
int bindings_goalie_mapped(void);

#ifdef _WIN32
void bindings_dialog_open(void *parent_hwnd);   /* bindings_win.c */
#endif
#endif
