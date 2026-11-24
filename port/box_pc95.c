/* SPDX-License-Identifier: MIT
 * Copyright (c) 2026 abdulahmad and contributors
 *
 * The box for NHL Hockey '95 PC (overbar/box_cd.h): the big box, the manual, the jewel case and the cards; the first time, the
 * CD into the 486's CD-ROM drive and the game's own installer (INSTALL.EXE, 1994) on its monitor, screen by screen. The
 * installer's screens are pictures in the player's art folder (box-art/pc95/inst95*.png), like the scans. */
#include <overbar/box_cd.h>

static const bx_cd_step STEPS[] = {
    { CD_TEXT, "d:", 1, 0, 0 },
    { CD_TEXT, "D:\\>", 0, 500, 0 },
    { CD_TEXT, "install", 1, 0, 0 },
    { CD_SCREEN, "inst95a", 0, 2200, 0 },        /* What type of installation: 1 Minimum, 2 Recommended */
    { CD_SCREEN, "inst95b", 0, 1600, 1 },        /* 2; What hard drive [C] */
    { CD_SCREEN, "inst95c", 0, 2600, 1 },        /* the space needed; Destination Path C:\HOCKEY */
    { CD_SCREEN, "inst95d", 0, 2000, 1 },        /* Sound Card Selection */
    { CD_SCREEN, "inst95e", 0, 2000, 1 },        /* 4 (Sound Blaster); Ready to install, ENTER */
    { CD_COPY, "inst95copy0", 0, 900, 1 },       /* Copying files to the hard disk: the bar fills */
    { CD_COPY, "inst95copy1", 0, 900, 0 }, { CD_COPY, "inst95copy2", 0, 900, 0 }, { CD_COPY, "inst95copy3", 0, 900, 0 },
    { CD_COPY, "inst95copy4", 0, 900, 0 }, { CD_COPY, "inst95copy5", 0, 900, 0 }, { CD_COPY, "inst95copy6", 0, 900, 0 },
    { CD_COPY, "inst95copy7", 0, 900, 0 }, { CD_COPY, "inst95copy8", 0, 700, 0 },
    { CD_CLS, 0, 0, 150, 0 },
    { CD_TEXT, "NHL Hockey has successfully been installed.", 0, 60, 0 },
    { CD_TEXT, "Just type \"HOCKEY\" to start the game.", 0, 60, 0 },
    { CD_TEXT, "", 0, 60, 0 },
    { CD_TEXT, "C:\\HOCKEY>", 0, 1200, 0 },
    { CD_TEXT, "hockey", 1, 0, 0 },
};
const bx_cd_game BOX_PC95 = { "pc95", "NHL Hockey '95", 40, 0, STEPS, (int)(sizeof STEPS / sizeof STEPS[0]) };
