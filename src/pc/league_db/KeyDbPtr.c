/* Database save: key database pointer. */
#include "nhl95.h"

/* KeyDbPtr: address of byte offset ofs in the key database. */
unsigned char *KeyDbPtr(int ofs)
{
    return keydb + ofs;
}

/* SeasonDbPtr: pointer ofs bytes into the seasondb buffer. */
unsigned char *SeasonDbPtr(int ofs)
{
    return seasondb + ofs;
}

/* SeasonDbPtr2: the same as SeasonDbPtr (Watcom reduced it to a jump into it after the __CHK push). */
unsigned char *SeasonDbPtr2(int ofs)
{
    return seasondb + ofs;
}

/* CareerDbPtr: pointer ofs bytes into the careerdb buffer. */
unsigned char *CareerDbPtr(int ofs)
{
    return careerdb + ofs;
}

/* CareerDbPtr2: the same as CareerDbPtr (Watcom reduced it to a jump into it after the __CHK push). */
unsigned char *CareerDbPtr2(int ofs)
{
    return careerdb + ofs;
}

/* AttDbPtr: pointer ofs bytes into the attdb buffer. */
unsigned char *AttDbPtr(int ofs)
{
    return attdb + ofs;
}

/* AttDbPtr2: the same as AttDbPtr (Watcom reduced it to a jump into it after the __CHK push). */
unsigned char *AttDbPtr2(int ofs)
{
    return attdb + ofs;
}
