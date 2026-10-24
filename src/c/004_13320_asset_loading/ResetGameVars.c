/* ResetGameVars: clear the in-game clocks, line-change slots, penalty and banner state, then
   start the period. Each photo-bank crowd slot gets a fresh timer. A keyboard pad recentres
   the mouse.
   DRAFT: 656 vs 657 (10.0 GA, 20 differing). The EXE ends in `jmp IndexPhotoBank_x`, so IndexPhotoBank is
   compiled first here as a compile-context copy (matched in IndexPhotoBank.c): Watcom then jumps to its
   epilogue as in the EXE. Plain constants: Watcom itself reuses the -1 / 0 registers (xor ch, dh for
   textline5). Left: the -1 copy into ecx comes after ovlstep (EXE before bannermsg), and the EXE zeroes
   esi before penshotmode and eax before shotontarget, then writes CwdExciteLvl from xor eax, esi (here
   xor esi, esi / si); the later zero registers follow. */
#define ResetGameVars ResetGameVars_decl
#include "nhl95.h"
#undef ResetGameVars

void __STOSB(void *p, int v, int n);
#pragma aux __STOSB "__STOSB" parm [eax] [edx] [ecx];
#pragma aux randomd0 modify [eax ecx];

/* Compile context (matched in IndexPhotoBank.c): IndexPhotoBank: look up the 50 photos of photo bank b
 (entries named "%04d", numbered from b * 50) in the bank (sub_B30BB) and store their pointers in photoptrs,
 up to the 1134 photos. */
void IndexPhotoBank(int b)
{
    char name[12];
    int n;
    int i;

    n = b * 50;
    for (i = 0; i < 50; i++) {
        sprintf(name, (char *)str_04d, n);
        photoptrs[n] = sub_B30BB(photobanks[b], name);
        if (++n >= 1134) break;
    }
}

void ResetGameVars(void)
{
    byte_E9AC8 = 0xFF;
    byte_E9AD3 = 0xFF;
    dword_CC0AC = 0;
    byte_E024F = 0;
    *(unsigned char *)&word_E024E = 0;
    byte_E024D[0] = 0;
    *(unsigned char *)byte_E024C = 0;
    ovltimer = -1;
    word_C90D8 = -1;
    RefStep[0] = -1;
    Pencntdwn = -1;
    word_CC0B0[0] = -1;
    threat = 0;
    passplayer = 0;
    passspeed = 0;
    passdir = 0;
    lastplayer = 0;
    shotplayer = 0;
    word_CBC44 = 0;
    RefPen = 0;
    refsignal = 0;
    Penaltytimer = 0;
    lcblinktime[1] = 0;
    lcblinktime[0] = 0;
    lcblink[1] = 0;
    lcblink[0] = 0;
    energywarn[1] = 0;
    energywarn[0] = 0;
    lcreqchoice[1] = 0;
    lcreqchoice[0] = 0;
    lcrequest[1] = 0;
    lcrequest[0] = 0;
    lcboxon[1] = 0;
    lcboxon[0] = 0;
    lctimer[1] = 0;
    lctimer[0] = 0;
    lcline[1] = 0;
    lcline[0] = 0;
    word_CBC60[0] = 0;
    lcsel[0] = 0;
    savedmousey = 0;
    savedmousex = 0;
    bannertimer = 0;
    word_CBEC6 = 0;
    word_CBEC2 = 0;
    bannermsg = -1;
    ovlstep = -1;
    ovlseq = -1;
    textline5 = 0;
    textline4 = 0;
    textline2 = 0;
    textline1 = 0;
    textline3 = 0;
    penshotmode = 0;
    penshotlive = 0;
    penshotstart = 0;
    shotontarget = 0;
    shotongoal = 0;
    penshotplayer = -1;
    CwdExciteLvl = 0;
    {
        int i;
        char *p;

        i = 0;
        do {
            p = (char *)word_DEE94 + i * 12;
            *(short *)p = -1;
            *(p + 2) = randomd0(0x28) + 0x3C;
            i++;
        } while (i < 20);
    }
    __STOSB(word_E9B2C, 0, 0x20);
    dword_E9A9E = 0;
    word_E9AAE = 0;
    dword_E9AB6 = 0;
    word_E9AA6 = 0;
    word_E9AA4 = 0;
    word_E9AA2 = 0;
    word_E9AAA = 0;
    dword_E009C = 0;
    word_E9A9C = -1;
    StartGame();
    curperiod = 1;
    if (pad1dev[0] == 1 || pad2dev == 1)
        MouseSetPos(0xA0, 0x64);
    deferpending = 0;
    inputframes = 0;
    exitgame = 0;
    gameover = 0;
    hudhundaccum = 0;
    frameaccum = 0;
    joysampling = 0;
    joysampling_save = 0;
    joyq_flush();
}
