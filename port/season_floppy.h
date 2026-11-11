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
/* copy the floppy into root/<league>/ (mkdir). league_out gets the folder name.
 * 0 ok, -1 fail. PINFO +16h stays 2 (an export) unless season_mark_imported. */
int season_install_floppy(const char *floppy, const char *root, char *league_out, int league_size);
/* this machine has imported team: PINFO +16h = 1 so the calendar will not ask. */
int season_mark_imported(const char *dir, int team);
/* File > Import Databases > Player onto an existing league: copy team's seven DBs
 * and its PINFO row from from/ into to/, then mark it imported. 0 ok, -1 fail. */
int season_import_team(const char *from, const char *to, int team);
/* PLAYER.ID for FindLeagueFloppy / GetLeagueId (team byte, 11-byte name, league, version). */
int season_write_player_id(const char *dir, int team, const char *league);
/* read PLAYER.ID: team 0..25, version (the 4 bytes Export writes). 0 ok, -1 none. */
int season_player_id(const char *dir, int *team, unsigned *version);

#endif
