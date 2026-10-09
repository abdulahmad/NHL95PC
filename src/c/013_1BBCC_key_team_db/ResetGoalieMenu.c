/* Key / team database: goalie menu. */
#include "nhl95.h"

/* ResetGoalieMenu (1CB7F) - reset the home / away goalie menu items: both goalie entries back to the template text, the
   "none" items to state 2. */
void ResetGoalieMenu(void)
{
    strcpy((char *)mi_HomeGoalie1, (char *)str_GoalieItemTmpl);
    strcpy((char *)mi_HomeGoalie2, (char *)str_GoalieItemTmpl);
    *(char *)mi_HomeGoalieNone = 2;
    strcpy((char *)mi_AwayGoalie1, (char *)str_GoalieItemTmpl);
    strcpy((char *)mi_AwayGoalie2, (char *)str_GoalieItemTmpl);
    *(char *)mi_AwayGoalieNone = 2;
}
