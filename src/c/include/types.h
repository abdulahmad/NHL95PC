/* types.h - basic types for the NHL 95 PC C sources (wcc386 10.0, flat 32-bit: int = long = pointer = 4 bytes). */
#ifndef TYPES_H
#define TYPES_H
typedef signed char    s8;
typedef unsigned char  u8;
typedef short          s16;
typedef unsigned short u16;
typedef int            s32;
typedef unsigned int   u32;
#define NULL ((void *)0)
/* the integer word (high half) of a 16.16 fixed-point value such as Xpos/Ypos (asm: [reg+Xpos+2]) */
#define HIWORD(x) (((short *)&(x))[1])
/* the high byte of a 16-bit value, signed (asm: movsx ax, byte [reg+Xvel+1]) */
#define HIBYTE(x) (((signed char *)&(x))[1])
/* absolute value as the C code wrote it: compiles to cmp / jge / neg on a fresh load */
#define ABS(v) ((v) < 0 ? -(v) : (v))
#endif
