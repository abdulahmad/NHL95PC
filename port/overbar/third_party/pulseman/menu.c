/* From PulseMan (https://github.com/1nputs/pulseman). MIT License.
 * Copyright (c) 2026 The pulseman authors.
 */

/* The menu (mdrt/menu.h): pages of items, the inputs that work them, and the drawing in pulseman's
 * own font. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mdrt/menu.h"

/* the font, drawn for pulseman: ' ' to '~' and three of the menu's own (0x7F a pointer, 0x80 and
 * 0x81 arrows up and down); a row a byte, bit 4 the leftmost of 5 pixels; rows 0-6 the letter,
 * row 7 the descenders */
static const uint8_t font[98][8] = {
    { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },   /*   */
    { 0x04, 0x04, 0x04, 0x04, 0x04, 0x00, 0x04, 0x00 },   /* ! */
    { 0x0A, 0x0A, 0x0A, 0x00, 0x00, 0x00, 0x00, 0x00 },   /* " */
    { 0x00, 0x0A, 0x1F, 0x0A, 0x1F, 0x0A, 0x00, 0x00 },   /* # */
    { 0x04, 0x0F, 0x14, 0x0E, 0x05, 0x1E, 0x04, 0x00 },   /* $ */
    { 0x18, 0x19, 0x02, 0x04, 0x08, 0x13, 0x03, 0x00 },   /* % */
    { 0x0C, 0x12, 0x14, 0x08, 0x15, 0x12, 0x0D, 0x00 },   /* & */
    { 0x04, 0x04, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00 },   /* quote */
    { 0x02, 0x04, 0x08, 0x08, 0x08, 0x04, 0x02, 0x00 },   /* ( */
    { 0x08, 0x04, 0x02, 0x02, 0x02, 0x04, 0x08, 0x00 },   /* ) */
    { 0x00, 0x04, 0x15, 0x0E, 0x15, 0x04, 0x00, 0x00 },   /* * */
    { 0x00, 0x04, 0x04, 0x1F, 0x04, 0x04, 0x00, 0x00 },   /* + */
    { 0x00, 0x00, 0x00, 0x00, 0x00, 0x0C, 0x04, 0x08 },   /* , */
    { 0x00, 0x00, 0x00, 0x1F, 0x00, 0x00, 0x00, 0x00 },   /* - */
    { 0x00, 0x00, 0x00, 0x00, 0x00, 0x0C, 0x0C, 0x00 },   /* . */
    { 0x01, 0x02, 0x02, 0x04, 0x08, 0x08, 0x10, 0x00 },   /* / */
    { 0x0E, 0x11, 0x13, 0x15, 0x19, 0x11, 0x0E, 0x00 },   /* 0 */
    { 0x04, 0x0C, 0x04, 0x04, 0x04, 0x04, 0x0E, 0x00 },   /* 1 */
    { 0x0E, 0x11, 0x01, 0x02, 0x04, 0x08, 0x1F, 0x00 },   /* 2 */
    { 0x1F, 0x02, 0x04, 0x02, 0x01, 0x11, 0x0E, 0x00 },   /* 3 */
    { 0x02, 0x06, 0x0A, 0x12, 0x1F, 0x02, 0x02, 0x00 },   /* 4 */
    { 0x1F, 0x10, 0x1E, 0x01, 0x01, 0x11, 0x0E, 0x00 },   /* 5 */
    { 0x06, 0x08, 0x10, 0x1E, 0x11, 0x11, 0x0E, 0x00 },   /* 6 */
    { 0x1F, 0x01, 0x02, 0x04, 0x08, 0x08, 0x08, 0x00 },   /* 7 */
    { 0x0E, 0x11, 0x11, 0x0E, 0x11, 0x11, 0x0E, 0x00 },   /* 8 */
    { 0x0E, 0x11, 0x11, 0x0F, 0x01, 0x02, 0x0C, 0x00 },   /* 9 */
    { 0x00, 0x0C, 0x0C, 0x00, 0x0C, 0x0C, 0x00, 0x00 },   /* : */
    { 0x00, 0x0C, 0x0C, 0x00, 0x0C, 0x04, 0x08, 0x00 },   /* ; */
    { 0x02, 0x04, 0x08, 0x10, 0x08, 0x04, 0x02, 0x00 },   /* < */
    { 0x00, 0x00, 0x1F, 0x00, 0x1F, 0x00, 0x00, 0x00 },   /* = */
    { 0x08, 0x04, 0x02, 0x01, 0x02, 0x04, 0x08, 0x00 },   /* > */
    { 0x0E, 0x11, 0x01, 0x02, 0x04, 0x00, 0x04, 0x00 },   /* ? */
    { 0x0E, 0x11, 0x01, 0x0D, 0x15, 0x15, 0x0E, 0x00 },   /* @ */
    { 0x0E, 0x11, 0x11, 0x1F, 0x11, 0x11, 0x11, 0x00 },   /* A */
    { 0x1E, 0x11, 0x11, 0x1E, 0x11, 0x11, 0x1E, 0x00 },   /* B */
    { 0x0E, 0x11, 0x10, 0x10, 0x10, 0x11, 0x0E, 0x00 },   /* C */
    { 0x1C, 0x12, 0x11, 0x11, 0x11, 0x12, 0x1C, 0x00 },   /* D */
    { 0x1F, 0x10, 0x10, 0x1E, 0x10, 0x10, 0x1F, 0x00 },   /* E */
    { 0x1F, 0x10, 0x10, 0x1E, 0x10, 0x10, 0x10, 0x00 },   /* F */
    { 0x0E, 0x11, 0x10, 0x17, 0x11, 0x11, 0x0F, 0x00 },   /* G */
    { 0x11, 0x11, 0x11, 0x1F, 0x11, 0x11, 0x11, 0x00 },   /* H */
    { 0x0E, 0x04, 0x04, 0x04, 0x04, 0x04, 0x0E, 0x00 },   /* I */
    { 0x07, 0x02, 0x02, 0x02, 0x02, 0x12, 0x0C, 0x00 },   /* J */
    { 0x11, 0x12, 0x14, 0x18, 0x14, 0x12, 0x11, 0x00 },   /* K */
    { 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x1F, 0x00 },   /* L */
    { 0x11, 0x1B, 0x15, 0x15, 0x11, 0x11, 0x11, 0x00 },   /* M */
    { 0x11, 0x11, 0x19, 0x15, 0x13, 0x11, 0x11, 0x00 },   /* N */
    { 0x0E, 0x11, 0x11, 0x11, 0x11, 0x11, 0x0E, 0x00 },   /* O */
    { 0x1E, 0x11, 0x11, 0x1E, 0x10, 0x10, 0x10, 0x00 },   /* P */
    { 0x0E, 0x11, 0x11, 0x11, 0x15, 0x12, 0x0D, 0x00 },   /* Q */
    { 0x1E, 0x11, 0x11, 0x1E, 0x14, 0x12, 0x11, 0x00 },   /* R */
    { 0x0F, 0x10, 0x10, 0x0E, 0x01, 0x01, 0x1E, 0x00 },   /* S */
    { 0x1F, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x00 },   /* T */
    { 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x0E, 0x00 },   /* U */
    { 0x11, 0x11, 0x11, 0x11, 0x11, 0x0A, 0x04, 0x00 },   /* V */
    { 0x11, 0x11, 0x11, 0x15, 0x15, 0x15, 0x0A, 0x00 },   /* W */
    { 0x11, 0x11, 0x0A, 0x04, 0x0A, 0x11, 0x11, 0x00 },   /* X */
    { 0x11, 0x11, 0x11, 0x0A, 0x04, 0x04, 0x04, 0x00 },   /* Y */
    { 0x1F, 0x01, 0x02, 0x04, 0x08, 0x10, 0x1F, 0x00 },   /* Z */
    { 0x0E, 0x08, 0x08, 0x08, 0x08, 0x08, 0x0E, 0x00 },   /* [ */
    { 0x10, 0x08, 0x08, 0x04, 0x02, 0x02, 0x01, 0x00 },   /* backslash */
    { 0x0E, 0x02, 0x02, 0x02, 0x02, 0x02, 0x0E, 0x00 },   /* ] */
    { 0x04, 0x0A, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00 },   /* ^ */
    { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1F },   /* _ */
    { 0x08, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },   /* ` */
    { 0x00, 0x00, 0x0E, 0x01, 0x0F, 0x11, 0x0F, 0x00 },   /* a */
    { 0x10, 0x10, 0x16, 0x19, 0x11, 0x11, 0x1E, 0x00 },   /* b */
    { 0x00, 0x00, 0x0E, 0x10, 0x10, 0x11, 0x0E, 0x00 },   /* c */
    { 0x01, 0x01, 0x0D, 0x13, 0x11, 0x11, 0x0F, 0x00 },   /* d */
    { 0x00, 0x00, 0x0E, 0x11, 0x1F, 0x10, 0x0E, 0x00 },   /* e */
    { 0x06, 0x09, 0x08, 0x1C, 0x08, 0x08, 0x08, 0x00 },   /* f */
    { 0x00, 0x00, 0x0F, 0x11, 0x11, 0x0F, 0x01, 0x0E },   /* g */
    { 0x10, 0x10, 0x16, 0x19, 0x11, 0x11, 0x11, 0x00 },   /* h */
    { 0x04, 0x00, 0x0C, 0x04, 0x04, 0x04, 0x0E, 0x00 },   /* i */
    { 0x02, 0x00, 0x06, 0x02, 0x02, 0x02, 0x12, 0x0C },   /* j */
    { 0x10, 0x10, 0x12, 0x14, 0x18, 0x14, 0x12, 0x00 },   /* k */
    { 0x0C, 0x04, 0x04, 0x04, 0x04, 0x04, 0x0E, 0x00 },   /* l */
    { 0x00, 0x00, 0x1A, 0x15, 0x15, 0x11, 0x11, 0x00 },   /* m */
    { 0x00, 0x00, 0x16, 0x19, 0x11, 0x11, 0x11, 0x00 },   /* n */
    { 0x00, 0x00, 0x0E, 0x11, 0x11, 0x11, 0x0E, 0x00 },   /* o */
    { 0x00, 0x00, 0x1E, 0x11, 0x11, 0x1E, 0x10, 0x10 },   /* p */
    { 0x00, 0x00, 0x0F, 0x11, 0x11, 0x0F, 0x01, 0x01 },   /* q */
    { 0x00, 0x00, 0x16, 0x19, 0x10, 0x10, 0x10, 0x00 },   /* r */
    { 0x00, 0x00, 0x0F, 0x10, 0x0E, 0x01, 0x1E, 0x00 },   /* s */
    { 0x08, 0x08, 0x1C, 0x08, 0x08, 0x09, 0x06, 0x00 },   /* t */
    { 0x00, 0x00, 0x11, 0x11, 0x11, 0x13, 0x0D, 0x00 },   /* u */
    { 0x00, 0x00, 0x11, 0x11, 0x11, 0x0A, 0x04, 0x00 },   /* v */
    { 0x00, 0x00, 0x11, 0x11, 0x15, 0x15, 0x0A, 0x00 },   /* w */
    { 0x00, 0x00, 0x11, 0x0A, 0x04, 0x0A, 0x11, 0x00 },   /* x */
    { 0x00, 0x00, 0x11, 0x11, 0x11, 0x0F, 0x01, 0x0E },   /* y */
    { 0x00, 0x00, 0x1F, 0x02, 0x04, 0x08, 0x1F, 0x00 },   /* z */
    { 0x02, 0x04, 0x04, 0x08, 0x04, 0x04, 0x02, 0x00 },   /* { */
    { 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x00 },   /* | */
    { 0x08, 0x04, 0x04, 0x02, 0x04, 0x04, 0x08, 0x00 },   /* } */
    { 0x00, 0x00, 0x08, 0x15, 0x02, 0x00, 0x00, 0x00 },   /* ~ */
    { 0x10, 0x18, 0x1C, 0x1E, 0x1C, 0x18, 0x10, 0x00 },   /* pointer */
    { 0x00, 0x04, 0x0E, 0x1F, 0x00, 0x00, 0x00, 0x00 },   /* up */
    { 0x00, 0x1F, 0x0E, 0x04, 0x00, 0x00, 0x00, 0x00 },   /* down */
};

#define CW MDRT_MENU_CELL_W
#define CH MDRT_MENU_CELL_H
#define TITLE  0xFFD84Au
#define TEXT   0xF4F4F4u
#define GREY   0x98A0B4u
#define BAR    0x2A4C9Cu
#define WARN   0xFF9A6Au

static void copy(char *to, size_t n, const char *s) { snprintf(to, n, "%s", s ? s : ""); }
#define COPY(a, s) copy(a, sizeof a, s)

void mdrt_menu_init(mdrt_menu *m)
{
    memset(m, 0, sizeof *m);
    m->rows = 16;
    m->editing = -1;
}

void mdrt_menu_free(mdrt_menu *m)
{
    free(m->items);
    mdrt_menu_init(m);
}

void mdrt_menu_page(mdrt_menu *m, const char *title)
{
    m->count = m->sel = m->top = 0;
    m->editing = -1;
    m->image = NULL;
    COPY(m->title, title);
    m->subtitle[0] = m->message[0] = 0;
}

mdrt_menu_item *mdrt_menu_add(mdrt_menu *m, int id, int kind, const char *label)
{
    if (m->count == m->cap) {
        int cap = m->cap ? 2 * m->cap : 16;
        mdrt_menu_item *items = realloc(m->items, (size_t)cap * sizeof *items);
        if (!items) return NULL;
        m->items = items;
        m->cap = cap;
    }
    mdrt_menu_item *it = &m->items[m->count++];
    memset(it, 0, sizeof *it);
    it->id = id;
    it->kind = kind;
    COPY(it->label, label);
    return it;
}

mdrt_menu_item *mdrt_menu_add_choice(mdrt_menu *m, int id, const char *label, const char *const *choices, int count, int value)
{
    mdrt_menu_item *it = mdrt_menu_add(m, id, MDRT_ITEM_CHOICE, label);
    if (!it) return NULL;
    it->choices = choices;
    it->count = count;
    it->value = value < 0 || value >= count ? 0 : value;
    return it;
}

mdrt_menu_item *mdrt_menu_add_number(mdrt_menu *m, int id, const char *label, int value, int min, int max, int step, const char *unit)
{
    mdrt_menu_item *it = mdrt_menu_add(m, id, MDRT_ITEM_NUMBER, label);
    if (!it) return NULL;
    it->min = min;
    it->max = max;
    it->step = step > 0 ? step : 1;
    it->value = value < min ? min : value > max ? max : value;
    it->unit = unit;
    return it;
}

mdrt_menu_item *mdrt_menu_add_field(mdrt_menu *m, int id, const char *label, const char *text, int max, const char *allow)
{
    mdrt_menu_item *it = mdrt_menu_add(m, id, MDRT_ITEM_FIELD, label);
    if (!it) return NULL;
    it->max = max > 0 && max < (int)sizeof it->detail ? max : (int)sizeof it->detail - 1;
    it->allow = allow;
    snprintf(it->detail, (size_t)it->max + 1, "%s", text ? text : "");
    return it;
}

int mdrt_menu_type(mdrt_menu *m, const char *text)
{
    if (m->editing < 0 || m->editing >= m->count) return 0;
    mdrt_menu_item *it = &m->items[m->editing];
    size_t n = strlen(it->detail);
    int changed = 0;
    for (const unsigned char *c = (const unsigned char *)text; *c; c++) {
        if (*c < 32 || *c > 126 || (it->allow && !strchr(it->allow, *c))) continue;   /* (one of its characters only) */
        if ((int)n >= it->max) break;
        it->detail[n++] = (char)*c;
        it->detail[n] = 0;
        changed = 1;
    }
    return changed;
}

int mdrt_menu_erase(mdrt_menu *m)
{
    if (m->editing < 0 || m->editing >= m->count) return 0;
    char *d = m->items[m->editing].detail;
    size_t n = strlen(d);
    if (!n) return 0;
    d[n - 1] = 0;
    return 1;
}

static int selectable(const mdrt_menu *m, int i) { return i >= 0 && i < m->count && m->items[i].kind != MDRT_ITEM_TEXT; }

int mdrt_menu_at(const mdrt_menu *m, int x, int y, int w, int h)
{
    int cols, rows, x0, y0, list, row, i;
    if (!m || w <= 0 || h <= 0) return -1;
    cols = w / CW;
    rows = h / CH;
    if (cols < 12 || rows < 8) return -1;
    x0 = (w - cols * CW) / 2;
    y0 = (h - rows * CH) / 2;
    list = rows - 6;
    if (x < x0 || y < y0) return -1;
    row = (y - y0) / CH;
    if (row < 3 || row >= 3 + list) return -1;
    i = m->top + (row - 3);
    return selectable(m, i) ? i : -1;
}

mdrt_menu_item *mdrt_menu_find(mdrt_menu *m, int id)
{
    for (int i = 0; i < m->count; i++) if (m->items[i].id == id) return &m->items[i];
    return NULL;
}

void mdrt_menu_select(mdrt_menu *m, int id)
{
    int first = -1;
    for (int i = 0; i < m->count; i++) {
        if (!selectable(m, i)) continue;
        if (first < 0) first = i;
        if (m->items[i].id == id) { m->sel = i; return; }
    }
    m->sel = first < 0 ? 0 : first;
}

/* to the next selectable item that way, around the ends */
static void move(mdrt_menu *m, int dir)
{
    for (int k = 1; k <= m->count; k++) {
        int i = ((m->sel + dir * k) % m->count + m->count) % m->count;
        if (selectable(m, i)) { m->sel = i; return; }
    }
}

int mdrt_menu_input(mdrt_menu *m, int input)
{
    if (m->editing >= 0 && m->editing < m->count) {      /* typing into a field */
        mdrt_menu_item *f = &m->items[m->editing];
        if (input == MDRT_MENU_OK) { m->editing = -1; return f->id; }
        if (input == MDRT_MENU_BACK) { COPY(f->detail, m->was); m->editing = -1; return MDRT_MENU_NOTHING; }
        if (input == MDRT_MENU_LEFT) mdrt_menu_erase(m);
        return MDRT_MENU_NOTHING;
    }
    if (input == MDRT_MENU_BACK) return MDRT_MENU_CLOSE;
    if (!m->count) return MDRT_MENU_NOTHING;
    if (!selectable(m, m->sel)) move(m, 1);
    if (!selectable(m, m->sel)) return MDRT_MENU_NOTHING;
    mdrt_menu_item *it = &m->items[m->sel];
    int d = input == MDRT_MENU_RIGHT || input == MDRT_MENU_DOWN ? 1 : -1;
    switch (input) {
    case MDRT_MENU_UP: case MDRT_MENU_DOWN:
        move(m, d);
        return MDRT_MENU_NOTHING;
    case MDRT_MENU_LEFT: case MDRT_MENU_RIGHT:
        if (it->kind == MDRT_ITEM_CHOICE && it->count > 0) {
            it->value = (it->value + d + it->count) % it->count;
            return it->id;
        }
        if (it->kind == MDRT_ITEM_NUMBER) {
            int v = it->value + d * it->step;
            v = v < it->min ? it->min : v > it->max ? it->max : v;
            if (v == it->value) return MDRT_MENU_NOTHING;
            it->value = v;
            return it->id;
        }
        {                                                 /* a page of the list */
            int i = m->sel + d * (m->rows > 1 ? m->rows - 1 : 1);
            i = i < 0 ? 0 : i >= m->count ? m->count - 1 : i;
            while (!selectable(m, i) && i > 0 && i < m->count - 1) i += d;
            if (selectable(m, i)) m->sel = i;
        }
        return MDRT_MENU_NOTHING;
    case MDRT_MENU_OK:
        if (it->kind == MDRT_ITEM_ACTION) return it->id;
        if (it->kind == MDRT_ITEM_FIELD) { m->editing = m->sel; COPY(m->was, it->detail); return MDRT_MENU_NOTHING; }
        if (it->kind == MDRT_ITEM_CHOICE && it->count > 0) {
            it->value = (it->value + 1) % it->count;
            return it->id;
        }
        return MDRT_MENU_NOTHING;
    default:
        return MDRT_MENU_NOTHING;
    }
}

/* ---- the drawing --------------------------------------------------------------------------- */

static void put(uint32_t *px, int w, int h, int pitch, int x, int y, uint32_t rgb)
{
    /* Overlay pixels are ARGB. RGB-only colours (and a 0 shadow) used to leave
     * A=0, which SDL_BLENDMODE_BLEND and some D3D paths drop entirely. */
    if (!(rgb >> 24)) rgb |= 0xFF000000u;
    if (x >= 0 && y >= 0 && x < w && y < h) px[y * pitch + x] = rgb;
}

static int glyphs(uint32_t *px, int w, int h, int pitch, int x, int y, const char *s, uint32_t rgb)
{
    for (; *s; s++, x += CW) {
        unsigned c = (uint8_t)*s;
        const uint8_t *g = font[c >= 32 && c < 32 + 98 ? c - 32 : '?' - 32];
        for (int r = 0; r < 8; r++)
            for (int b = 0; b < 5; b++)
                if (g[r] >> (4 - b) & 1) put(px, w, h, pitch, x + b, y + r, rgb);
    }
    return x;
}

int mdrt_menu_text(uint32_t *px, int w, int h, int pitch, int x, int y, const char *s, uint32_t rgb)
{
    glyphs(px, w, h, pitch, x + 1, y + 1, s, 0xFF000000u); /* (a shadow, for any picture under it) */
    return glyphs(px, w, h, pitch, x, y, s, rgb);
}

/* s in n columns: cut at its end with ".." (or, tail, at its start: a path's end matters most) */
static void fit(char *out, size_t size, const char *s, int n, int tail)
{
    int len = (int)strlen(s);
    if (n <= 0) { out[0] = 0; return; }
    if (len <= n) { copy(out, size, s); return; }
    if (n <= 2) { snprintf(out, size, "%.*s", n, tail ? s + len - n : s); return; }
    if (tail) snprintf(out, size, "..%s", s + len - (n - 2));
    else snprintf(out, size, "%.*s..", n - 2, s);
}

static void row_text(uint32_t *px, int w, int h, int pitch, int x0, int y0, int col, int row, const char *s, uint32_t rgb)
{
    mdrt_menu_text(px, w, h, pitch, x0 + col * CW, y0 + row * CH + 1, s, rgb);
}

void mdrt_menu_draw(mdrt_menu *m, uint32_t *px, int w, int h, int pitch)
{
    for (int y = 0; y < h; y++)                           /* the picture under it, a quarter as bright */
        for (int x = 0; x < w; x++)
            px[y * pitch + x] = (px[y * pitch + x] >> 2 & 0x3F3F3Fu) | 0xFF000000u;
    int cols = w / CW, rows = h / CH, x0 = (w - cols * CW) / 2, y0 = (h - rows * CH) / 2;
    if (cols < 12 || rows < 8) return;
    int list = rows - 6;                                  /* title, subtitle, a gap; the list; arrow, message, keys */
    m->rows = list;
    if (m->sel < m->top) m->top = m->sel;
    if (m->sel >= m->top + list) m->top = m->sel - list + 1;
    if (m->top > m->count - list) m->top = m->count - list > 0 ? m->count - list : 0;
    char buf[200];
    fit(buf, sizeof buf, m->title, cols - 2, 0);
    row_text(px, w, h, pitch, x0 + (cols - (int)strlen(buf)) * CW / 2, y0, 0, 0, buf, TITLE);
    fit(buf, sizeof buf, m->subtitle, cols - 2, 1);
    row_text(px, w, h, pitch, x0, y0, 1, 1, buf, GREY);
    if (m->top > 0) row_text(px, w, h, pitch, x0, y0, cols - 2, 2, "\x80", GREY);
    for (int r = 0; r < list && m->top + r < m->count; r++) {
        int i = m->top + r, y = y0 + (3 + r) * CH;
        const mdrt_menu_item *it = &m->items[i];
        if (i == m->sel && selectable(m, i)) {
            for (int yy = y - 1; yy < y + CH - 1; yy++)
                for (int xx = x0 + CW - 2; xx < x0 + (cols - 1) * CW + 1; xx++) put(px, w, h, pitch, xx, yy, BAR);
            row_text(px, w, h, pitch, x0, y0, 1, 3 + r, "\x7f", TITLE);
        }
        char right[120] = "";
        if (it->kind == MDRT_ITEM_CHOICE && it->count > 0) {
            const char *name = it->choices[it->value];
            if (i == m->sel) snprintf(right, sizeof right, "< %s >", name);
            else copy(right, sizeof right, name);
        } else if (it->kind == MDRT_ITEM_NUMBER) {
            if (i == m->sel) snprintf(right, sizeof right, "< %d%s >", it->value, it->unit ? it->unit : "");
            else snprintf(right, sizeof right, "%d%s", it->value, it->unit ? it->unit : "");
        } else if (it->kind == MDRT_ITEM_FIELD) {
            if (i == m->editing) snprintf(right, sizeof right, "[%s_]", it->detail);
            else snprintf(right, sizeof right, "[%s]", it->detail);
        } else copy(right, sizeof right, it->detail);
        int room = cols - 4, label = (int)strlen(it->label), rlen = (int)strlen(right);
        if (rlen && label + 2 + rlen > room) {           /* the label keeps up to 16 columns, the detail the rest */
            int keep = label < 16 ? label : 16;
            if (rlen > room - keep - 2) rlen = room - keep - 2;
            label = room - rlen - 2;
        }
        uint32_t ink = it->kind == MDRT_ITEM_TEXT ? GREY : TEXT;
        fit(buf, sizeof buf, it->label, label, 0);
        row_text(px, w, h, pitch, x0, y0, 3, 3 + r, buf, ink);
        if (rlen > 0) {
            fit(buf, sizeof buf, right, rlen, it->kind == MDRT_ITEM_ACTION || it->kind == MDRT_ITEM_TEXT || it->kind == MDRT_ITEM_FIELD);
            row_text(px, w, h, pitch, x0, y0, cols - 2 - (int)strlen(buf), 3 + r, buf, i == m->sel ? TITLE : ink);
        }
    }
    if (m->top + list < m->count) row_text(px, w, h, pitch, x0, y0, cols - 2, 3 + list, "\x81", GREY);
    if (m->image && m->image_w > 1 && m->image_h > 1) {   /* the picture, half size, at the list's right with a frame */
        int iw = m->image_w / 2, ih = m->image_h / 2, ix = x0 + (cols - 1) * CW - iw, iy = y0 + 3 * CH;
        for (int y = -1; y <= ih; y++)
            for (int x = -1; x <= iw; x++) {
                uint32_t c = x < 0 || y < 0 || x == iw || y == ih ? GREY : m->image[(2 * y) * m->image_pitch + 2 * x] & 0xFFFFFFu;
                put(px, w, h, pitch, ix + x, iy + y, c);
            }
    }
    fit(buf, sizeof buf, m->message, cols - 2, 0);
    row_text(px, w, h, pitch, x0, y0, 1, rows - 2, buf, WARN);
    const mdrt_menu_item *it = m->count && selectable(m, m->sel) ? &m->items[m->sel] : NULL;
    const char *keys = m->editing >= 0 ? "Type it   Enter: keep it   Esc: as it was"
                     : it && it->kind == MDRT_ITEM_FIELD ? "Enter: type into it   Esc/B: back"
                     : it && (it->kind == MDRT_ITEM_CHOICE || it->kind == MDRT_ITEM_NUMBER)
                     ? "Enter/A: choose   Esc/B: back   < >: change" : "Enter/A: choose   Esc/B: back";
    fit(buf, sizeof buf, keys, cols - 2, 0);
    row_text(px, w, h, pitch, x0 + (cols - (int)strlen(buf)) * CW / 2, y0, 0, rows - 1, buf, GREY);
}
