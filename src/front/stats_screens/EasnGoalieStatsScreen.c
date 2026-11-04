/* EASN stats: goalie stats screen from the sports desk.
 DRAFT: 467 vs 474. The page matches through the first embpal2 load. After the menu, Watcom keeps the
 gamemode==1 arm beside the test (je short) and the fileoncd test is je to the drive load. The original
 je near lands after the ret, the 6Ah test is jne to xor edx after the ret, and the 8Eh arm is only a jmp
 to that jne. A flipped compare, a duplicated MakePath, and gotos to those labels compiled to the same
 shape. Do not retry those. */
#define EasnGoalieStatsScreen EasnGoalieStatsScreenDecl
#define RunMenu RunMenuDecl
#include "nhl95.h"
#undef EasnGoalieStatsScreen
#undef RunMenu

void RunMenu(void *bar, int n, int col1, int col2, int col3);
int LeadersScreen(int cat);

/* EasnGoalieStatsScreen: the desk's goalie page. Fade out, draw LeadersScreen, load embpal2 and fade Pal7
 in from the shape, run the menu, then load easndesk2 (or embpal2 again when gamemode is 1) and fade back.
 keepdesksong stays set. The second load is EasnGoalieStatsScreen_common, which the skater page jumps to.
 Returns 2. */
int EasnGoalieStatsScreen(int cat)
{
    unsigned char buf[0x310];
    char *dir;
    char *name;
    char *ext;
    char *dir2;
    char *name2;
    char *ext2;

    keepdesksong = 1;
    sub_8FFB0(0, 0x100, buf);
    dword_DC738 = 1;
    statscategory = cat;
    statsredrawcb = (int)LeadersScreen;
    sub_B4BA8();
    InitMenuRemap(1);
    FadePalStep(1, buf, 0x10);
    LeadersScreen(cat);
    DrawMenuBar(unk_CF88F, 4, 0x40, 0x41, 0x42);
    ext = 0;
    name = (char *)str_embpal2;
    if (fileoncd[0x8E] == 1) dir = (char *)cddriveptr;
    else dir = 0;
    MakePath((char *)buf + 0x300, dir, name, ext);
    statsbgshapes = sub_8E83C((char *)buf + 0x300, 0);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pal7);
    FadePalStep(0, (unsigned char *)statspalshape + 0x10, 0x10);
    FreeMemBlock(statsbgshapes);
    RunMenu(unk_CF88F, 4, 0x40, 0x41, 0x42);
    sub_8FFB0(0, 0x100, buf);
    if (gamemode != 1) {
        ext2 = 0;
        name2 = (char *)str_easndesk2;
        if (fileoncd[0x6A] == 1) dir2 = (char *)cddriveptr;
        else dir2 = 0;
    } else {
        ext2 = 0;
        name2 = (char *)str_embpal2;
        if (fileoncd[0x8E] == 1) dir2 = (char *)cddriveptr;
        else dir2 = 0;
    }
    MakePath((char *)buf + 0x300, dir2, name2, ext2);
    statsbgshapes = sub_8E83C((char *)buf + 0x300, 0);
    statspalshape = sub_B30B4(statsbgshapes, (char *)str_Pal7) + 0x10;
    FadePalStep(1, buf, 0x10);
    FreeMemBlock(statsbgshapes);
    dword_DC738 = 0;
    statsredrawcb = 0;
    return 2;
}
