/* Season playoffs: simulating the playoffs after an elimination. */
/* DRAFT: same size, all but one call (the round branch's RestoreDialogBg is cross-jumped into the other branch's);
   see docs/UNSURE.md. No goto: the simulate path is nested under the first MessageBox (the same code as the old
   `goto save`). Its match belongs in POCreateSchedule.c, whose POCreateSchedule_x tail it uses (tested there:
   the same single difference). */
#define POSeedConfFinals POSeedConfFinals_decl
#define POSeedFinal POSeedFinal_decl
#define DrawPlayoffTree DrawPlayoffTree_decl
#define POHandleElimination POHandleElimination_decl
#include "nhl95.h"
#undef POSeedConfFinals
#undef POSeedFinal
#undef DrawPlayoffTree
#undef POHandleElimination

void POSeedConfFinals(unsigned char *po);
void POSeedFinal(unsigned char *po);
void DrawPlayoffTree(void);

/* POHandleElimination (88096, PC only; ends in POCreateSchedule_x): after a human team's playoff game decided its
   series. Redraw the playoff tree and load the embpal bank's BangPal palette. mode 0: just the menu bar (unk_CF90F)
   and fade in. Otherwise load the league's season, career and key databases (leaguedbnames 5, 1, 0) and, for mode
   1 (the human teams are out), ask whether to simulate the rest; if so say so (msg_POGenFinal) and simulate the
   remaining rounds from the current one (+44h: the first round's last four series and the conference finals
   seeding, the conference finals and the final seeding, the final; each series as long as the league option
   (gameopts bits 12-14) with its unplayed games cleared), copy the series teams into playofftree (empty slots 1Ah)
   and store the champion (pochampion, 1Ah for none). Other modes show msg_POTeamOut for a second. Then save the
   season database, free the three, save the schedule, redraw the tree and the menu bar and fade in. mode: 0, 1 or
   other; po: the playoff schedule. No result. */
void POHandleElimination(int mode, unsigned char *po)
{
    struct {
        char path[0x40];
        char ppath[0x20];
        int y;
        int x;
        int bank;
        unsigned char *pal;
    } s;
    unsigned char *ser;
    unsigned char *p;
    int i;
    int g;
    int k;
    int z;
    int bank;

    s.x = 0xA0;
    s.y = 0x64;
    dword_C6D26 = 0;
    DrawPlayoffTree();
    MakePath(s.ppath, fileoncd[0x8E] == 1 ? (char *)cddriveptr : 0, (char *)str_Embpal, 0);
    s.bank = bank = sub_8E83C(s.ppath, 0);
    s.pal = (unsigned char *)sub_B30B4(bank, (char *)str_BangPal) + 0x10;
    if (mode == 0) {
        DrawMenuBar(unk_CF90F, 3, 0x40, 0x41, 0x42);
        FadePalStep(0, s.pal, 0x10);
        FreeMemBlock(bank);
        return;
    }
    SetDialogColors(0x41, 0x40, 0x42, 0x40, 0);
    MakePath(s.path, (char *)&curleague, (char *)leaguedbnames[5], (char *)str_extDB);
    seasondb = (unsigned char *)sub_8E8A0(s.path, 0x20);
    seasondb_size = sub_92DE0(s.path);
    MakePath(s.path, (char *)&curleague, (char *)leaguedbnames[1], (char *)str_extDB);
    careerdb = (unsigned char *)sub_8E8A0(s.path, 0x20);
    careerdb_size = sub_92DE0(s.path);
    MakePath(s.path, (char *)&curleague, (char *)leaguedbnames[0], (char *)str_extDB);
    keydb = (unsigned char *)sub_8E8A0(s.path, 0x20);
    keydb_size = sub_92DE0(s.path);
    if (mode == 1) {
        FadePalStep(0, s.pal, 0x10);
        if (MessageBox(-1, -1, (char *)msg_POHumanOut, 4, (int)btn_POHumanOut, 2, (int)&s.x, (int)&s.y, -1) != 0) {
            MessageBox(-1, -1, (char *)msg_POGenFinal, mode, 0, 0, (int)&s.x, (int)&s.y, 0);
            switch (*(unsigned *)(po + 0x44)) {
            case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7:
                *(int *)(po + 0x70) = *(int *)(po + 0x74) = *(int *)(po + 0x78) = *(int *)(po + 0x7C) = gameopts.optbits12;
                ser = po + 0x1AE8;
                for (i = 8; i < 0xC; i++, ser += 0x2A) {
                    POSimSeries(ser, gameopts.optbits12);
                    g = 0;
                    for (; g < 7 && ser[g * 6 + 4] != 0xFF; g++);
                    k = (gameopts.optbits12 >> 1) + 1;
                    g -= k;
                    for (; k < 4; k++) {
                        p = ser + (g + k) * 6;
                        p[0] = p[1] = p[2] = p[3] = p[4] = p[5] = 0xFF;
                    }
                }
                POSeedConfFinals(po);
            case 8: case 9: case 10: case 11:
                *(int *)(po + 0x80) = *(int *)(po + 0x84) = gameopts.optbits12;
                ser = po + 0x1B90;
                for (i = 0xC; i < 0xE; i++, ser += 0x2A) {
                    POSimSeries(ser, gameopts.optbits12);
                    g = 0;
                    for (; g < 7 && ser[g * 6 + 4] != 0xFF; g++);
                    k = (gameopts.optbits12 >> 1) + 1;
                    g -= k;
                    for (; k < 4; k++) {
                        p = ser + (g + k) * 6;
                        p[0] = p[1] = p[2] = p[3] = p[4] = p[5] = 0xFF;
                    }
                }
                POSeedFinal(po);
            case 12: case 13:
                *(int *)(po + 0x88) = gameopts.optbits12;
                ser = po + 0x1BE4;
                POSimSeries(ser, gameopts.optbits12);
                g = 0;
                for (; g < 7 && ser[g * 6 + 4] != 0xFF; g++);
                k = (gameopts.optbits12 >> 1) + 1;
                g -= k;
                for (; k < 4; k++) {
                    p = ser + (g + k) * 6;
                    p[0] = p[1] = p[2] = p[3] = p[4] = p[5] = 0xFF;
                }
            }
            ser = po + 0x1AE8;
            for (i = 0x10; i < 0x1E; i += 2, ser += 0x2A) {
                playofftree[i] = ser[2];
                playofftree_p1[i] = ser[3];
                if (playofftree[i] == 0xFF) playofftree[i] = 0x1A;
                if (playofftree_p1[i] == 0xFF) playofftree_p1[i] = 0x1A;
            }
            ser = po + 0x1BE4;
            pochampion = SeriesWinner(ser, *(int *)(po + 0x88));
            if (pochampion == -1) pochampion = 0x1A;
            RestoreDialogBg();
        }
    } else {
        SetTickDeadline(1000);
        FadePalStep(0, s.pal, 0x10);
        MessageBox(-1, -1, (char *)msg_POTeamOut, 6, 0, 0, (int)&s.x, (int)&s.y, 0);
        WaitTickDeadline();
        RestoreDialogBg();
    }
    FadePalStep(1, s.pal, 0x10);
    MakePath(s.path, (char *)&curleague, (char *)leaguedbnames[5], (char *)str_extDB);
    sub_932D0(s.path, seasondb, seasondb_size);
    if (seasondb) FreeMemBlock((int)seasondb);
    if (careerdb) FreeMemBlock((int)careerdb);
    if (keydb) FreeMemBlock((int)keydb);
    z = 0;
    seasondb = (unsigned char *)z;
    careerdb = (unsigned char *)z;
    keydb = (unsigned char *)z;
    seasondb_size = z;
    careerdb_size = z;
    keydb_size = z;
    SaveScheduleDB((char *)po);
    dword_C6D26 = z;
    DrawPlayoffTree();
    DrawMenuBar(unk_CF90F, 3, 0x40, 0x41, 0x42);
    FadePalStep(0, s.pal, 0x10);
    FreeMemBlock(s.bank);
}
