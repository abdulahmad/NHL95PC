/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Online season hooks for the SDL2 host. The game's league folder is Overbar's
 * export / import / copy / merge. Teams marked for export at New League (floppy
 * "played on another computer") are remote slots: a guest Pick a team claims
 * one by name, and the port copies that team's DBs. Overlay Season / File
 * screens come from Overbar (ob_season_set). Export, import, and Merge & Update
 * of team databases run in the background when the copies need them — the
 * player never has to use those File menu items. Pack files, when used, are
 * named after the team — not a typed .obt filename.
 */
#ifndef PORT_SEASON_H
#define PORT_SEASON_H

#include <stddef.h>
#include <stdint.h>

struct ob_host;
struct ob_net;

void port_season_setup(struct ob_host *h);
/* after plat_make_image_writable — not from video_init / port_season_setup,
 * when .text is still read-only and patch_jmp would crash at startup */
void port_season_install_hooks(void);
void port_season_free(void);
void port_season_bind_net(struct ob_net *n);
void port_season_unbind_net(void);
void port_season_poll(void);
/* overlay is drawn: rebuild the File bar if the league changed, keep A: on the
 * copy used in play, log season lines when OVERBAR_TEST_LOG is set */
void port_season_tick(void);
/* 1: host vs a guest in the room (online). 0: local — A vs CPU / A vs B, or C vs D
 * after export/import onto this machine. */
int port_season_want_online(void);
/* after PlayGame of a league match: mark it played, drop mirrors, sync */
void port_season_after_game(void);
/* 1: dos is on a virtual drive and *out is the host path; 0: not virtual; -1: virtual, no disk */
int port_season_map_dos(const char *dos, char *out, int size);
int port_season_diskfree(int letter, unsigned *total_clusters, unsigned *free_clusters,
                         unsigned *sectors_per_cluster, unsigned *bytes_per_sector);

#endif
