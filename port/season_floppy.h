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
/* Next League Game pick (CheckLeagueDiskSync sync=0). 0: this machine can play
 * team — RAM +16h becomes 1 (imported) so "must be imported" stays off. -1:
 * not this machine's pick. guest is 1 on a client. mine is the team this
 * machine already picked (-1 none): a client may only import that team; other
 * remotes stay remote. With mine < 0 a client may only take a remote. */
int season_next_game_pick(unsigned char *teams, int team, int guest, int mine);
/* Teams this copy reports as its own (a guest's HELLO, the host's overlay list).
 * 26 records of 30 bytes. master: local humans (+18h != 2) and the controller
 * (+19h == 1), so Rangers stays the host's even if it was exported. Guest: only
 * mine (the team already claimed); mine < 0 means none — connecting must not
 * take leftover remotes. The controller is never a guest's. Returns how many
 * were written. */
int season_own_teams(const unsigned char *teams, int nteams, int master, int mine,
                     int *dest, int cap);

#endif
