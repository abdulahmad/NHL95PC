/* EASN stats: team stats screen from the sports desk. */
#define EasnTeamStatsScreen EasnTeamStatsScreenDecl
#define RunMenu RunMenuDecl
#include "nhl95.h"
#undef EasnTeamStatsScreen
#undef RunMenu

void RunMenu(void *bar, int n, int col1, int col2, int col3);

/* EasnTeamStatsScreen: the desk's team-stats page. Fill the palette buffer and fade out after the menu
 remap, draw TeamStatsScreen, and load embpal2 (from the CD when fileoncd 8Eh says so). Pal7 is faded in
 from the shape itself. keepdesksong stays set so the desk music is not freed. Returns 2. */
int EasnTeamStatsScreen(int cat)
{
    unsigned char buf[0x310];
    int one;
    char *dir;
    char *name;
    char *ext;
    int z;

    sub_8FFB0(0, 0x100, buf);
    one = 1;
    keepdesksong = one;
    dword_DC738 = one;
    statscategory = cat;
    statsredrawcb = (int)TeamStatsScreen;
    sub_B4BA8();
    InitMenuRemap(1);
    FadePalStep(1, buf, 0x10);
    TeamStatsScreen(cat);
    DrawMenuBar(unk_CF78F, 4, 0x40, 0x41, 0x42);
    ext = 0;
    name = (char *)str_embpal2;
    if (fileoncd[0x8E] == 1) dir = (char *)cddriveptr;
    else dir = 0;
    MakePath((char *)buf + 0x300, dir, name, ext);
    statsbgshapes = sub_8E83C((char *)buf + 0x300, 0);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pal7);
    FadePalStep(0, (unsigned char *)statspalshape + 0x10, 0x10);
    FreeMemBlock(statsbgshapes);
    RunMenu(unk_CF78F, 4, 0x40, 0x41, 0x42);
    sub_8FFB0(0, 0x100, buf);
    FadePalStep(1, buf, 0x10);
    z = 0;
    dword_DC738 = z;
    statsredrawcb = z;
    return 2;
}
