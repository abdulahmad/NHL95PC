/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Tonight's Lineup helpers (port/lineup.c).
 * sh port/lineup_test.sh
 */
#include "lineup.h"

#include <stdint.h>
#include <stdio.h>
#include <string.h>

static int fails;

static void eq(int got, int want, const char *what)
{
    if (got == want) return;
    fprintf(stderr, "FAIL %s: got %d want %d\n", what, got, want);
    fails++;
}

static void eqstr(const char *got, const char *want, const char *what)
{
    if (got && want && !strcmp(got, want)) return;
    fprintf(stderr, "FAIL %s: got \"%s\" want \"%s\"\n", what, got ? got : "(null)", want ? want : "(null)");
    fails++;
}

static int eight_wide(const char *s)
{
    return (int)strlen(s) * 8;
}

int main(void)
{
    char buf[80], alt[96];
    char junk[200];

    eq(lineup_is_key_db("KEY.DB"), 1, "KEY.DB");
    eq(lineup_is_key_db("key.db"), 1, "key.db");
    eq(lineup_is_key_db("NHL95\\KEY.DB"), 1, "dir\\\\KEY.DB");
    eq(lineup_is_key_db("league/Key.Db"), 1, "dir/Key.Db");
    eq(lineup_is_key_db("TEAMS.DB"), 0, "TEAMS.DB");
    eq(lineup_is_key_db("NHL95\\key.05"), 0, "team key.05");
    eq(lineup_is_key_db(0), 0, "NULL path");

    eq(lineup_key_alt("NHL95\\KEY.DB", 0, 0, alt, sizeof alt), 1, "dir fallback");
    eqstr(alt, "KEY.DB", "dir fallback path");
    eq(lineup_key_alt("KEY.DB", "%s.DB", 0, alt, sizeof alt), 0, "same KEY.DB case-insensitive");
    eq(lineup_key_alt("KEY.DB", "NHL95\\%s.05", 0, alt, sizeof alt), 0, "skip team .nn fmt");
    eq(lineup_key_alt("KEY.DB", "NHL95\\%s.DB", "other\\%s.DB", alt, sizeof alt), 1, "fmt2 unused when fmt1 works");
    eqstr(alt, "NHL95\\key.DB", "league fmt");
    eq(lineup_key_alt("TEAMS.DB", "%s.DB", 0, alt, sizeof alt), 0, "not KEY");
    eq(lineup_key_alt("KEY.DB", 0, 0, alt, sizeof alt), 0, "no other path");

    memset(junk, 'A', sizeof junk);
    junk[sizeof junk - 1] = 0;
    lineup_fit_copy(buf, LINEUP_NAME_MAX, junk);
    eq((int)strlen(buf), LINEUP_NAME_MAX - 1, "bounded copy length");
    eq(buf[0] == 'A' && buf[LINEUP_NAME_MAX - 1] == 0, 1, "bounded copy NUL");
    lineup_fit_copy(buf, LINEUP_NAME_MAX, 0);
    eqstr(buf, "", "NULL last");
    lineup_fit_copy(buf, LINEUP_NAME_MAX, "MODANO");
    eqstr(buf, "MODANO", "short last");

    lineup_fit(buf, 0, "MODANO", 0xC8, eight_wide);
    eqstr(buf, "MODANO", "first=0 last");
    lineup_fit(buf, 0, junk, 0xC8, eight_wide);
    eq((int)strlen(buf) < LINEUP_NAME_MAX, 1, "long last fits");
    eq((int)strlen(buf) * 8 <= 0xC8, 1, "trimmed to maxw");
    lineup_fit(buf, 0, ".TIM", 0xC8, eight_wide);
    eqstr(buf, ".TIM", "heap fragment still copies when short");
    lineup_fit(buf, "MIKE", "MODANO", 8, eight_wide);
    eqstr(buf, "M", "initial plus trim");

    eq(lineup_ea_has((void *)(uintptr_t)0x10010060u, 0), 0, "NULL lists");
    eq(lineup_ea_has(0, (void *)1), 0, "NULL block");
    if (sizeof(void *) == 4) {
        unsigned char head[0x24], node[0x24], sent[0x24];
        void *lists[2];
        void *block = (void *)(uintptr_t)0x10010060u;
        memset(head, 0, sizeof head);
        memset(node, 0, sizeof node);
        memset(sent, 0, sizeof sent);
        *(void **)(head + 0x20) = node;
        *(void **)node = block;
        node[0x19] = 0;
        *(void **)(node + 0x20) = sent;
        lists[0] = head;
        lists[1] = sent;
        eq(lineup_ea_has(block, lists), 1, "live EA block");
        eq(lineup_ea_has((void *)(uintptr_t)0x10000000u, lists), 0, "unknown bump pointer");
        node[0x19] = 0x80;
        eq(lineup_ea_has(block, lists), 0, "flag 80h skipped");
    }

    eq(lineup_is_gipk("GIPK"), 1, "GIPK");
    eq(lineup_is_gipk("gipk"), 1, "gipk");
    eq(lineup_is_gipk("LOGOHOME"), 0, "LOGOHOME");

    if (fails) {
        fprintf(stderr, "%d failed\n", fails);
        return 1;
    }
    puts("lineup_test ok");
    return 0;
}
