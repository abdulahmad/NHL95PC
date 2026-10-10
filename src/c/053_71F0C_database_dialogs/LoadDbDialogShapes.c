/* Database dialogs: shapes and the open-database menu (one source block: MenuOpenDatabase ends in LoadDbDialogShapes' exit). */
/* LoadDbDialogShapes - as LoadFileDlgShapes for the database dialog: bank DBBUT, the four tabs being
   none, current, team and original (Dbno/Dbcu/Dbtm/Dbor) in the fdlg_tab* slots. */
#include "nhl95.h"

void LoadDbDialogShapes(void)
{
    char path[32];

    if (!fdlgshapes) {
        MakePath(path, fileoncd[0x1C7] == 1 ? (char *)cddriveptr : 0, (char *)str_DbBut, 0);
        fdlgshapes = sub_8E83C(path, 0);
        fdlg_none = sub_B30B4(fdlgshapes, (char *)str_None2);
        fdlg_del = sub_B30B4(fdlgshapes, (char *)str_Del2);
        fdlg_open = sub_B30B4(fdlgshapes, (char *)str_Open3);
        fdlg_cancel = sub_B30B4(fdlgshapes, (char *)str_Can2);
        fdlg_noarrow = sub_B30B4(fdlgshapes, (char *)str_Noar2);
        fdlg_up = sub_B30B4(fdlgshapes, (char *)str_Up2);
        fdlg_down = sub_B30B4(fdlgshapes, (char *)str_Down2);
        fdlg_arrow = sub_B30B4(fdlgshapes, (char *)str_Arro2);
        fdlg_tabnone = sub_B30B4(fdlgshapes, (char *)str_Dbno);
        fdlg_tabexh = sub_B30B4(fdlgshapes, (char *)str_Dbcu);
        fdlg_tablp = sub_B30B4(fdlgshapes, (char *)str_Dbtm);
        fdlg_tabpo = sub_B30B4(fdlgshapes, (char *)str_Dbor);
    }
}

typedef struct { char res[0x15]; unsigned char attrib; char pad[8]; char name[14]; } DbFindT;

typedef struct { char c[8]; } Name8;
typedef struct { char c[9]; } Name9;

/* DRAFT (ScanDbFiles): Watcom sinks the ++dblistcur[0] below the savefname stores, and the name byte goes through dl / dh instead of dh / bh; rest matches. */
/* ScanDbFiles (7248C) - build the database dialog lists: clear the temp / current / original lists (count, selection,
   top, last), then add CURRENT when DB exists, ORIGINAL when ORG exists, and every directory matching the DBX pattern
   (names up to the dot, at most 16, in savefname) sorted by name; the temp list's last visible line is
   min(count - 1, 5). */
void ScanDbFiles(void)
{
    DbFindT ft;
    int n;
    int j;
    unsigned char c;

    n = 0;
    dblistorig[0] = dblistcur[0] = dblisttemp[0] = 0;
    dblistorig[1] = dblistcur[1] = dblisttemp[1] = 0;
    dblistorig[2] = dblistcur[2] = dblisttemp[2] = 0;
    dblistorig[3] = dblistcur[3] = dblisttemp[3] = 0;
    if (!unknown_libname_1((char *)str_Db3, 0, &ft)) {
        dblistcur[4] = (int)savefname;
        ++dblistcur[0];
        *(Name8 *)savefname = *(Name8 *)str_CURRENT;
        savefname[8] = 0;
        n = 9;
    }
    if (!unknown_libname_1((char *)str_Org, 0, &ft)) {
        dblistorig[4] = (int)(savefname + n);
        *(Name9 *)(savefname + n) = *(Name9 *)str_ORIGINAL;
        ++dblistorig[0];
        n += 8;
        savefname[n] = 0;
        n++;
    }
    if (unknown_libname_1((char *)str_Dbx, 0x10, &ft)) return;
    do {
        dblisttempnames[dblisttemp[0]] = (int)(savefname + n);
        dblisttemp[0]++;
        for (j = 0; j < 8; j++) {
            c = ft.name[j];
            if (!c || c == '.') break;
            savefname[n] = c;
            n++;
        }
        savefname[n] = 0;
        n++;
    } while (dblisttemp[0] < 0x10 && !unknown_libname_2(&ft));
    qsort(dblisttempnames, dblisttemp[0], 4, (int (*)(const void *, const void *))CmpFileNames);
    dblisttemp[3] = dblisttemp[0] < 6 ? dblisttemp[0] - 1 : 5;
}

#define FDLGMASKD (*(int *)fdlgmask)
#define FDLGMASKW (*(unsigned short *)fdlgmask)
typedef struct { int x1, y1, x2, y2; } DbRect;
#define DBRECT ((DbRect *)dbdlgrects)

/* DRAFT (DrawDbDialog): only the scroll-bar end differs: the EXE adds 12h to rect 8's y1 before the quotient, this adds it to the quotient. */
/* DrawDbDialog (727EE) - PC only: draw the database dialog: art PDBX of bank DBDIALOG at 10,19 (from the CD when
   the files are there), then work out the button mask fdlgmask and the shown tab fdlgtab from the lists that have
   entries (temporary: tab 2, original: tab 1, current: tab 0, the last one wins). With a tab: its title (rect 9),
   the list area cleared to F8h (rect 10) and the visible names from list[2] to list[3] in rects 10 onwards; more than
   6 entries enable the scroll buttons and draw the scroll bar (rect 8, thumb 354h / count high), up to 6 enable one
   row button each (fdlgmask byte 1, bits 2 up). Lists are ints: count, selection, top, last visible, names. */
void DrawDbDialog(void)
{
    char path[32];
    int xright;
    int bank;
    int *list;
    int i;
    int row;
    int x;
    int y;
    int ybar;

    sub_B4BA8();
    MakePath(path, fileoncd[0x1C8] == 1 ? (char *)cddriveptr : 0, (char *)str_Dbdialog, 0);
    bank = sub_8E83C(path, 0);
    sub_91284(sub_B30B4(bank, (char *)str_Pdbx), 10, 0x13);
    jctime(bank);
    FDLGMASKD = 0x10;
    fdlgtab = -1;
    if (dblisttemp[0] != 0) {
        FDLGMASKD = 0x90;
        fdlgtab = 2;
    }
    if (dblistorig[0] != 0) {
        fdlgmask[0] |= 0x40;
        fdlgtab = 1;
    }
    if (dblistcur[0] != 0) {
        fdlgmask[0] |= 0x20;
        fdlgtab = 0;
    }
    if (fdlgtab < 0) return;
    FDLGMASKW |= 0x204;
    sub_8E9C0(0xFA, 0xFF);
    list = (int *)dbtablists[fdlgtab];
    sub_91964((char *)list[list[1] + 4], DBRECT[9].x1 + 0xD, DBRECT[9].y1 + 0x13);
    sub_90D20(DBRECT[10].x1 + 0xA, DBRECT[10].y1 + 0x13, DBRECT[10].x2 - DBRECT[10].x1 + 1,
              DBRECT[10].y2 - DBRECT[10].y1 + 1, 0xF8);
    for (i = list[2], row = 10; i <= list[3]; i++, row++)
        sub_91964((char *)list[i + 4], DBRECT[row].x1 + 0xA, DBRECT[row].y1 + 0x10);
    if (list[0] > 6) {
        FDLGMASKW |= 0xFF03;
        x = DBRECT[8].x1 + 0xA;
        y = DBRECT[8].y1 + 0x13;
        xright = DBRECT[8].x2 + 0xA;
        ybar = DBRECT[8].y1 + (0x354 / list[0] + 0x12);
        sub_B4FAC(x, y, DBRECT[8].x2 + 9, y, 0x7D);
        sub_B4FAC(x, y, x, ybar - 1, 0x7D);
        sub_B4FAC(xright, y - 1, xright, ybar, 0x7B);
        sub_B4FAC(x - 1, ybar, xright, ybar, 0x7B);
        return;
    }
    switch (list[0]) {
    case 6: fdlgmask[1] |= 0x80;
    case 5: fdlgmask[1] |= 0x40;
    case 4: fdlgmask[1] |= 0x20;
    case 3: fdlgmask[1] |= 0x10;
    case 2: fdlgmask[1] |= 8;
    case 1: fdlgmask[1] |= 4;
    }
}

/* DrawDbList (72AC6) - PC only: redraw the database dialog's list: clear the six rows (rects 10-15, F9h), print the
   names (the first count when up to 6, else the six from the top entry list[2]), the selected name as the title
   (rect 9, cleared to F8h) and again highlighted in its row when it is visible (F8h), clear the scroll bar
   (rect 8). More than 6 entries: enable the scroll buttons and draw the thumb from list[2] to list[3] + 1 of 8Eh
   pixels; otherwise mask them off and enable one row button per entry (fdlgmask byte 1, bits 2 up). Then the tab
   art of tab 0-2. A NULL list only clears the rows and returns 0. */
int DrawDbList(int *list)
{
    int xright;
    int i;                      /* row; later the thumb's top y */
    int x;
    int y2;

    sub_8E9C0(0xFA, 0xFF);
    for (i = 0; i < 6; i++)
        sub_90D20(DBRECT[10 + i].x1 + 0xA, DBRECT[10 + i].y1 + 0x13, DBRECT[10 + i].x2 - DBRECT[10 + i].x1 + 1,
                  DBRECT[10 + i].y2 - DBRECT[10 + i].y1 + 1, 0xF9);
    if (list == NULL) return 0;
    if (list[0] <= 6) {
        for (i = 0; i < list[0]; i++)
            PrintTextCopy((char *)list[i + 4], DBRECT[10 + i].x1 + 0xA, DBRECT[10 + i].y1 + 0x10);
    } else {
        for (i = 0; i < 6; i++)
            PrintTextCopy((char *)list[list[2] + i + 4], DBRECT[10 + i].x1 + 0xA, DBRECT[10 + i].y1 + 0x10);
    }
    if (list[0] > 0) {
        sub_90D20(DBRECT[9].x1 + 0xD, DBRECT[9].y1 + 0x16, DBRECT[9].x2 - DBRECT[9].x1 - 5,
                  DBRECT[9].y2 - DBRECT[9].y1 - 5, 0xF8);
        PrintTextCopy((char *)list[list[1] + 4], DBRECT[9].x1 + 0xD, DBRECT[9].y1 + 0x13);
    }
    if (list[1] >= list[2] && list[1] <= list[3]) {
        i = list[1] - list[2];
        sub_90D20(DBRECT[10 + i].x1 + 0xA, DBRECT[10 + i].y1 + 0x13, DBRECT[10 + i].x2 - DBRECT[10 + i].x1,
                  DBRECT[10 + i].y2 - DBRECT[10 + i].y1, 0xF8);
        PrintTextCopy((char *)list[list[2] + i + 4], DBRECT[10 + i].x1 + 0xA, DBRECT[10 + i].y1 + 0x10);
    }
    sub_90D20(DBRECT[8].x1 + 0xA, DBRECT[8].y1 + 0x13, DBRECT[8].x2 - DBRECT[8].x1 + 1,
              DBRECT[8].y2 - DBRECT[8].y1 + 1, 0xF9);
    if (list[0] <= 6) {
        FDLGMASKW &= 0x6FC;
        switch (list[0]) {
        case 6: fdlgmask[1] |= 0x80;
        case 5: fdlgmask[1] |= 0x40;
        case 4: fdlgmask[1] |= 0x20;
        case 3: fdlgmask[1] |= 0x10;
        case 2: fdlgmask[1] |= 8;
        case 1: fdlgmask[1] |= 4;
        }
    } else {
        FDLGMASKW |= 0xF903;
        x = DBRECT[8].x1 + 0xA;
        i = DBRECT[8].y1 + 0x13 + list[2] * 0x8E / list[0];
        xright = DBRECT[8].x2 + 0xA;
        y2 = DBRECT[8].y1 + 0x13 + (list[3] + 1) * 0x8E / list[0];
        sub_B4FAC(x, i, DBRECT[8].x2 + 9, i, 0x7D);
        sub_B4FAC(x, i, x, y2 - 1, 0x7D);
        sub_B4FAC(xright, i + 1, xright, y2, 0x7B);
        sub_B4FAC(x + 1, y2, xright, y2, 0x7B);
    }
    switch ((unsigned)fdlgtab) {
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

/* DeleteSelectedDb (735C3) - delete the selected database of list (ints: count, selection, top, last visible,
   then the names): ask first (deldbmsg with the name, at 140h / F0h); when its DBX directory exists remove it and
   drop the name from the list, fixing the scroll range and selection; when the list is now empty switch the dialog
   tab to the current / original databases or none, and redraw the buttons. Returns 0. */
int DeleteSelectedDb(int *list)
{
    DbFindT ft;
    char path[16];
    int y;
    int x;
    int i;

    x = 0x140;
    y = 0xF0;
    *(int *)(deldbmsg + 4) = list[list[1] + 4];
    if (MessageBox(-1, -1, (char *)deldbmsg, 2, (int)btn_POHumanOut, 2, (int)&x, (int)&y, -1) != 1) return 0;
    i = list[1];
    strcpy(path, (char *)list[i + 4]);
    strcat(path, (char *)str_DBX2);
    if (unknown_libname_1(path, 0x10, &ft)) return 0;
    if (ft.attrib & 0x10) DeleteDir(ft.name);
    if (--list[0]) {
        for (i = list[1]; i < list[0]; i++) list[i + 4] = list[i + 5];
        if (list[0] < 6) {
            list[3] = list[0] - 1;
            list[2] = 0;
        } else if (list[0] == list[3]) {
            list[2]--;
            list[3]--;
        }
        if (list[1] == list[0]) list[1]--;
    } else {
        fdlgmask[0] &= 0x77;
        if (dblistcur[0]) fdlgtab = 0;
        else if (dblistorig[0]) fdlgtab = 1;
        else {
            fdlgtab = -1;
            *(int *)fdlgmask = 0x10;
        }
        DrawDbDialogButtons();
    }
    return 0;
}

typedef struct Hdr17 { char c[17]; } Hdr17;

/* MenuOpenDatabase (73703) - menu "open database": scan the database files, save the screen under the 243 x 198
   dialog at 10 / 13h into a BUF bitmap (pointer sprite header), load the dialog shapes, draw the dialog and its
   buttons and run it; unless a database was opened restore the screen; free the shapes and the bitmap. */
void MenuOpenDatabase(void)
{
    int bm;

    ScanDbFiles();
    bm = sub_8CCA8((char *)str_Buf2, 0xBC03, 0x20);
    *(Hdr17 *)bm = *(Hdr17 *)pointerspr;
    ((short *)bm)[2] = 0xF3;
    ((short *)bm)[3] = 0xC6;
    sub_91400(bm, 0xA, 0x13);
    LoadDbDialogShapes();
    DrawDbDialog();
    DrawDbDialogButtons();
    if (!DbDialogLoop()) sub_910E0(bm, 0xA, 0x13);
    jctime(fdlgshapes);
    fdlgshapes = 0;
    jctime(bm);
}
