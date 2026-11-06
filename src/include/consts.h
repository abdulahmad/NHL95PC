/* consts.h - named constants for the NHL 95 PC C sources (values from the asm; Genesis names where they exist). */
#ifndef CONSTS_H
#define CONSTS_H

/* SPAtab animation numbers */
#define SPAglide        0x289
#define SPAstop         0x361
#define SPArefglide     0xA5B   /* referee glide */
#define SPArefstop      0xAEB   /* referee stop */
#define SPArefglidesig  0xB4B   /* referee glide, signalling */
#define SPArefstopsig   0xBDB   /* referee stop, signalling */
#define SPAskate        0x2E9
#define SPAskatewp      0x2A1   /* skating with the puck */
#define SPAglideback    0x529
#define SPAskateback    0x541
#define SPArefskate     0xA73   /* referee skate */
#define SPArefskatesig  0xB63   /* referee skate, signalling */

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

#define SPAgready       0x001   /* goalie ready stance */
#define SPAgskate       0x1F1   /* goalie skate */
#define SPAsweep        0x589   /* sweep check */
#define SPApflip        0x239   /* puck flip */
#define SPAholdchk      0x873   /* hold check */
#define SPAholdchkair   0x639   /* hold check, stick in the air */
/* Shot-block animations: two slides that fall, and two high poses. */
#define SPAblockslide   0x13C5  /* sliding shot block; hand and dive side disagree */
#define SPAblockslide2  0x141D  /* sliding shot block */
#define SPAblockhigh    0x1475  /* high shot block; puck is high or rising fast */
#define SPAblocklow     0x14AD  /* high shot block; puck is low and not rising fast */
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
