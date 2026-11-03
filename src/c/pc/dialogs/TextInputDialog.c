/* Misc dialogs: the text input box and the message box that ends in its pops. */
#define EditTextField EditTextField_decl
#define unknown_libname_4 unknown_libname_4_decl
#define MessageBox MessageBox_decl
#define RunMessageBox RunMessageBox_decl
#define GrowToButtons GrowToButtons_decl
#define DrawButtons DrawButtons_decl
#include "nhl95.h"
#undef MessageBox
#undef RunMessageBox
#undef GrowToButtons
#undef DrawButtons
#undef EditTextField
#undef unknown_libname_4

int EditTextField(char *buf, int maxlen, int w, int x, int y, int (*cb)(void), int a, int b);
int unknown_libname_4(char *s);  /* Watcom CRT atoi */

typedef struct DlgBtn {
    int x1, y1, x2, y2;
    int pressed;
    int flags;
    int pad;
} DlgBtn;

int RunMessageBox(int *xptr, int *yptr, DlgBtn *b, int n);
void GrowToButtons(DlgBtn *b, int n, int *w, int *h);
void DrawButtons(DlgBtn *b, int n);

/* TextInputDialog (2FEDF, PC only; owner of DlgNullCallback): ask for a line of text in a centred box: the prompt
   above a field wide enough for maxlen "M"s (at least minw), the box sized to fit both. Wait for Enter and Esc
   to be released, then edit the field (EditTextField). With numeric set the text must read as a number from lo
   to hi (digits, or a leading space or minus; atoi) or the field is asked again; with required set an empty
   field is only taken with Esc. Then wait for the keys again and restore the screen. prompt: the prompt; buf:
   the text (cleared first); maxlen: its length; minw: the field's minimum width; numeric, lo, hi, required: as
   above; arg: passed on to EditTextField. Result: the number, or EditTextField's last key. */
int TextInputDialog(char *prompt, char *buf, int maxlen, int minw, int numeric, int lo, int hi, int required,
    int arg)
{
    char probe[0x100];
    int ty;
    int h;
    int x;
    int y;
    int w;
    int i;
    int r;
    int ok;

    InputRemove();
    sub_B4BA8();
    for (i = 0; i < maxlen; i++) probe[i] = 'M';
    probe[maxlen] = 0;
    w = fputchar(probe);
    if (w < minw) w = minw;
    w += 0xC;
    minw = fputchar(prompt) + 0x10;
    if (minw < w) minw = w + 0x10;
    h = byte_D42C3 * 2 + 0x20;
    x = (0x280 - minw) / 2;
    y = (0x1E0 - h) / 2;
    SaveDialogBg(x, y, minw, h);
    SetTextColors(dlgtextfg, dlgtextbg);
    DrawBevelRect(x, y, minw, h, boxfillcolor, boxlitecolor, boxshadecolor);
    sub_8E9C0(dlgtextfg, dlgtextbg);
    ty = y + 7;
    PrintShadowText((minw - fputchar(prompt)) / 2 + x, ty, prompt);
    x += (minw - w) / 2;
    DrawBevelRect(x, y + 0x1F, w, 0x12, dlgtextbg, boxshadecolor, boxlitecolor);
    sub_8E9C0(dlgtextfg, dlgtextbg);
    while (sub_B2CBE(1) || sub_B2CBE(0x1C));
    ClearInputQueue();
    if (numeric) {
        do {
            *buf = 0;
            EditTextField(buf, maxlen, w - 8, x + 6, y + 0x20, DlgReturnZero, 0, arg);
            r = 0;
            for (i = 0; i < maxlen; i++) {
                if (!(byte_C4B6C[(unsigned char)(buf[i] + 1)] & 0x20) && buf[0] != ' ' && buf[0] && buf[0] != '-') break;
                r = unknown_libname_4(buf);
            }
        } while (r < lo || r > hi);
    } else {
        do {
            *buf = 0;
            r = EditTextField(buf, maxlen, w - 8, x + 6, y + 0x20, DlgReturnZero, 0, arg);
        ok = 1;
        if (required && !*buf && r != 0x1B) ok = 0;
        } while (!ok);
    }
    while (sub_B2CBE(1) || sub_B2CBE(0x1C));
    ClearInputQueue();
    RestoreDialogBg();
    InputInstall();
    return r;
}

/* MessageBox (31013, PC only; ends in DlgNullCallback): a message box with n text lines centred above nb buttons
   b. The box fits the widest line and the lines (byte_D42C3 + 2 high each) plus 10h, grown for the buttons
   (GrowToButtons), at x / y or centred on the screen when negative; the screen under it is saved first. Each
   button is placed from the box's left edge (flags bit 0) or right edge and from its top (bit 2) or bottom.
   With wait set, run the buttons (RunMessageBox from the mouse position *mx / *my) and restore the screen; the
   button positions are put back before returning. Result: the chosen button (RunMessageBox), undefined without
   wait. Plain locals in the order lineh, r, ty, w, h, top give the EXE frame under 10.0 GA (n at +0Ch, lines
   at +10h, lineh at +14h). */
int MessageBox(int x, int y, char **lines, int n, DlgBtn *b, int nb, int *mx, int *my, int wait)
{
    int lineh;
    int r;
    int ty;
    int w;
    int h;
    int top;
    int i;
    int d;

    sub_B4BA8();
    RestoreDialogBg();
    h = w = 0;
    lineh = byte_D42C3 + 2;
    for (i = 0; i < n; i++) MeasureTextLine(lines[i], &w, &h, lineh);
    w += 0x10;
    h += 0x10;
    GrowToButtons(b, nb, &w, &h);
    if (x < 0) x = (0x280 - w) / 2;
    if (y < 0) top = (0x1E0 - h) / 2;
    else top = y;
    SaveDialogBg(x, top, w, h);
    DrawBevelRect(x, top, w, h, boxfillcolor, boxlitecolor, boxshadecolor);
    ty = top + 8;
    SetTextColors(dlgtextfg, dlgtextbg);
    for (i = 0; i < n; i++) {
        d = (w - fputchar(lines[i])) / 2;
        PrintShadowText(d + x, ty, lines[i]);
        ty += lineh;
    }
    for (i = 0; i < nb; i++) {
        if (b[i].flags & 1) b[i].x1 += x;
        else b[i].x1 += w + x - b[i].x2;
        if (b[i].flags & 4) b[i].y1 += top;
        else b[i].y1 += top + h - b[i].y2;
    }
    DrawButtons(b, nb);
    ClearInputQueue();
    if (wait) {
        r = RunMessageBox(mx, my, b, nb);
        RestoreDialogBg();
    }
    for (i = 0; i < nb; i++) {
        if (b[i].flags & 1) b[i].x1 -= x;
        else b[i].x1 -= w + x - b[i].x2;
        if (b[i].flags & 4) b[i].y1 -= top;
        else b[i].y1 -= top + h - b[i].y2;
    }
    return r;
}
