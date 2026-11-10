/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Online season hooks for the SDL2 host: the game's league folder as Overbar's
 * export / import / copy / merge, a virtual A: for a floppy, and the room's
 * files + season messages. Overlay Season / File screens come from Overbar
 * once that pin includes them; until then the same actions sit as addons.
 */
#ifndef PORT_SEASON_H
#define PORT_SEASON_H

#include <stddef.h>

struct ob_host;
struct ob_net;

void port_season_setup(struct ob_host *h);
void port_season_free(void);
void port_season_bind_net(struct ob_net *n);
void port_season_unbind_net(void);
void port_season_poll(void);
/* 1: dos is on a virtual drive and *out is the host path; 0: not virtual; -1: virtual, no disk */
int port_season_map_dos(const char *dos, char *out, int size);
int port_season_diskfree(int letter, unsigned *total_clusters, unsigned *free_clusters,
                         unsigned *sectors_per_cluster, unsigned *bytes_per_sector);

#endif
