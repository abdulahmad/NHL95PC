/* Schedule: simulate one day of the season. */
#define SimScheduleDay SimScheduleDay_decl
#define SimulateGame SimulateGame_decl
#define BuildPlayoffs BuildPlayoffs_decl
#include "nhl95.h"
#undef SimScheduleDay
#undef SimulateGame
#undef BuildPlayoffs

int SimulateGame(char *dir, char *ext, int n, unsigned char *game, int rwfh, int rdfh, int mode);
int BuildPlayoffs(int fh, int rwfh, int rdfh, unsigned char *teams, char *dir, char *ext);

/* SimScheduleDay: play the schedule games for one day. day selects the date from that game record.
 teams marks human clubs. team limits the games to one club, or -1 for every club. flags selects
 which human counts are played (1 both, 2 one, 4 none); 7 also builds the playoffs once a human
 game is still ahead. Returns the file error, or 0. */
int SimScheduleDay(int fh, int rwfh, int rdfh, int day, unsigned char *teams, char *dir, char *ext,
                   int team, int flags)
{
    struct {
        unsigned char game[8];
        int id;
        int rdfh;
        int stop;
        int date;
        int last;
        int rwfh;
        int pos;
    } s;
    int err;
    int i;
    int human;
    unsigned char *club;

    s.rwfh = rwfh;
    s.rdfh = rdfh;
    club = teams;
    s.stop = 0;
    err = ReadSchedGame(fh, s.game, day - 1);
    if (!err) {
        s.date = DateKey(s.game[0], s.game[1]);
        s.last = 0;
        for (i = 0; i < 0x444 && !s.stop && !err; i++) {
            err = ReadSchedGame(fh, s.game, i);
            if (err)
                continue;
            if (DateKey(s.game[0], s.game[1]) <= s.date) {
            s.last = i;
            human = 0;
            s.id = s.game[2];
            if (club[((s.id << 4) - s.id) * 2 + 0x17] == 1)
                human = 1;
            s.id = s.game[3];
            if (club[((s.id << 4) - s.id) * 2 + 0x17] == 1)
                human++;
            if (s.game[4] != 0xFF && s.game[5] != 0xFF)
                continue;
            if (team != -1 && s.game[2] != team && s.game[3] != team)
                continue;
            if ((flags & 1) && human == 2)
                ;
            else if ((flags & 4) && human == 0)
                ;
            else if ((flags & 2) && human == 1)
                ;
            else
                continue;
            err = SimulateGame(dir, ext, i, s.game, s.rwfh, s.rdfh, -1);
            if (!err)
                err = WriteSchedGame(fh, s.game, i);
            } else if (s.game[2] != 0xFF && s.game[3] != 0xFF &&
                (club[s.game[2] * 30 + 0x17] == 1 || club[s.game[3] * 30 + 0x17] == 1))
                s.stop = 1;
        }
        if (flags == 7 && !s.stop && !err) {
            i = s.last;
            if (i < 0x444) {
                s.pos = 0x444;
                err = FileWriteAt(fh, &s.pos, 0, 2);
                for (; i < 0x444 && !err; i++) {
                    err = ReadSchedGame(fh, s.game, i);
                    if (err)
                        continue;
                    if (s.game[4] != 0xFF && s.game[5] != 0xFF)
                        continue;
                    err = SimulateGame(dir, ext, i, s.game, s.rwfh, s.rdfh, -1);
                    if (err)
                        continue;
                    err = WriteSchedGame(fh, s.game, i);
                }
                err = BuildPlayoffs(fh, s.rwfh, s.rdfh, club, dir, ext);
            }
        }
    }
    return err;
}
