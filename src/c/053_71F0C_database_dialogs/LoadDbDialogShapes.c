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
