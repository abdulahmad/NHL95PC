/* Menu / dialog callbacks. */
#include "nhl95.h"

/* TradeCancel (3EF27) - trade cancelled: traderesult = -1. */
void TradeCancel(void)
{
    traderesult = -1;
}
