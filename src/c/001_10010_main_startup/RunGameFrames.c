/* Main / startup: game loop. */
#include "nhl95.h"

/* RunGameFrames (1149A) - run up to n game frames: every 3 frames take the next queued input event (none: stop; a hot key
   that HandleHotKey takes flushes the queue and stops); the clock runs while not stopped (dword_D8C78 + 100
   outside penalty shots); stop early on a deferred call, exit or game over. */
void RunGameFrames(int n)
{
    int i;
    unsigned char c;

    for (i = 0; i < n; i++) {
        if (!inputframes) {
            if (!(joyrec = (int)joyq_peek())) return;
            if ((c = ((unsigned char *)joyrec)[2]) & 0x80) {
                if (HandleHotKey(c) == 1) {
                    joyq_flush();
                    return;
                }
            }
            inputframes = 3;
        }
        if (!(gmode & 1)) {
            if (!penshotlive) dword_D8C78 += 100;
            ClockTick();
        }
        DoGameFrame();
        if (!--inputframes) joyq_pop();
        if (deferpending || exitgame || gameover) return;
    }
}
