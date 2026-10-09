/* LoadFileDlgShapes - unless loaded, load the file dialog button bank OPENBUT (from the CD when listed there) into fdlgshapes and look up its
   shapes: none, delete, open, cancel, no arrow, up, down, arrow and the four game-type tabs (none, exhibition, league, playoffs). */
#include "nhl95.h"

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
