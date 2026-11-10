/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Tonight's Lineup on the 95 PC port: KEY.DB open, bounded names, GIPK zero,
 * skip FreeMemBlock of a pointer the EA list does not own.
 */
#ifndef NHL95_LINEUP_H
#define NHL95_LINEUP_H

#include <stddef.h>

#define LINEUP_NAME_MAX 32

void lineup_install(void);

/* Basename is KEY.DB (any case, DOS or host separators). */
int lineup_is_key_db(const char *path);

/* After FileOpenRead of KEY.DB fails: another path to try, or 0. fmt / fmt2 are
 * leaguedbfmt / leaguedbfmt2 (sprintf with "key"), or NULL in tests. */
int lineup_key_alt(const char *failed, const char *fmt, const char *fmt2, char *alt, size_t n);

/* Bounded last-name copy (FitPlayerName's first=0 path, and the last piece of "F. last"). */
void lineup_fit_copy(char *dst, size_t dstn, const char *s);

/* FitPlayerName with bounded copies. width() is fputchar, or a test stub. */
void lineup_fit(char *dst, const char *first, const char *last, int maxw, int (*width)(const char *));

/* findmemblock's walk: lists is dword_D2F58. 1 if p is a live user pointer. */
int lineup_ea_has(const void *p, const void *lists);

int lineup_is_gipk(const char *name);

#endif
