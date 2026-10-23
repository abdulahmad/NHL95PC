/* Key team database: fill the goalie menu items from the dressed goalies. */
#include "nhl95.h"

/* SetupGoalieMenu: for each dressed goalie, copy the menu template, patch the jersey
 number into the digit placeholders, the byte at player+7, and 16 bytes of the name,
 then store the text width plus 5. The two goalie rows share the wider width, and the
 dressed goalie's item (or "none" when the goalie index is negative) is marked on. */
void SetupGoalieMenu(void)
{
    signed char buf[0x20];
    unsigned char *m;
    unsigned char *p;

    m = unk_CEE4F;
    p = hmroster + hmgoalieidx[0] * 39;
    strcpy((char *)buf, (char *)mi_HomeGoalie1);
    if (p[5] < 10)
        buf[2] = buf[1];
    else
        buf[2] += p[5] / 10;
    buf[3] += p[5] % 10;
    buf[5] = p[7];
    strncpy((char *)buf + 8, (char *)p + 0x17, 16);
    *(int *)(m + 8) = fputchar((char *)buf) + 5;
    strcpy((char *)*(int *)(m + 0x10), (char *)buf);

    p = hmroster + hmgoalieidx[1] * 39;
    strcpy((char *)buf, (char *)*(int *)(m + 0x30));
    if (p[5] < 10)
        buf[2] = buf[1];
    else
        buf[2] += p[5] / 10;
    buf[3] += p[5] % 10;
    buf[5] = p[7];
    strncpy((char *)buf + 8, (char *)p + 0x17, 16);
    *(int *)(m + 0x28) = fputchar((char *)buf) + 5;
    strcpy((char *)*(int *)(m + 0x30), (char *)buf);

    if (*(int *)(m + 8) > *(int *)(m + 0x28)) {
        *(int *)(m + 0x48) = *(int *)(m + 8);
        *(int *)(m + 0x28) = *(int *)(m + 8);
    } else {
        *(int *)(m + 0x48) = *(int *)(m + 0x28);
        *(int *)(m + 8) = *(int *)(m + 0x28);
    }
    if (hmtmgoalie[0] < 0)
        *(unsigned char *)*(int *)(m + 0x50) = 1;
    else
        *(unsigned char *)*(int *)(m + 0x10 + (hmtmgoalie[0] << 5)) = 1;

    m = unk_CEEAF;
    p = awroster + awgoalieidx[0] * 39;
    strcpy((char *)buf, (char *)mi_AwayGoalie1);
    if (p[5] < 10)
        buf[2] = buf[1];
    else
        buf[2] += p[5] / 10;
    buf[3] += p[5] % 10;
    buf[5] = p[7];
    strncpy((char *)buf + 8, (char *)p + 0x17, 16);
    *(int *)(m + 8) = fputchar((char *)buf) + 5;
    strcpy((char *)*(int *)(m + 0x10), (char *)buf);

    p = awroster + awgoalieidx[1] * 39;
    strcpy((char *)buf, (char *)*(int *)(m + 0x30));
    if (p[5] < 10)
        buf[2] = buf[1];
    else
        buf[2] += p[5] / 10;
    buf[3] += p[5] % 10;
    buf[5] = p[7];
    strncpy((char *)buf + 8, (char *)p + 0x17, 16);
    *(int *)(m + 0x28) = fputchar((char *)buf) + 5;
    strcpy((char *)*(int *)(m + 0x30), (char *)buf);

    if (*(int *)(m + 8) > *(int *)(m + 0x28)) {
        *(int *)(m + 0x48) = *(int *)(m + 8);
        *(int *)(m + 0x28) = *(int *)(m + 8);
    } else {
        *(int *)(m + 0x48) = *(int *)(m + 0x28);
        *(int *)(m + 8) = *(int *)(m + 0x28);
    }
    if (awtmgoalie < 0)
        *(unsigned char *)*(int *)(m + 0x50) = 1;
    else
        *(unsigned char *)*(int *)(m + 0x10 + (awtmgoalie << 5)) = 1;
}
