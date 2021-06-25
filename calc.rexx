/* a rexx application to demonstrate the unit test framework */

calc:
  parse arg val1, op, val2
  if op == '+' then 
    return val1 + val2
  if op == '-' then 
    return val1 - val2
  if op == '*' then 
    return val1 * val2
  if op == '/' then 
    return val1 / val2
return

calcWithoutAnyReturn:
  parse arg val1, op, val2
  if op == '+' then 
    calcResult = val1 + val2
  if op == '-' then 
    calcResult = val1 - val2
  if op == '*' then 
    calcResult = val1 * val2
  if op == '/' then 
    calcResult = val1 / val2
return

