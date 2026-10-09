/* Create player: roster edit. */
#include "nhl95.h"

/* RemovePlayerFromTeam (71043) - take the player with key record key off team's roster: the first of the 28 roster
   slots (+4Ch) whose key record has the same name (+24h..+2Fh) becomes -1 (facount + 1), and the line slots
   (+BCh, 48 bytes) that held it become 100 (empty). */
void RemovePlayerFromTeam(unsigned char team, int key)
{
    unsigned char *rec;
    unsigned char *kp;
    unsigned char *k;
    unsigned char *lines;
    unsigned char i;
    unsigned char found;

    rec = TeamRecPtr(team);
    kp = KeyDbPtr(key);
    found = 0xFF;
    for (i = 0; i < 0x1C && found == 0xFF; i++) {
        k = KeyDbPtr(*(int *)(rec + i * 4 + 0x4C));
        if (*(int *)(kp + 0x24) == *(int *)(k + 0x24) && *(int *)(kp + 0x28) == *(int *)(k + 0x28)
            && *(int *)(kp + 0x2C) == *(int *)(k + 0x2C)) {
            facount++;
            *(int *)(rec + i * 4 + 0x4C) = -1;
            found = i;
        }
    }
    if (found != 0xFF) {
        lines = rec + 0xBC;
        for (i = 0; i < 0x30; i++) {
            if (found == lines[i]) lines[i] = 100;
        }
    }
}
