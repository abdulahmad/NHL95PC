/* Database save: key database pointer. */
#include "nhl95.h"

/* KeyDbPtr (6CBB7) - address of byte offset ofs in the key database. */
unsigned char *KeyDbPtr(int ofs)
{
    return keydb + ofs;
}

/* SeasonDbPtr (6CBCC) - pointer ofs bytes into the seasondb buffer. */
unsigned char *SeasonDbPtr(int ofs)
{
    return seasondb + ofs;
}

/* SeasonDbPtr2 (6CBE1) - the same as SeasonDbPtr (Watcom reduced it to a jump into it after the __CHK push). */
unsigned char *SeasonDbPtr2(int ofs)
{
    return seasondb + ofs;
}

/* CareerDbPtr (6CBE8) - pointer ofs bytes into the careerdb buffer. */
unsigned char *CareerDbPtr(int ofs)
{
    return careerdb + ofs;
}

/* CareerDbPtr2 (6CBFD) - the same as CareerDbPtr (Watcom reduced it to a jump into it after the __CHK push). */
unsigned char *CareerDbPtr2(int ofs)
{
    return careerdb + ofs;
}

/* AttDbPtr (6CC04) - pointer ofs bytes into the attdb buffer. */
unsigned char *AttDbPtr(int ofs)
{
    return attdb + ofs;
}

/* AttDbPtr2 (6CC19) - the same as AttDbPtr (Watcom reduced it to a jump into it after the __CHK push). */
unsigned char *AttDbPtr2(int ofs)
{
    return attdb + ofs;
}
