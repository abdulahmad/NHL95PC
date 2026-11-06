struct pl { char pad[0x44]; unsigned b0:1, b1:1, b2:1, b3:1, b4:4, c0:1, c1:1, c2:1, c3:1; char pad2[0x80-0x48]; };
extern struct pl pl_DF81C[];
short pl_flag(short a, short b)
{
    if (b >= 0 && b <= 11) {
        struct pl *p = &pl_DF81C[b];
        if (p->c3) return b;
        p->b3 = 0;
        p->b1 = 1;
    }
    if (a >= 0 && a <= 11) pl_DF81C[a].b3 = 1;
    return a;
}
