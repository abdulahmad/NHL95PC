/* nhl95.h - the one header every NHL 95 PC C source includes.
   Order: hand-written types and declarations first, then the generated ones (which skip any name declared in
   protos.h / vars.h). Compiler: Watcom C/C++32 10.0 LA wcc386, default flags (-5r -fpi -zp1, stack checks on, no
   -o). Plain 'char' is UNSIGNED with these flags; write 'signed char' for a byte the asm loads with movsx or the
   -5r 'dword [x-3] / sar 18h' idiom. 8.3 file names only (the compiler runs under DOS). */
#ifndef NHL95_H
#define NHL95_H
#include "types.h"
#include "structs.h"
#include "consts.h"
#include "vars.h"
#include "protos.h"
#include "globals.h"
#include "asmfuncs.h"
#endif
