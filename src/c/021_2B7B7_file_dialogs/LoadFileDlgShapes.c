/* LoadFileDlgShapes - unless loaded, load the file dialog button bank OPENBUT (from the CD when listed there) into fdlgshapes and look up its
   shapes: none, delete, open, cancel, no arrow, up, down, arrow and the four game-type tabs (none, exhibition, league, playoffs). */
#define DrawFileDlgTabs DrawFileDlgTabs_decl
#define RunFileDlg RunFileDlg_decl
#define DeleteSavedGame DeleteSavedGame_decl
#define savefileexts savefileexts_decl
#include "nhl95.h"
#undef savefileexts
#undef DeleteSavedGame
#undef RunFileDlg
#undef DrawFileDlgTabs

extern int savefileexts[3];
int unlink(char *path);

typedef struct Ext12 { char c[12]; } Ext12;

void LoadFileDlgShapes(void)
{
    char path[32];

    if (!fdlgshapes) {
        MakePath(path, fileoncd[0x1C6] == 1 ? (char *)cddriveptr : 0, (char *)str_OpenBut, 0);
        fdlgshapes = sub_8E83C(path, 0);
        fdlg_none = sub_B30B4(fdlgshapes, (char *)str_None);
        fdlg_del = sub_B30B4(fdlgshapes, (char *)str_Del);
        fdlg_open = sub_B30B4(fdlgshapes, (char *)str_Open);
        fdlg_cancel = sub_B30B4(fdlgshapes, (char *)str_Can);
        fdlg_noarrow = sub_B30B4(fdlgshapes, (char *)str_Noar);
        fdlg_up = sub_B30B4(fdlgshapes, (char *)str_Up);
        fdlg_down = sub_B30B4(fdlgshapes, (char *)str_Down);
        fdlg_arrow = sub_B30B4(fdlgshapes, (char *)str_Arro);
        fdlg_tabnone = sub_B30B4(fdlgshapes, (char *)str_Gtno);
        fdlg_tabexh = sub_B30B4(fdlgshapes, (char *)str_Gtex);
        fdlg_tablp = sub_B30B4(fdlgshapes, (char *)str_Gtlp);
        fdlg_tabpo = sub_B30B4(fdlgshapes, (char *)str_Gtpo);
    }
}

/* DrawFileDlgTabs: file-dialog captions and the tab sprite. A negative tab is the open/delete/done
 page (no arrow, the none tab). Otherwise the league, playoff and exhibition captions are drawn when
 their mask bits are clear, the arrow sprite follows the selected list's count, and tabs 0, 1 and 2
 are the exhibition, playoff and league sprites. */
void DrawFileDlgTabs(void)
{
    sub_8E9C0(0xF8, 0xFF);
    if (fdlgtab < 0) {
        sub_91964((char *)str_Open2, 0x2A, 0xC0);
        sub_91964((char *)str_Delete, 0x6B, 0xC0);
        sub_8E9C0(0xFA, 0xFF);
        sub_91964((char *)str_Done, 0xB8, 0xC0);
        sub_8E9C0(0xF8, 0xFF);
        sub_91964((char *)str_Exhibition, 0xA7, 0x4C);
        sub_91964((char *)str_Playoffs, 0xAB, 0x64);
        sub_91964((char *)str_League, 0xB0, 0x7C);
        sub_91370(fdlg_noarrow, 0x18, 0x46);
        sub_91370(fdlg_tabnone, 0xA3, 0x4B);
    } else {
        if ((fdlgmask[0] & 0x80) == 0)
            sub_91964((char *)str_League, 0xB0, 0x7C);
        if ((fdlgmask[0] & 0x40) == 0)
            sub_91964((char *)str_Playoffs, 0xAB, 0x64);
        if ((fdlgmask[0] & 0x20) == 0)
            sub_92CD0((char *)str_Exhibition, 0xA7, 0x4C);
        if (*(int *)off_C6F7C[fdlgtab] <= 6)
            sub_91370(fdlg_noarrow, 0x18, 0x46);
        else
            sub_91370(fdlg_arrow, 0x18, 0x46);
        switch (fdlgtab) {
        case 0:
            sub_91370(fdlg_tabexh, 0xA3, 0x4B);
            break;
        case 1:
            sub_91370(fdlg_tabpo, 0xA3, 0x4B);
            break;
        case 2:
            sub_91370(fdlg_tablp, 0xA3, 0x4B);
            break;
        }
    }
}

typedef struct FileList {
    int count;          /* +0: files in the list */
    int sel;            /* +4: the selected file */
    int top;            /* +8: the first file shown */
    int bottom;         /* +0Ch: the last file shown */
    char *names[1];     /* +10h: the file names */
} FileList;

typedef struct FRect {
    int x1, y1, x2, y2;
} FRect;

int DeleteSavedGame(FileList *list);

/* DrawFileDlg (2C18F, PC only; ends in LoadFileDlgShapes_x): draw the saved-games dialog. Load the DIALOGBX bank
   (from the CD when listed there) and draw its DBOX art at 0Ah, 13h. The tab is the last of exhibition (2),
   playoffs (1) and league (0) that has saved files (exhfiles, pofiles, lgfiles), each tab's bit 7 / 6 / 5 in
   fdlgmask (bit 4 always); with none, stop there. Else enable the buttons (fdlgmask 20Ch), print the selected
   file's name in the title rect (8) and clear the list rect (0Ah) in colour F8h, print the shown files (top to
   bottom) into rects 0Ah on, and enable one list row per file (fdlgmask bits 0Ah-0Fh); with more than six files
   enable them all and the arrows (FF03h) and draw the scroll bar: rect 8's frame lines in FAh / F8h with the
   thumb 1E0h / count high. No arguments, no result. */
void DrawFileDlg(void)
{
    char path[0x20];
    int bank;
    FileList *l;
    int i;
    int j;
    int x;
    int y;
    int x2;
    int y2;

    sub_B4BA8();
    MakePath(path, fileoncd[0x63] == 1 ? (char *)cddriveptr : 0, (char *)str_Dialogbx, 0);
    bank = sub_8E83C(path, 0);
    sub_91284(sub_B30B4(bank, (char *)str_Dbox), 0xA, 0x13);
    FreeMemBlock(bank);
    *(int *)fdlgmask = 0x10;
    fdlgtab = -1;
    if (exhfiles[0]) {
        *(int *)fdlgmask = 0x90;
        fdlgtab = 2;
    }
    if (pofiles[0]) {
        fdlgmask[0] |= 0x40;
        fdlgtab = 1;
    }
    if (lgfiles[0]) {
        fdlgmask[0] |= 0x20;
        fdlgtab = 0;
    }
    if (fdlgtab < 0) return;
    *(short *)fdlgmask |= 0x20C;
    sub_8E9C0(0xFA, 0xFF);
    l = (FileList *)off_C6F7C[fdlgtab];
    PrintTextCopy(l->names[l->sel], ((FRect *)fdlgrects)[9].x1 + 0xD, ((FRect *)fdlgrects)[9].y1 + 0x13);
    sub_90D20(((FRect *)fdlgrects)[0xA].x1 + 0xA, ((FRect *)fdlgrects)[0xA].y1 + 0x13,
        ((FRect *)fdlgrects)[0xA].x2 - ((FRect *)fdlgrects)[0xA].x1 + 1,
        ((FRect *)fdlgrects)[0xA].y2 - ((FRect *)fdlgrects)[0xA].y1 + 1, 0xF8);
    for (i = l->top, j = 0xA; i <= l->bottom; i++, j++)
        PrintTextCopy(l->names[i], ((FRect *)fdlgrects)[j].x1 + 0xA, ((FRect *)fdlgrects)[j].y1 + 0x10);
    if (l->count > 6) {
        *(short *)fdlgmask |= 0xFF03;
        x = ((FRect *)fdlgrects)[8].x1 + 0xA;
        y = ((FRect *)fdlgrects)[8].y1 + 0x13;
        x2 = ((FRect *)fdlgrects)[8].x2 + 0xA;
        i = 0x1E0 / l->count;
        y2 = ((FRect *)fdlgrects)[8].y1 + 0x11 + i;
        sub_B4FAC(x, y, ((FRect *)fdlgrects)[8].x2 + 9, y, 0xFA);
        sub_B4FAC(x, y, x, y2 - 1, 0xFA);
        sub_B4FAC(x2, y - 1, x2, y2, 0xF8);
        sub_B4FAC(x - 1, y2, x2, y2, 0xF8);
        return;
    }
    switch (l->count) {
    case 6: fdlgmask[1] |= 0x80;
    case 5: fdlgmask[1] |= 0x40;
    case 4: fdlgmask[1] |= 0x20;
    case 3: fdlgmask[1] |= 0x10;
    case 2: fdlgmask[1] |= 8;
    case 1: fdlgmask[1] |= 4;
    }
}

/* DrawFileDlgList (2C46B, PC only; ends in LoadFileDlgShapes_x): draw the file list l of the saved-games dialog.
   Clear the six list rows (rects 0Ah-0Fh) in colour F9h. With no list clear the title (rect 9) and stop. Else
   print the shown files (all of them up to six, else six from top), and with any files clear the title in F8h
   and print the selected file's name there; the selected row, when shown, is cleared in F8h and reprinted. Clear
   the scroll bar (rect 8) in F9h. Up to six files: enable one row per file in fdlgmask (bits 0Ah-0Fh, after
   clearing them and the arrows: & 6FCh); more: enable all and the arrows (F903h) and draw the scroll bar thumb
   (top * 50h / count to (bottom + 1) * 50h / count) in FAh / F8h. Then the arrow sprite by the current tab's
   count (fdlg_noarrow / fdlg_arrow) and the tab sprite (exhibition, playoffs, league for tabs 0-2). l: the
   list, or 0. Result: 0 with no list, else undefined (nothing is stored). */
int DrawFileDlgList(FileList *l)
{
    int i;
    int r;
    int x;
    int y;
    int x2;
    int y2;

    sub_8E9C0(0xFA, 0xFF);
    for (i = 0; i < 6; i++)
        sub_90D20(((FRect *)fdlgrects)[0xA + i].x1 + 0xA, ((FRect *)fdlgrects)[0xA + i].y1 + 0x13,
            ((FRect *)fdlgrects)[0xA + i].x2 - ((FRect *)fdlgrects)[0xA + i].x1 + 1,
            ((FRect *)fdlgrects)[0xA + i].y2 - ((FRect *)fdlgrects)[0xA + i].y1 + 1, 0xF9);
    if (!l) {
        sub_90D20(((FRect *)fdlgrects)[9].x1 + 0xD, ((FRect *)fdlgrects)[9].y1 + 0x16,
            ((FRect *)fdlgrects)[9].x2 - ((FRect *)fdlgrects)[9].x1 - 5,
            ((FRect *)fdlgrects)[9].y2 - ((FRect *)fdlgrects)[9].y1 - 5, 0xF8);
        r = 0;
        goto done;
    }
    if (l->count <= 6) {
        for (i = 0; i < l->count; i++)
            PrintTextCopy(l->names[i], ((FRect *)fdlgrects)[0xA + i].x1 + 0xA, ((FRect *)fdlgrects)[0xA + i].y1 + 0x10);
    } else {
        for (i = 0; i < 6; i++)
            PrintTextCopy(l->names[l->top + i], ((FRect *)fdlgrects)[0xA + i].x1 + 0xA,
                ((FRect *)fdlgrects)[0xA + i].y1 + 0x10);
    }
    if (l->count > 0) {
        sub_90D20(((FRect *)fdlgrects)[9].x1 + 0xD, ((FRect *)fdlgrects)[9].y1 + 0x16,
            ((FRect *)fdlgrects)[9].x2 - ((FRect *)fdlgrects)[9].x1 - 5,
            ((FRect *)fdlgrects)[9].y2 - ((FRect *)fdlgrects)[9].y1 - 5, 0xF8);
        PrintTextCopy(l->names[l->sel], ((FRect *)fdlgrects)[9].x1 + 0xD, ((FRect *)fdlgrects)[9].y1 + 0x13);
    }
    if (l->sel >= l->top && l->sel <= l->bottom) {
        i = l->sel - l->top;
        sub_90D20(((FRect *)fdlgrects)[0xA + i].x1 + 0xA, ((FRect *)fdlgrects)[0xA + i].y1 + 0x13,
            ((FRect *)fdlgrects)[0xA + i].x2 - ((FRect *)fdlgrects)[0xA + i].x1,
            ((FRect *)fdlgrects)[0xA + i].y2 - ((FRect *)fdlgrects)[0xA + i].y1, 0xF8);
        PrintTextCopy(l->names[l->top + i], ((FRect *)fdlgrects)[0xA + i].x1 + 0xA,
            ((FRect *)fdlgrects)[0xA + i].y1 + 0x10);
    }
    sub_90D20(((FRect *)fdlgrects)[8].x1 + 0xA, ((FRect *)fdlgrects)[8].y1 + 0x13,
        ((FRect *)fdlgrects)[8].x2 - ((FRect *)fdlgrects)[8].x1 + 1,
        ((FRect *)fdlgrects)[8].y2 - ((FRect *)fdlgrects)[8].y1 + 1, 0xF9);
    if (l->count <= 6) {
        *(short *)fdlgmask &= 0x6FC;
        switch (l->count) {
        case 6: fdlgmask[1] |= 0x80;
        case 5: fdlgmask[1] |= 0x40;
        case 4: fdlgmask[1] |= 0x20;
        case 3: fdlgmask[1] |= 0x10;
        case 2: fdlgmask[1] |= 8;
        case 1: fdlgmask[1] |= 4;
        }
    } else {
        *(short *)fdlgmask |= 0xF903;
        x = ((FRect *)fdlgrects)[8].x1 + 0xA;
        y = ((FRect *)fdlgrects)[8].y1 + 0x13 + l->top * 0x50 / l->count;
        x2 = ((FRect *)fdlgrects)[8].x2 + 0xA;
        y2 = ((FRect *)fdlgrects)[8].y1 + 0x12 + (l->bottom + 1) * 0x50 / l->count;
        sub_B4FAC(x, y, ((FRect *)fdlgrects)[8].x2 + 9, y, 0xFA);
        sub_B4FAC(x, y, x, y2 - 1, 0xFA);
        sub_B4FAC(x2, y + 1, x2, y2, 0xF8);
        sub_B4FAC(x + 1, y2, x2, y2, 0xF8);
    }
    if (*(int *)off_C6F7C[fdlgtab] <= 6)
        sub_91370(fdlg_noarrow, 0x18, 0x46);
    else
        sub_91370(fdlg_arrow, 0x18, 0x46);
    switch (fdlgtab) {
    case 0:
        sub_91370(fdlg_tabexh, 0xA3, 0x4B);
        break;
    case 1:
        sub_91370(fdlg_tabpo, 0xA3, 0x4B);
        break;
    case 2:
        sub_91370(fdlg_tablp, 0xA3, 0x4B);
        break;
    }
done:
    return r;
}

typedef struct { char c[17]; } Hdr17;

/* DRAFT (RunFileDlg): same size; the scroll step and later registers differ (see docs/UNSURE.md). */
/* RunFileDlg (2C801, PC only; ends in DrawFileDlg_x): run the saved-games dialog with the mouse pointer (a
   POINTER block holds the screen under it) on the list of the shown tab (off_C6F7C[fdlgtab]). Button 1 held on the
   scroll bar (box 8, when fdlgmask enables it) drags the shown rows with the pointer (the first event only starts
   the drag); a move too small to scroll a row is kept (from dragy) until it adds up. A click (event bit 2) on an
   enabled box: the arrows scroll one row, the bar brings the clicked position into view, the three tabs switch the
   list, Delete deletes the selected saved game (DeleteSavedGame) and puts the mouse back, a row selects it
   (FileDlgHitTest); Open frees the block and returns SelectSavedFile's result; Cancel or event bit 4 return 0. */
int RunFileDlg(void)
{
    int dragy;
    int bm;
    int drag;
    int ox;
    int oy;
    int x;
    int y;
    int btn;
    int hit;
    int n;
    int slow;
    int pos;
    int last;
    int d;
    FileList *l;
    unsigned char *ev;

    drag = 0;
    slow = 0;
    sub_B2DCA(&btn, &ox, &oy);
    x = ox;
    y = oy;
    sub_B4BA8();
    n = (((short *)pointerspr)[2] + 1) * (((short *)pointerspr)[3] + 1) + 0x11;
    bm = sub_8CCA8((char *)str_Pointer5, n, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = ((short *)pointerspr)[2] + 1;
    ((short *)bm)[3] = ((short *)pointerspr)[3] + 1;
    sub_91400(bm, x - 4, y);
    sub_91370(pointerspr, x - 4, y);
    l = (FileList *)off_C6F7C[fdlgtab];
    ClearInputQueue();
    for (;;) {
        btn = 0;
        for (;;) {
            ev = GetInputEvent();
            if (ev == 0) break;
            btn = ((int (*)(unsigned char *, int *, int *))ptrupdatefn)(ev, &x, &y);
            if (btn) break;
        }
        if (btn == 0) {
            if (x != ox || y != oy) {
                sub_B4BA8();
                sub_903F0(bm, ox - 4, oy);
                sub_91400(bm, x - 4, y);
                sub_91370(pointerspr, x - 4, y);
                ox = x;
                oy = y;
            }
            continue;
        }
        sub_910E0(bm, ox - 4, oy);
        if ((btn & 1) && (fdlgmask[1] & 1)) {
            if (ox != x || oy != y) {
                if (FileDlgHitTest(x, y, &hit) && hit == 8) {
                    if (drag) {
                        pos = l->count * (oy - 0x13 - ((FRect *)fdlgrects)[8].y1) / 0x50;
                        last = l->bottom;
                        if (oy != y && pos >= l->top && pos <= last) {
                            if ((slow ? dragy : oy) < y) {
                                d = (y - (slow ? dragy : oy)) * l->count / 0x50;
                                if (d == 0) {
                                    if (!slow) dragy = oy;
                                    slow = 1;
                                } else {
                                    slow = 0;
                                }
                                if (l->bottom + d < l->count) {
                                    l->top += d;
                                    l->bottom += d;
                                } else {
                                    l->bottom = l->count - 1;
                                    l->top = l->count - 6;
                                }
                            } else if ((slow ? dragy : oy) > y) {
                                d = ((slow ? dragy : oy) - y) * l->count / 0x50;
                                if (d == 0) {
                                    if (!slow) dragy = oy;
                                    slow = 1;
                                } else {
                                    slow = 0;
                                }
                                if (l->top - d >= 0) {
                                    l->top -= d;
                                    l->bottom -= d;
                                } else {
                                    l->top = 0;
                                    l->bottom = 5;
                                }
                            }
                            if (last != l->bottom) DrawFileDlgList(l);
                        }
                    } else {
                        drag = 1;
                    }
                } else {
                    drag = 0;
                }
            }
        } else if (btn & 2) {
            drag = slow = 0;
            if (FileDlgHitTest(x, y, &hit)) {
                hit = 1 << hit;
                if (hit & *(int *)fdlgmask) {
                    switch (hit) {
                    case 0x10:
                        sub_91370(fdlg_cancel, 0x20, 0xBF);
                        FreeMemBlock(bm);
                        return 0;
                    case 1:
                        sub_91370(fdlg_up, 0x18, 0x46);
                        if (l->top != 0) {
                            l->top--;
                            l->bottom--;
                            DrawFileDlgList(l);
                        }
                        break;
                    case 2:
                        sub_91370(fdlg_down, 0x18, 0x46);
                        if (l->bottom + 1 < l->count) {
                            l->top++;
                            l->bottom++;
                            DrawFileDlgList(l);
                        }
                        break;
                    case 0x100:
                        pos = (y - 0x13 - ((FRect *)fdlgrects)[8].y1) * l->count / 0x50;
                        if (pos < l->top) {
                            if (pos < 3) {
                                l->top = 0;
                                l->bottom = 5;
                            } else {
                                l->top = pos - 3;
                                l->bottom = pos + 2;
                            }
                        } else {
                            if (pos <= l->bottom) break;
                            if (pos + 3 > l->count) {
                                l->top = l->count - 6;
                                l->bottom = l->count - 1;
                            } else {
                                l->top = pos - 3;
                                l->bottom = pos + 2;
                            }
                        }
                        DrawFileDlgList(l);
                        break;
                    case 0x20:
                        fdlgtab = 0;
                        l = (FileList *)off_C6F7C[0];
                        DrawFileDlgList(l);
                        break;
                    case 0x40:
                        fdlgtab = 1;
                        l = (FileList *)off_C6F7C[1];
                        DrawFileDlgList(l);
                        break;
                    case 0x80:
                        fdlgtab = 2;
                        l = (FileList *)off_C6F7C[2];
                        DrawFileDlgList(l);
                        break;
                    case 4:
                        sub_91370(fdlg_open, 0x20, 0xBF);
                        FreeMemBlock(bm);
                        return SelectSavedFile();
                    case 8:
                        sub_91370(fdlg_del, 0x20, 0xBF);
                        DeleteSavedGame((FileList *)off_C6F7C[fdlgtab]);
                        MouseSetPos(x, y);
                        l = fdlgtab < 0 ? 0 : (FileList *)off_C6F7C[fdlgtab];
                        DrawFileDlgList(l);
                        sub_91370(fdlg_none, 0x20, 0xBF);
                        break;
                    default:
                        FileDlgHitTest(x, y, &hit);
                        if (hit > 9) l->sel = l->top + hit - 10;
                        DrawFileDlgList(l);
                        break;
                    }
                }
            }
        } else if (btn & 4) {
            FreeMemBlock(bm);
            return 0;
        }
        sub_91400(bm, x - 4, y);
        sub_91370(pointerspr, x - 4, y);
        ox = x;
        oy = y;
    }
}

/* DeleteSavedGame (2CE29, PC only; ends in LoadFileDlgShapes_x): confirm (delmsgbox with the tab's "... called"
   text and the selected name), then delete the selected save of list (its name plus the tab's extension from
   savefileexts). A directory (attribute bit 4) goes with DeleteDir, clearing the league or playoff menu hooks when
   its name is the current one (lgstate / postate + 4); a file with unlink (FatalError when that fails). The name
   list is packed (the shown rows kept in range), and an emptied list clears its tab's bit in fdlgmask and picks
   another tab (league, playoffs, exhibition; none: -1). Returns 0 when the user cancels or the name is already
   gone. */
int DeleteSavedGame(FileList *list)
{
    struct {
        char find[0x2C];
        char path[0x10];
        int ext[3];
        int y;
        int x;
        int result;
    } s;
    int eq;

    *(Ext12 *)s.ext = *(Ext12 *)savefileexts;
    s.x = 0x140;
    s.y = 0xF0;
    if (fdlgtab == 0)
        *(char **)(delmsgbox + 4) = (char *)str_ExhibitionGameCalled;
    else if (fdlgtab == 1)
        *(char **)(delmsgbox + 4) = (char *)str_PlayOffSeriesCalled;
    else
        *(char **)(delmsgbox + 4) = (char *)str_LeagueCalled;
    *(char **)(delmsgbox + 8) = list->names[list->sel];
    SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
    if (MessageBox(-1, -1, (char *)delmsgbox, 3, (int)btn_POHumanOut, 2, (int)&s.x, (int)&s.y, -1) != 1) {
        s.result = 0;
        goto done;
    }
    {
        char *n;

        n = list->names[list->sel];
        strcpy(s.path, n);
        n = (char *)s.ext[fdlgtab];
        strcat(s.path, n);
    }
    if (unknown_libname_1(s.path, 0x10, s.find)) {
        s.result = 0;
        goto done;
    }
    if (s.find[0x15] & 0x10) {
        eq = stricmp(s.path, (char *)lgstate + 4);
        if (eq == 0) {
            *((char *)lgstate + 4) = 0;
            menuact_export = eq;
            menuact_nextlg = eq;
            menusub_lgmgr = eq;
        } else {
            eq = stricmp(s.path, (char *)postate + 4);
            if (eq == 0) {
                *((char *)postate + 4) = 0;
                menuact_nextpo = eq;
                menuact_posettings = eq;
                menuact_pohilights = eq;
            }
        }
        DeleteDir(s.find + 0x1E);
    } else {
        if (unlink(s.find + 0x1E))
            FatalError((char *)str_fec6);
    }
    if (--list->count != 0) {
        int i;

        for (i = list->sel; i < list->count; i++)
            list->names[i] = list->names[i + 1];
        if (list->count < 6) {
            list->bottom = list->count - 1;
            list->top = 0;
        } else if (list->count == list->bottom) {
            list->top--;
            list->bottom--;
        }
        if (list->sel == list->count)
            list->sel--;
    } else {
        switch (fdlgtab) {
        case 2:
            *(unsigned int *)fdlgmask &= 0xFF7F;
            break;
        case 1:
            *(unsigned int *)fdlgmask &= 0xFFBF;
            break;
        case 0:
            *(unsigned int *)fdlgmask &= 0xFFDF;
            break;
        }
        if (lgfiles[0] != 0)
            fdlgtab = 0;
        else if (pofiles[0] != 0)
            fdlgtab = 1;
        else if (exhfiles[0] != 0)
            fdlgtab = 2;
        else {
            fdlgtab = -1;
            *(unsigned int *)fdlgmask = 0x10;
        }
        DrawFileDlgTabs();
    }
done:
    return s.result;
}
