/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * The floppy folder Import Databases > Player reads: PLAYER.ID, PINFO.DB (team
 * exported), GAME.SET, and the seven DBs as both .DB and .NN. No typed filename.
 */
#ifndef PORT_SEASON_FLOPPY_H
#define PORT_SEASON_FLOPPY_H

/* from: league folder. to: floppy folder. league: "FOO.LP". touch_src: mark the
 * league's PINFO exported (the host's Export Databases). 0 ok, -1 fail. */
int season_pack_floppy(const char *from, const char *to, int team, const char *league, int touch_src);
/* 1 if ImportPlayerTeam can open this floppy for team/league. */
int season_floppy_ready(const char *dir, int team, const char *league);
/* copy the floppy into root/<league>/ (mkdir), mark the team imported. league_out
 * gets the folder name. 0 ok, -1 fail. */
int season_install_floppy(const char *floppy, const char *root, char *league_out, int league_size);

#endif
