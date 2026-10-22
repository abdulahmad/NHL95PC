/* Create player: search. */
#include "nhl95.h"

/* SelectMatchingPlayers: toggle the selection of every player on side's roster (or in the free-agent list when
 rosterisfa) whose lower-case name is first + last, or whose last name is first when last is empty. The roster
 selection is cleared first (free agents: falistsel, and with dword_D0C20 the first match is remembered in
 dword_EBCA4).
 DRAFT: same size, one add pair: the EXE adds falist to i * 27 and then 8 (add eax, edx / add eax, 8);
 &falist[i * 27 + 8] adds 8 first. Every other spelling of that address put falist in eax and the product in
 edx (the first-pass shape, 1 byte short). */
void SelectMatchingPlayers(char *first, char *last, int side)
{
    char f[16];
    char l[16];
    int i;
    unsigned char *k;

    if (rosterisfa[side] != 1) {
        for (i = 0; i < 0x1C; i++) rostersel[side * 28 + i] = 0;
        for (i = 0; i < 0x1C; i++) {
            k = KeyDbPtr(*(int *)((char *)dword_EA994 + side * 756 + i * 27));
            strcpy(f, (char *)k + 3);
            strcpy(l, (char *)k + 0x13);
            strlwr(f);
            strlwr(l);
            if ((!strcmp(first, f) && !strcmp(last, l)) || (!*last && !strcmp(first, l)))
                rostersel[side * 28 + i] = ~rostersel[side * 28 + i];
        }
    } else {
        for (i = 0; i < facount; i++) ((unsigned char *)falistsel)[i] = 0;
        if (dword_D0C20) dword_EBCA4 = -1;
        for (i = 0; i < facount; i++) {
            SplitPlayerName((char *)&falist[i * 27 + 8], f, l);
            strlwr(f);
            strlwr(l);
            if ((!strcmp(first, f) && !strcmp(last, l)) || (!*last && !strcmp(first, l))) {
                ((unsigned char *)falistsel)[i] = ~((unsigned char *)falistsel)[i];
                if (dword_D0C20 && dword_EBCA4 == -1) dword_EBCA4 = i;
            }
        }
    }
}
