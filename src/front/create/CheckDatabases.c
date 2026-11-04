/* Create player: database check. */
/* Matched (10.0 GA): the skater id is tested through slot (shl eax, 2 / add eax, esi / mov ecx, [eax+4Ch])
 and read again from the record's key array for KeyDbPtr, which puts skaters++ (inc ebp) before the argument
 copy (mov eax, ecx); reading it twice through slot copied the argument first. The line pointer is what gives
 the counters ebp and edi. */
#include "nhl95.h"

/* TeamRecPtr and KeyDbPtr save and restore edx. ecx is listed so the record pointer is not left there. */
#pragma aux TeamRecPtr parm [eax] value [eax] modify [eax ecx];
#pragma aux KeyDbPtr parm [eax] value [eax] modify [eax ecx];

/* CheckDatabases: walk all 28 team records. Count filled skater slots (+4Ch, 25) and goalie slots (+B0h, 3);
 a filled skater whose key byte +2 is 'D' is a defenceman, otherwise a forward. An empty line byte (64h) sets
 a flag: forward lines (+BCh, 12), defence (+C8h, 6), power play (+CEh, 10), penalty kill (+D8h, 8), goalies
 (+E0h, 2), extra attacker (+E2h, 2). Fewer than 5 skaters, 3 forwards, 2 defence or 2 goalies sets the
 matching flag. Any flag stores a failing result and asks CheckTeamLines to print that team's messages,
 then leaves a blank text line. When the text line reaches 30, or the last team had any line, show the error
 screen; a result of -1 or 1 stops the walk. Returns -1 when every team was clean. */
int CheckDatabases(int x, int y)
{
    struct {
        int first;
        int sel;
        int line;
        int result;
        int team;
        int forwards;
        int goalies;
    } s;
    unsigned char *rec;
    int flags;
    int skaters;
    int defense;
    int i;
    int r;

    s.line = 0;
    s.result = -1;
    s.sel = -1;
    s.first = -1;
    s.team = 0;
    do {
        flags = 0;
        skaters = 0;
        s.goalies = 0;
        i = 0;
        s.forwards = 0;
        defense = 0;
        rec = TeamRecPtr(s.team);
        do {
            unsigned char *slot;
            slot = rec;
            slot += i << 2;
            if (*(int *)(slot + 0x4C) != -1) {
                skaters++;
                if (KeyDbPtr(((int *)(rec + 0x4C))[i])[2] == 0x44) defense++;
                else s.forwards++;
            }
            i++;
        } while (i < 25);
        i = 0;
        do {
            if (*(int *)(rec + i * 4 + 0xB0) != -1) s.goalies++;
            i++;
        } while (i < 3);
        {
            unsigned char *ln;
            ln = rec + 0xBC;
            i = 0;
            do {
                if (ln[i] == 0x64) flags |= 1;
                i++;
            } while (i < 12);
            ln = rec + 0xC8;
            i = 0;
            do {
                if (ln[i] == 0x64) flags |= 2;
                i++;
            } while (i < 6);
            ln = rec + 0xCE;
            i = 0;
            do {
                if (ln[i] == 0x64) flags |= 4;
                i++;
            } while (i < 10);
            ln = rec + 0xD8;
            i = 0;
            do {
                if (ln[i] == 0x64) flags |= 8;
                i++;
            } while (i < 8);
            ln = rec + 0xE0;
            i = 0;
            do {
                if (ln[i] == 0x64) flags |= 0x10;
                i++;
            } while (i < 2);
            ln = rec + 0xE2;
            i = 0;
            do {
                if (ln[i] == 0x64) flags |= 0x20;
                i++;
            } while (i < 2);
        }
        if (skaters < 5) flags |= 0x40;
        if (s.forwards < 3) flags |= 0x100;
        if (defense < 2) flags |= 0x200;
        if (s.goalies < 2) flags |= 0x80;
        r = -2;
        if (flags) {
            s.result = 0;
            r = CheckTeamLines(s.team, &s.line, &s.sel, &s.first, flags, x, y);
            if (s.line) s.line++;
        }
        if (r == -2) {
            if (s.line >= 0x1E || (s.line > 0 && s.team == 0x1B))
                r = ShowDBError(&s.sel, &s.line, x, y);
        }
        if (r == -1 || r == 1) s.team = 0x1C;
        s.team++;
    } while (s.team < 0x1C);
    return s.result;
}
