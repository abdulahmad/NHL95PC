/* Create player: rating conversion. */
#include "nhl95.h"

/* RatingToFloat: a stored rating byte r as the displayed rating, (r + 5) * 5, in floating point. */
float RatingToFloat(unsigned char r)
{
    return (r + 5) * 5;
}
