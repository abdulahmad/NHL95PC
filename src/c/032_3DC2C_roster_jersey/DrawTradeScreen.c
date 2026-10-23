#define DrawTradeScreen DrawTradeScreen_decl
#define DrawDlgFrame DrawDlgFrame_decl
#include "nhl95.h"
#undef DrawTradeScreen
#undef DrawDlgFrame

void DrawDlgFrame(int x, int y, int w, int h, int edge);

/* DRAFT: 734 vs 735, art in ebp. The EXE keeps teams in edi from the entry (t in ecx) and leaves bank on
 the stack (sub esp, 38h, cookie 0x60); here t takes edi, teams is read from the stack and bank takes a
 register (sub esp, 34h). See docs/UNSURE.md. */
void DrawTradeScreen(int unused, int art, void *menu, int unused2, int count,
                     unsigned char *cols, int *teams)
{
    char path2[0x20];
    char path1[0x10];
    int bank;
    unsigned char *spal;
    unsigned char *pal;
    int shape;
    int i;
    int side;
    int t;
    int k;
    int base;
    unsigned char c1;
    unsigned char c2;

    (void)unused;
    (void)unused2;
    SetDrawBitmap(dword_DE264);
    MakePath(path1, fileoncd[0x8C] == 1 ? (char *)cddriveptr : 0, (char *)str_Embnhl2, 0);
    bank = sub_8E83C(path1, 0);
    sub_91370(sub_B30B4(bank, (char *)str_Bkgd9), 0, 0);
    FreeMemBlock(bank);
    DrawMenuBar(menu, count, 0x40, 0x41, 0x42);
    DrawDlgFrame(0x1C0, 0, 0x27F, 0x1DF, 1);
    DrawDlgFrame(0, 0, 0xBE, 0x1DF, 1);
    pal = (unsigned char *)sub_8CCA8((char *)str_Pal22, 0x300, 0x20);
    spal = pal;
    MakePath(path2, 0, (char *)str_Embpal3, 0);
    shape = sub_8E83C(path2, 0);
    statsbgshapes = shape;
    shape = sub_B30B4(shape, (char *)str_Pal21);
    statspalshape = shape;
    memcpy(pal, (unsigned char *)shape + 0x10, 0x300);
    FreeMemBlock(statsbgshapes);
    LoadTradeTeamPals(teams[0], teams[1], pal);
    traderemap1[0] = (int)byte_DC9D8;
    traderemap2 = (int)byte_DC8D8;
    for (i = 0; i < 4; i++) {
        t = i >> 1;
        memcpy(unk_D12C8, (unsigned char *)traderemap1[t] + 0x90, 0x30);
        c1 = jerseyremap[byte_D11BC[teams[t] * 4]];
        c2 = byte_D12DE;
        MakeJerseyShape(jerseyremap, cols[i * 22 + 1], c1, c2);
        sub_B4DD4(jerseyremap);
        sub_931FC(art, tradebtnx[i * 2], tradebtny[i * 2]);
    }
    for (side = 0; side < 2; side++) {
        for (i = 0; i < 0x1C; i++) {
            base = side * 0x268;
            k = (((i << 2) - i) << 2) - i;
            if (traderoster[base + k * 2] == 0)
                break;
            if (i == tradecursor[side])
                sub_8E9C0(0x42, 0x41);
            else
                sub_8E9C0(0x40, 0x41);
            k = (((i << 2) - i) << 2) - i;
            k += k;
            sub_93170((((side << 3) - side) << 6) + 5, byte_D42C3 * i + 0x1D, (char *)str_C2dS,
                      traderoster[base + k], tradejersey[base + k],
                      (char *)traderoster + base + k + 3);
        }
    }
    sub_B4BA8();
    sub_9121C(*(int *)(dword_DE264 + 0x2C));
    FadePalStep(0, spal, 0x10);
    FreeMemBlock((int)spal);
}
