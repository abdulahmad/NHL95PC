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
