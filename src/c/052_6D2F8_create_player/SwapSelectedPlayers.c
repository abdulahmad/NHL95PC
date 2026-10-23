/* Roster editor: swapping the selected players of the two lists. */
#define SwapSelectedPlayers SwapSelectedPlayers_decl
#define FixJerseyNumber FixJerseyNumber_decl
#include "nhl95.h"
#undef SwapSelectedPlayers
#undef FixJerseyNumber

typedef struct { char c[0x1B]; } RosterEnt;
typedef struct { char c[0x18]; } Msg24;

void FixJerseyNumber(int side, int i);

/* SwapSelectedPlayers (71333, PC only): the roster editor's "swap" button. Count the selected skaters (the first
   19h of each side's 1Ch rostersel flags) and goalies (the last three) in both lists; unless the counts agree,
   say which differ (str_TheNumberOfSelected + players / goalies / both, str_MustBeTheSame) at x / y. Otherwise
   pair the selected entries in list order and swap each pair between the two teams: the key records' first byte,
   the team records' key numbers (+4Ch, by roster slot), the slot bytes and the 1Bh-byte list entries; fix both
   jersey numbers (FixJerseyNumber) and clear (64h) every line slot (+BCh, 30h bytes) of either team that held
   the moved player. Then mark the database dirty and reload and redraw both lists. mode: the menu argument, not
   used; x, y: where the message box goes.
   DRAFT (GA): 857 vs 861, 50 differing. nb, ga, gb declared in that order give the EXE's count registers (edx,
   ebp, eax); the first `nb != s.na` then loads s.na into esi (EXE compares memory), a / b take ecx / edx (EXE
   eax / ecx) and the key-number swaps index EAF7C scaled (EXE `ecx = slot * 4`). See docs/UNSURE.md. */
void SwapSelectedPlayers(int *mode, int *x, int *y)
{
    struct {
        char msg[0x54];
        RosterEnt tmp;
        char pad;
        unsigned char idxa[0x1C];
        unsigned char idxb[0x1C];
        unsigned char slota[0x1C];
        unsigned char slotb[0x1C];
        int na;
    } s;
    int nb;
    int ga;
    int gb;
    int i;
    int ia;
    int j;
    int a;
    int b;
    unsigned char *p;
    unsigned char *q;

    nb = s.na = 0;
    ga = 0;
    gb = 0;
    for (i = 0; i < 0x19; i++) {
        if (rostersel[i]) s.na++;
        if (rostersel[i + 0x1C]) nb++;
    }
    for (i = 0; i < 3; i++) {
        if (byte_EAF99[i]) ga++;
        if (byte_EAFB5[i]) gb++;
    }
    if (nb != s.na || ga != gb) {
        *(Msg24 *)s.msg = *(Msg24 *)str_TheNumberOfSelected;
        if (nb != s.na && ga != gb) strcat(s.msg, (char *)str_PlayersAndGoalies);
        else if (nb != s.na) strcat(s.msg, (char *)str_Players);
        else if (ga != gb) strcat(s.msg, (char *)str_Goalies);
        msglines[0] = (int)s.msg;
        msglines[1] = (int)str_MustBeTheSame;
        MessageBox(-1, -1, (char *)msglines, 2, 0, 0, (int)x, (int)y, -1);
        return;
    }
    a = b = 0;
    for (i = 0; i < 0x1C; i++) {
        if (rostersel[i]) {
            s.slota[a] = rosterslot[i * 27];
            s.idxa[a] = i;
            a++;
        }
        if (rostersel[i + 0x1C]) {
            s.slotb[b] = byte_EAC86[i * 27];
            s.idxb[b] = i;
            b++;
        }
    }
    s.na += ga;
    for (i = 0; i < s.na; i++) {
        p = KeyDbPtr(((int *)(rosterteamrec[0] + 0x4C))[s.slota[i]]);
        q = KeyDbPtr(((int *)(dword_EAF7C + 0x4C))[s.slotb[i]]);
        *p ^= *q;
        *q ^= *p;
        *p ^= *q;
        ((int *)(rosterteamrec[0] + 0x4C))[s.slota[i]] ^= ((int *)(dword_EAF7C + 0x4C))[s.slotb[i]];
        ((int *)(dword_EAF7C + 0x4C))[s.slotb[i]] ^= ((int *)(rosterteamrec[0] + 0x4C))[s.slota[i]];
        ((int *)(rosterteamrec[0] + 0x4C))[s.slota[i]] ^= ((int *)(dword_EAF7C + 0x4C))[s.slotb[i]];
        ia = s.idxa[i];
        b = s.idxb[i];
        rosterslot[ia * 27] ^= byte_EAC86[b * 27];
        byte_EAC86[b * 27] ^= rosterslot[ia * 27];
        rosterslot[ia * 27] ^= byte_EAC86[b * 27];
        s.tmp = *(RosterEnt *)(rosterlist + ia * 27);
        *(RosterEnt *)(rosterlist + ia * 27) = *(RosterEnt *)(unk_EAC84 + b * 27);
        *(RosterEnt *)(unk_EAC84 + b * 27) = s.tmp;
        FixJerseyNumber(0, ia);
        FixJerseyNumber(1, s.idxb[i]);
        p = (unsigned char *)rosterteamrec[0] + 0xBC;
        for (j = 0; j < 0x30; j++)
            if (p[j] == s.slota[i]) p[j] = 0x64;
        p = (unsigned char *)dword_EAF7C + 0xBC;
        for (j = 0; j < 0x30; j++)
            if (p[j] == s.slotb[i]) p[j] = 0x64;
    }
    dbdirty = 1;
    LoadRosterList(0);
    LoadRosterList(1);
    DrawEditRosters();
}
