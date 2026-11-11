/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * Player 1 / Player 2 control rows in the game's menus. Four players on greys them
 * (handler cleared, so they are not editable). Off puts the handlers back.
 */
#ifndef NHL95_CTLROWS_H
#define NHL95_CTLROWS_H

void ctlrows_set(int *on1, int handler, int *saved, int *have, int four);
void ctlrows_sync(int four);

#endif
