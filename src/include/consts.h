/* consts.h - named constants for the NHL 95 PC C sources (values from the asm; Genesis names where they exist). */
#ifndef CONSTS_H
#define CONSTS_H


/* SPAlist animation numbers: one per sequence of SPAlist (src/data/engine/frames.asm), named as the labels there */
#define SPAgready       0x1
#define SPAgready2      0x99
#define SPAgglover      0xB1
#define SPAgglovel      0xC9
#define SPAgglovel2     0xE1
#define SPAgstickr      0x101
#define SPAgstickl      0x119
#define SPAgstackr      0x131
#define SPAgstackl      0x159
#define SPAgdive        0x181
#define SPAgswing       0x1B9
#define SPAgskate       0x1F1
#define SPApflip        0x239
#define SPAglide        0x289
#define SPAskatewp      0x2A1
#define SPAskate        0x2E9
#define SPAturnl        0x331
#define SPAturnr        0x349
#define SPAstop         0x361
#define SPApassf        0x389
#define SPApassb        0x3C1
#define SPAshotf        0x3F9
#define SPAshotb        0x491
#define SPAglideback    0x529
#define SPAskateback    0x541
#define SPAsweepchk     0x589
#define SPAshoulderchkl 0x5C1
#define SPAshoulderchkr 0x5D9
#define SPAhipchkl      0x5F1
#define SPAhipchkr      0x609
#define SPAburst        0x621
#define SPAHold         0x639
#define SPAHold2        0x651
#define SPAflail        0x669
#define SPAfallfwd      0x681
#define SPAfallback     0x6D9
#define SPAcelebrate    0x731
#define SPApump         0x769
#define SPAwallright    0x7A1
#define SPAwallleft     0x7BF
#define SPAfaceoff      0x7DD
#define SPAfaceoffr     0x7F1
#define SPAsiren        0x7FD
#define SPAbglass       0x821
#define SPAstanley      0x833
#define SPAcatch        0x84B
#define SPAhook         0x873
#define SPAhook2        0x88B
#define SPAstumble      0x8D3
#define SPAfake         0x92B
#define SPAflip         0x993
#define SPAinjury1      0xA0B
#define SPArefglide     0xA5B
#define SPArefskate     0xA73
#define SPArefturnl     0xABB
#define SPArefturnr     0xAD3
#define SPArefstop      0xAEB
#define SPAreffallback  0xB13
#define SPAarmupglide   0xB4B
#define SPAarmupskate   0xB63
#define SPAarmupturnl   0xBAB
#define SPAarmupturnr   0xBC3
#define SPAarmupstop    0xBDB
#define SPArefpickup    0xC03
#define SPArefpointgoa  0xC1B
#define SPArefdrop      0xC43
#define SPAreffowait    0xC57
#define SPArefrough     0xC63
#define SPArefcharge    0xC73
#define SPArefslash     0xC8B
#define SPArefxcheck    0xC9B
#define SPArefhook      0xCAB
#define SPAreftrip      0xCBB
#define SPArefinterfer  0xCCB
#define SPArefhold      0xCD9
#define SPArefabuseoff  0xCE7
#define SPArefbehind    0xCF5
#define SPAfaceoffpoke  0xD05
#define SPAgwallright   0xD15
#define SPAgwallleft    0xD2D
#define SPAanthem1      0xD45
#define SPAanthem2      0xD57
#define SPAanthem3      0xD67
#define SPAanthem4      0xD7B
#define SPAanthem5      0xD89
#define SPAdrink        0xD97
#define SPArefanthem1   0xDAB
#define SPArefanthem2   0xDC3
#define SPAonetimef     0xDD3
#define SPAonetimeb     0xE2B
#define SPAgetcup       0xE83
#define SPAbrcup        0xE97
#define SPAgvcup        0xEA9
#define SPAclap         0xEB5
#define SPAstansk       0xECB
#define SPAcrosscheck   0xED7
#define SPAboardback    0xF0F
#define SPAboardfront   0xF55
#define SPAboardright   0xF9B
#define SPAboardleft    0xFE1
#define SPAbenchcheckr  0x1027
#define SPAbenchcheckl  0x1055
#define SPArefpenshot   0x1083
#define SPAgoaliepoke   0x1095
#define SPAgoalieknee   0x10CD
#define SPAgokneehold   0x1135
#define SPAgofallback   0x119D
#define SPAgofallglove  0x11D5
#define SPAgofallstick  0x121D
#define SPAfakeshotf    0x1265
#define SPAfakeshotb    0x12DD
#define SPAfakeonetimef 0x1355
#define SPAfakeonetimeb 0x138D
#define SPAblockleft    0x13C5
#define SPAblockright   0x141D
#define SPAblockfront   0x1475
#define SPAblockknee    0x14AD
#define SPArefelbow     0x14E5
#define SPArefhistick   0x14F9

/* player structure flag bits */
#define pfrev           0x10    /* pflags bit 4: skating backwards */
#define pfna            0x02    /* pflags bit 1: start the next assignment */
#define pfalock         0x20    /* pflags bit 5: animation lock */
#define pfteam          0x40    /* pflags bit 6: 0 home, 1 visitors */
#define pfjoy           0x08    /* pflags bit 3: player under joystick control */
#define pfgoal          0x80    /* pflags bit 7: goal to shoot at, 0 = bottom, 1 = top */
#define pf2aip          0x02    /* pflags2 bit 1: animation in progress */
#define tmflcm          0x02    /* tmflags bit 1: line change mode is on for the team */
#define pf2lcm          0x08    /* pflags2 bit 3: line change mode, keeps the joystick */

#define sfwrap          0x10    /* sflags bit 4: the replay buffer has wrapped */
#define sfpz            0x01    /* sflags bit 0: pause mode */
#define REPLAYSIZE      0x9600  /* replay buffer bytes, 80h per frame */

#define SCref           16      /* SCnum of the referee's sort object */

/* assignment numbers (asstab index, asslist entries) */
#define ASSgoalietopuck 0x0F    /* assgoalietopuck */
#define ASSbenchwait    0x29    /* assbenchwait */
#define ASSpuckfaceoff  0x1B    /* puckfaceoff: the puck waits for the faceoff */

/* byte views of the player word temp2 that skateto uses */
#define TEMP2_DIR(p)    (((signed char *)&(p)->temp2)[0])   /* low byte: skate direction for doplayeracc */
#define TEMP2_TICKS(p)  (((signed char *)&(p)->temp2)[1])   /* high byte: re-aim countdown, 12 ticks */

/* the attribute word: attrlo (54h) is its low byte, attribute (55h) the high byte 68k btst reads */
#define ATTRWORD(p)     (*(short *)&(p)->attrlo)

/* tmpdst values (per roster player): -2 bench, -1 on the ice, 0+ penalty box time */
#define PDbench         (-2)
#define PDice           (-1)
#define ENERGYMAX       0x1000  /* tmpde: full energy */

/* game mode bits */
#define gmclock         0x01    /* gmode bit 0: game clock stopped (the faceoff drop clears it) */
#define gmdir           0x02    /* gmode bit 1: 0 = home team goes up */
#define gmpendel        0x08    /* gmode bit 3: delayed penalty has been called */
#define gmhl            0x10    /* gmode bit 4: highlight mode */

#endif
