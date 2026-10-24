/* Misc dialogs: the line editor. */
#define EditTextField EditTextField_decl
#define DrawEditText DrawEditText_decl
#define DrawEditCursor DrawEditCursor_decl
#define TickDeadlinePassed TickDeadlinePassed_decl
#define sub_B3D46 sub_B3D46_decl
#define sub_B3D64 sub_B3D64_decl
#include "nhl95.h"
#undef EditTextField
#undef DrawEditText
#undef DrawEditCursor
#undef TickDeadlinePassed
#undef sub_B3D46
#undef sub_B3D64

void DrawEditText(int flags);
void DrawEditCursor(int flags);
int TickDeadlinePassed(void);
void __cdecl sub_B3D46(int n);
int sub_B3D64(void);

/* DRAFT under 10.0 GA: 71 differing, 29 bytes long. Polling and the late Backspace / typing blocks now
   follow the retail order, with shared clear / text-redraw tails. x is dead after editx is stored and is reused
   for the saved blink state (C_MATCHING: dead parameter reuse). Left: a 0Ch frame vs 8, the insert flag still
   spills while x keeps EBP, and the cursor / insertion temporaries differ. */
/* EditTextField (3170D, PC only): edit the text buf (maxlen characters) in a field w wide at x, y. Draws the text
   and a blinking cursor (DrawEditText / DrawEditCursor, editpos ...); left / right / home / end move the cursor,
   Ins toggles insert mode (a full-height cursor), Del and Backspace delete, and other keys are typed in when flags
   allow them (8: digits only; 10h: letters and spaces; else 20h-7Ah, with 1 letters and digits only). Ends on
   Enter, on Esc when flags has 4, or when timeout ticks pass without a key (SetTickDeadline); idle is called
   while no key is waiting. Result: the last key (0 on a timeout). */
int EditTextField(char *buf, int maxlen, int w, int x, int y, void (*idle)(void), int timeout, int flags)
{
    int key;
    int ins;
    int i;

    sub_B4BA8();
    editx = x;
    edity = y;
    editbuf = buf;
    editmaxw = w;
    editpos = 0;
    DrawEditText(flags);
    editcuron = editcurw = 1;
    ins = 0;
    DrawEditCursor(flags);
    SetTickDeadline(timeout);
    sub_B3D46(4);
    goto poll;
idle_wait:
    if (idle) idle();
    goto poll;
input:
    SetTickDeadline(timeout);
    if (key == 0xD) goto finished;
    if (key == 0x1B && (flags & 4)) goto finished;
    if (key == 0x4D00) {
        if (!buf[editpos]) goto poll;
        DrawEditCursor(flags);
        if (maxlen > editpos) editpos = editpos + 1;
    } else if (key == 0x4B00) {
        DrawEditCursor(flags);
        if (editpos) editpos = editpos - 1;
    } else if (key == 0x4700) {
        DrawEditCursor(flags);
        editpos = 0;
    } else if (key == 0x4F00) {
        DrawEditCursor(flags);
        editpos = 0;
        while (buf[editpos]) editpos++;
    } else if (key == 0x5200) {
        DrawEditCursor(flags);
        if (!ins) {
            ins = 1;
            editcurw = byte_D42C3;
        } else {
            ins = 0;
            editcurw = 1;
        }
    } else if (key == 0x5300) {
        if (maxlen <= editpos || !buf[editpos]) goto poll;
        DrawEditCursor(flags);
        for (i = editpos; i < maxlen; i++) buf[i] = buf[i + 1];
cleartail:
        buf[maxlen - 1] = 0;
redrawtext:
        DrawEditText(flags);
    } else goto otherkey;
    DrawEditCursor(flags);
poll:
    key = PollKey();
    if (!key) {
        if (!sub_B3D64()) goto idle_wait;
        key = 0;
    }
    if (key) goto input;
    sub_B3D46(4);
    x = editcuron;
    editcuron = 1;
    DrawEditCursor(flags);
    editcuron = !x;
    if (timeout && TickDeadlinePassed()) goto finished;
    goto poll;
otherkey:
    if (key == 8) {
        if (!editpos) goto poll;
        DrawEditCursor(flags);
        editpos--;
        for (i = editpos; i < maxlen; i++) buf[i] = buf[i + 1];
        goto cleartail;
    } else {
        if (flags & 8) {
            if (key < '0' || key > '9') goto poll;
        } else if (flags & 0x10) {
            if (key != ' ' && (key < 'A' || key > 'Z') && (key < 'a' || key > 'z')) goto poll;
        } else {
            if (key < 0x20 || key > 0x7A) goto poll;
            if (maxlen <= editpos) goto poll;
            if (!(flags & 1) || ((flags & 1) &&
                (((signed char *)byte_C4B6C)[(unsigned char)(key + 1)] & 0xE0))) {
                /* This key passes the character-class filter. */
            } else goto poll;
        }
        DrawEditCursor(flags);
        if (!ins) {
            if (!buf[editpos]) buf[editpos + 1] = 0;
        } else {
            for (i = maxlen - 2; i >= editpos; i--) buf[i + 1] = buf[i];
        }
        buf[editpos] = key;
        if (maxlen > editpos) editpos++;
        goto redrawtext;
    }
finished:
    DrawEditCursor(flags);
    return key;
}
