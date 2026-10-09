/* consts.h - named constants for the NHL 95 PC C sources (values from the asm; Genesis names where they exist). */
#ifndef CONSTS_H
#define CONSTS_H

/* SPAtab animation numbers (PC values; 93G value in the comment) */
#define SPAglide        0x289   /* 93G $50C */
#define SPAstop         0x361   /* 93G $6C6 / $6E6 */
#define SPArefglide     0xA5B   /* referee glide */
#define SPArefstop      0xAEB   /* referee stop */
#define SPArefglidesig  0xB4B   /* referee glide, signalling */
#define SPArefstopsig   0xBDB   /* referee stop, signalling */

/* player structure flag bits */
#define pfrev           0x10    /* pflags bit 4: skating backwards (93G pfrev) */
#define pfna            0x02    /* pflags bit 1: start the next assignment (93G pfna) */
#define pfalock         0x20    /* pflags bit 5: animation lock (93G pfalock) */
#define pfjoy           0x08    /* pflags bit 3: player under joystick control */
#define pf2aip          0x02    /* pflags2 bit 1: animation in progress (93G pf2aip) */

#define SPAsweep        0x589   /* sweep check (93G $B24) */
#define sfwrap          0x10    /* sflags bit 4: the replay buffer has wrapped (94G sfwrap) */
#define REPLAYSIZE      0x9600  /* replay buffer bytes, 80h per frame */

#define SCref           16      /* SCnum of the referee's sort object */

/* game mode bits */
#define gmclock         0x01    /* gmode bit 0: game clock running (93G gmclock) */

#endif
