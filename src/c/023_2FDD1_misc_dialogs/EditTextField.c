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

/* DRAFT under 10.0 GA: 36 differing, 937 vs 936 bytes. Reuse the dead copy-loop index i for the
   letter-filter value (C_MATCHING: dead-local reuse), which keeps that value in EAX and fixes most
   cursor/typing temporaries. x still holds the insert state after editx is stored. Each key arm has its
   own cursor/redraw tail; Watcom merges them after allocation and preserves the required loop weights.
   The outer loop uses continue/break. Four jumps retain the EXE's poll entry, idle/input dispatch and
   late Backspace/typing block; embedding those blocks in structured arms changes the EXE layout.
   Left: timeout/key-chain register picks, the End loop's shared store and a flags-byte reload. */
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

    sub_B4BA8();
    editx = x;
    edity = y;
    editbuf = buf;
    editmaxw = w;
    editpos = 0;
    DrawEditText(flags);
    editcuron = editcurw = 1;
    x = 0;
    DrawEditCursor(flags);
    SetTickDeadline(timeout);
    sub_B3D46(4);
    for (;;) {
        goto poll;
    idle_wait:
        if (idle) idle();
        continue;
    input:
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
            if (!x) {
                x = 1;
                editcurw = byte_D42C3;
            } else {
                x = 0;
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
        } else goto otherkey;
    poll:
        key = PollKey();
        if (!key) {
            if (!sub_B3D64()) goto idle_wait;
            key = 0;
        }
        if (key) goto input;
        sub_B3D46(4);
        c = editcuron;
        editcuron = 1;
        DrawEditCursor(flags);
        editcuron = !c;
        if (timeout && TickDeadlinePassed()) break;
        continue;
    otherkey:
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
                i = key;
                if (!(i == ' ' || (i >= 'A' && i <= 'Z') || (i >= 'a' && i <= 'z'))) continue;
            } else {
                if (key < 0x20 || key > 0x7A) continue;
                if (maxlen <= editpos) continue;
                if (!(flags & 1) || ((flags & 1) &&
                    (((signed char *)byte_C4B6C)[(unsigned char)(key + 1)] & 0xE0))) {
                    /* This key passes the character-class filter. */
                } else continue;
            }
            DrawEditCursor(flags);
            if (!x) {
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
