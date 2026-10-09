/* FinishPlayoffs - simulate the rest of the playoffs from round (2-5: first round, second, conference finals,
   final) in the playoff buffer dword_C8C61: each round is simulated (SimPlayoffRound*) and the next one seeded
   (SeedPlayoff*, with the league's series option, gameopts bits 12-14), stopping at the first failure. After the
   final write the buffer (276h bytes at 199Ah) to fh, save the season database as <dir>\<season db name>.<ext>, run
   the awards ceremony and write the end marker 4ADh at 0. Returns the last call's result (non-zero: failed), -1 for
   a bad round. */
#include "nhl95.h"

int FinishPlayoffs(int fh, int a, int b, int c, char *dir, char *ext, int round)
{
    char path[32];
    int mark;
    int seed;
    int r;

    switch (round) {
    case 2:
        if ((r = SimPlayoffRound1(dword_C8C61, a, b, dir, ext)) != 0) break;
        if ((r = SeedPlayoffRound2(dword_C8C61, gameopts.optbits12, a, c, &seed)) != 0) break;
    case 3:
        if ((r = SimPlayoffRound2(dword_C8C61, a, b, dir, ext)) != 0) break;
        if ((r = SeedPlayoffRound3(dword_C8C61, gameopts.optbits12, a, c, &seed)) != 0) break;
    case 4:
        if ((r = SimPlayoffRound3(dword_C8C61, a, b, dir, ext)) != 0) break;
        if ((r = SeedPlayoffFinal(dword_C8C61, gameopts.optbits12, a, c, fh, &seed)) != 0) break;
    case 5:
        if ((r = SimPlayoffFinal(dword_C8C61, a, b, dir, ext)) != 0) break;
        if ((r = FileWriteAt(fh, (void *)dword_C8C61, 0x199A, 0x276)) != 0) break;
        MakePath(path, dir, (char *)leaguedbnames[5], ext);
        sub_932D0(path, seasondb, seasondb_size);
        AwardsCeremony();
        byte_DE268 = -1;
        mark = 0x4AD;
        r = FileWriteAt(fh, &mark, 0, 2);
        break;
    default:
        r = -1;
    }
    return r;
}
