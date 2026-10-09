/* Database merge: merge and update the team databases. */
#include "nhl95.h"

/* MergeUpdateDbs (3B8B0) - PC only: MergeLeagueFiles; then, for an unsaved league whose master team is not flagged
   2 and with no player id file, UpdateTeamDbs. When the merge returned nonzero the update runs on a cleared screen
   with box colours F8h-FAh set to greys 17h / 2Ah / 3Fh, put back to black afterwards. Returns the merge result. */
int MergeUpdateDbs(void)
{
    unsigned char rgb[3];
    int r;

    r = MergeLeagueFiles();
    if (leaguesaved == 0 && lgteamflags[leaguemaster * 30] != 2 && lgplayeridfile == 0) {
        if (r) {
            sub_B392C(lgplayeridfile);
            rgb[2] = rgb[1] = rgb[0] = 0x17;
            sub_B4B88(0xF8, 1, rgb);
            rgb[2] = rgb[1] = rgb[0] = 0x2A;
            sub_B4B88(0xF9, 1, rgb);
            rgb[2] = rgb[1] = rgb[0] = 0x3F;
            sub_B4B88(0xFA, 1, rgb);
        }
        UpdateTeamDbs();
        if (r) {
            sub_B392C(0);
            rgb[2] = rgb[1] = rgb[0] = 0;
            sub_B4B88(0xF8, 1, rgb);
            sub_B4B88(0xF9, 1, rgb);
            sub_B4B88(0xFA, 1, rgb);
        }
    }
    return r;
}
