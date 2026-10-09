/* Trades: progress message. */
#include "nhl95.h"

/* MsgCopyingDatabases (414E0) - show the centred "Copying databases" message box with its argument set to arg. */
void MsgCopyingDatabases(int arg)
{
    msg_Copying_arg = arg;
    MessageBox(-1, -1, (char *)msg_Copying, 2, 0, 0, 0, 0, 0);
}
