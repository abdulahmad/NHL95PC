struct ent { short key, a, b, c; };
extern struct ent tA_C575C[8], tB_C571C[8];
void reset_ent(short which, short key)
{
    struct ent *p, *found;
    short i;
    p = which ? tA_C575C : tB_C571C;
    found = 0;
    for (i = 0; i < 8; p++, i++) {
        if (p->key == key) { found = p; break; }
    }
    if (found) { found->c = 0; found->a = found->b = found->c; }
}
