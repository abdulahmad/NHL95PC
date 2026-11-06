/* Engine core: one game frame. */
#include "nhl95.h"

/* DoGameFrame: one frame of play: periodic events, player update, rink window, then replay recording
 (updatereplay, tail call). */
void DoGameFrame(void)
{
    periodicevents();
    updateplayers();
    checkwindow();
    updatereplay();
}
