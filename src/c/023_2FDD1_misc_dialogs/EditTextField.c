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

/* DRAFT under 10.0 GA: 7 differing, same size, no goto. The poll is an inner
   `while (!(key = PollKey())) { if (sub_B3D64()) { key = 0; break; } idle }`, the blink an early
   `if (!key) { ...; continue; }`, and Watcom's jump straightening gives the EXE's bottom poll. Left: the
   parameters x and w tie at savings 3 and w takes EBP (the EXE has x in EBP and w at [esp]); tieorder: that
   one swap gives the EXE bytes. With the dead parameter x as the insert state instead of ins, x's savings
   rise and the function compiles to the EXE bytes (commit b04f5a2), but that is dead-variable reuse
   (ESCALATE), so it is not kept. */
/* EditTextField (3170D, PC only): edit the text buf (maxlen characters) in a field w wide at x, y. Draws the text
   and a blinking cursor (DrawEditText / DrawEditCursor, editpos ...); left / right / home / end move the cursor,
   Ins toggles insert mode (a full-height cursor), Del and Backspace delete, and other keys are typed in when flags
   allow them (8: digits only; 10h: letters and spaces; else 20h-7Ah, with 1 letters and digits only). Ends on
   Enter, on Esc when flags has 4, or when timeout ticks pass without a key (SetTickDeadline); idle is called
   while no key is waiting. Result: the last key (0 on a timeout). */
int EditTextField(char *buf, int maxlen, int w, int x, int y, void (*idle)(void), int timeout, int flags)
{
    int key;
    int i;
    int c;
    int ins;

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
    for (;;) {
        while (!(key = PollKey())) {
            if (sub_B3D64()) {
                key = 0;
                break;
            }
            if (idle) idle();
        }
        if (!key) {
            sub_B3D46(4);
            c = editcuron;
            editcuron = 1;
            DrawEditCursor(flags);
            editcuron = !c;
            if (timeout && TickDeadlinePassed()) break;
            continue;
        }
        SetTickDeadline(timeout);
        if (key == 0xD) break;
        if (key == 0x1B && (flags & 4)) break;
        if (key == 0x4D00) {
            if (!buf[editpos]) continue;
            DrawEditCursor(flags);
            if (maxlen > editpos) editpos = editpos + 1;
            DrawEditCursor(flags);
            continue;
        } else if (key == 0x4B00) {
            DrawEditCursor(flags);
            if (editpos) editpos = editpos - 1;
            DrawEditCursor(flags);
            continue;
        } else if (key == 0x4700) {
            DrawEditCursor(flags);
            editpos = 0;
            DrawEditCursor(flags);
            continue;
        } else if (key == 0x4F00) {
            DrawEditCursor(flags);
            editpos = 0;
            while (buf[editpos]) editpos++;
            DrawEditCursor(flags);
            continue;
        } else if (key == 0x5200) {
            DrawEditCursor(flags);
            if (!ins) {
                ins = 1;
                editcurw = byte_D42C3;
            } else {
                ins = 0;
                editcurw = 1;
            }
            DrawEditCursor(flags);
            continue;
        } else if (key == 0x5300) {
            if (maxlen <= editpos || !buf[editpos]) continue;
            DrawEditCursor(flags);
            for (i = editpos; i < maxlen; i++) buf[i] = buf[i + 1];
            buf[maxlen - 1] = 0;
            DrawEditText(flags);
            DrawEditCursor(flags);
            continue;
        }
        if (key == 8) {
            if (!editpos) continue;
            DrawEditCursor(flags);
            editpos--;
            for (i = editpos; i < maxlen; i++) buf[i] = buf[i + 1];
            buf[maxlen - 1] = 0;
            DrawEditText(flags);
            DrawEditCursor(flags);
            continue;
        } else {
            if (flags & 8) {
                if (!(key >= '0' && key <= '9')) continue;
            } else if (flags & 0x10) {
                if (!(key == ' ' || (key >= 'A' && key <= 'Z') || (key >= 'a' && key <= 'z'))) continue;
            } else {
                if (key < 0x20 || key > 0x7A) continue;
                if (maxlen <= editpos) continue;
                if (!(flags & 1) || ((flags & 1) &&
                    (((signed char *)byte_C4B6C)[(unsigned char)(key + 1)] & 0xE0))) {
                    /* This key passes the character-class filter. */
                } else continue;
            }
            DrawEditCursor(flags);
            if (!ins) {
                if (!buf[editpos]) buf[editpos + 1] = 0;
                buf[editpos] = key;
            } else {
                for (i = maxlen - 2; i >= editpos; i--) buf[i + 1] = buf[i];
                buf[editpos] = key;
            }
            if (maxlen > editpos) editpos++;
            DrawEditText(flags);
            DrawEditCursor(flags);
            continue;
        }
    }
    DrawEditCursor(flags);
    return key;
}
