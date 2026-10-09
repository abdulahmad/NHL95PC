/* Database save: key database pointer. */
#include "nhl95.h"

/* KeyDbPtr (6CBB7) - address of byte offset ofs in the key database. */
unsigned char *KeyDbPtr(int ofs)
{
    return keydb + ofs;
}
