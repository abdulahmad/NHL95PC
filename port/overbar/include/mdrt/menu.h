/* From PulseMan (https://github.com/1nputs/pulseman). MIT License.
 * Copyright (c) 2026 The pulseman authors.
 */

/* A menu drawn over the picture at the console's resolution, in pulseman's own 5 x 8 font (cells
 * of 6 x 10 pixels: 53 columns and 22 rows on a 320 x 224 picture), worked by six inputs. The
 * platform builds its pages and acts on what the player chooses; nothing here knows SDL, files or
 * the game, so a browser's platform can use it the same way.
 *
 * A page: a title, a line under it (a directory, a hint), the items, a message line (what went
 * wrong) and the keys' hint at the bottom. Items: actions (chosen with OK; a detail at the right,
 * such as a file's name or a key), choices (one of some names, changed with LEFT / RIGHT or OK),
 * numbers (min to max by a step), text (not selectable) and fields (a line of text the player types:
 * OK starts typing into it, OK again keeps it, BACK puts it back as it was; the platform passes
 * what is typed to mdrt_menu_type and a backspace to mdrt_menu_erase). A list longer than the
 * screen scrolls.
 * A page can show a picture at the right of its list, at half size (a save slot's). */
#ifndef MDRT_MENU_H
#define MDRT_MENU_H
#include <stdint.h>

#define MDRT_MENU_CELL_W 6
#define MDRT_MENU_CELL_H 10

enum { MDRT_MENU_UP, MDRT_MENU_DOWN, MDRT_MENU_LEFT, MDRT_MENU_RIGHT, MDRT_MENU_OK, MDRT_MENU_BACK };
enum { MDRT_ITEM_ACTION, MDRT_ITEM_CHOICE, MDRT_ITEM_NUMBER, MDRT_ITEM_TEXT, MDRT_ITEM_FIELD };
enum { MDRT_MENU_NOTHING = -1, MDRT_MENU_CLOSE = -2 };    /* what an input did, besides an item's id */

typedef struct mdrt_menu_item {
    int id;                     /* the platform's */
    int kind;
    char label[48];
    char detail[96];            /* at the right: an action's or a text's (a file's name, a key); a field's text */
    const char *const *choices; /* a choice's names, count of them; value is the one chosen */
    int count, value;
    int min, max, step;         /* a number's range and step */
    const char *unit;           /* after a number ("%") */
    const char *allow;          /* a field's characters (NULL: any printable one); max its length */
} mdrt_menu_item;

typedef struct mdrt_menu {
    char title[64], subtitle[160], message[128];
    int editing;                /* the item being typed into (its index), -1 none */
    char was[96];               /* (its text before, for BACK) */
    mdrt_menu_item *items;
    int count, cap, sel, top;
    int rows;                   /* the items the last drawing had room for (a page, for LEFT / RIGHT) */
    const uint32_t *image;      /* a picture beside the list, at half its size (a save slot's); NULL: none */
    int image_w, image_h, image_pitch;
} mdrt_menu;

void mdrt_menu_init(mdrt_menu *m);
void mdrt_menu_free(mdrt_menu *m);
/* a new page: no items, the title, no subtitle or message */
void mdrt_menu_page(mdrt_menu *m, const char *title);
/* an item at the end (NULL when out of memory); a choice and a number with their values */
mdrt_menu_item *mdrt_menu_add(mdrt_menu *m, int id, int kind, const char *label);
mdrt_menu_item *mdrt_menu_add_choice(mdrt_menu *m, int id, const char *label, const char *const *choices, int count, int value);
mdrt_menu_item *mdrt_menu_add_number(mdrt_menu *m, int id, const char *label, int value, int min, int max, int step, const char *unit);
/* a field with its text, up to max characters of allow (NULL: any printable) */
mdrt_menu_item *mdrt_menu_add_field(mdrt_menu *m, int id, const char *label, const char *text, int max, const char *allow);
/* while a field is being typed into (editing >= 0): the text typed (UTF-8: what is not one of its
 * characters is dropped), and a backspace; 1 when the field changed */
int mdrt_menu_type(mdrt_menu *m, const char *text);
int mdrt_menu_erase(mdrt_menu *m);
/* the item with an id (NULL: none); select it (the first selectable one when there is none) */
mdrt_menu_item *mdrt_menu_find(mdrt_menu *m, int id);
void mdrt_menu_select(mdrt_menu *m, int id);
/* an input. UP / DOWN move between the selectable items, around the ends; LEFT / RIGHT change a
 * choice (around its ends) or a number (within its range), or move a page on an action; OK chooses
 * an action, steps a choice, or starts typing into a field. While typing: OK keeps the field's text
 * (its id is returned), BACK puts it back, LEFT erases, the others do nothing. Returns the id of
 * the item chosen or changed, MDRT_MENU_CLOSE for BACK, or MDRT_MENU_NOTHING. */
int mdrt_menu_input(mdrt_menu *m, int input);
/* the page over w x h pixels (0x??RRGGBB, pitch pixels a row), the picture under it darkened */
void mdrt_menu_draw(mdrt_menu *m, uint32_t *px, int w, int h, int pitch);
/* text in the font with its top left at pixel x, y (clipped to the picture); the x after it */
int mdrt_menu_text(uint32_t *px, int w, int h, int pitch, int x, int y, const char *s, uint32_t rgb);

#endif
