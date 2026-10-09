extern int idx_CC13C, sign_CC140, o_CC130, o_CC134, o_CC138;
extern int tbl_CCB18[];
void next_entry(void)
{
    int k = idx_CC13C * 3;
    int v = tbl_CCB18[k];
    if (sign_CC140 < 0) v = -v;
    o_CC130 = v;
    o_CC134 = tbl_CCB18[k + 1];
    o_CC138 = tbl_CCB18[k + 2];
    idx_CC13C++;
}
