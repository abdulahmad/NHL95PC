/* Front end: sports desk. */
#include "nhl95.h"

/* DeskExitGame: "Exiting the game Do you wish to exit?" at the mouse position (music faded down meanwhile); on
 yes fade out, clear the screen, wait for the music slot to stop and free the song, show the credits and leave
 through bailout_vec. Returns 0 (no). */
int DeskExitGame(void)
{
    int x;
    int y;
    int r;

    if (musicon && songdata) sub_8FCDF(musichandle, 3, 0x64);
    sub_B2DCA(&x, &y, &r);
    msg_DeskExit = (int)str_ExitingTheGame;
    msg_DeskExit_e02 = (int)str_DoYouWishToExit;
    SetDialogColors(0xF9, 0xFA, 0xF8, 0xFA, 0);
    r = MessageBox(-1, -1, (char *)&msg_DeskExit, 3, (int)btn_POHumanOut, 2, (int)&x, (int)&y, -1);
    if (r > 0) {
        sub_8FFB0(0, 0x100, savepal);
        FadePalStep(1, savepal, 0x10);
        sub_B4BA8();
        sub_B392C(0);
        if (musicon && songdata) {
            while (!sub_8FC8A(*(int *)((char *)&musicslot - 3) >> 24, 3));
            sub_8D2F0(songdata);
            songdata = 0;
        }
        ShowLoadingScreen();
        sub_1B982();
        ShowCredits();
        sub_8FFB0(0, 0x100, savepal);
        FadePalStep(1, savepal, 0x10);
        sub_B4B58();
        ((void (*)(void))bailout_vec)();
    }
    return 0;
}
