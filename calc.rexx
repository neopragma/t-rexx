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
  call sayCalcResult calcResult
  rc = sayCalcResultWithReturn(calcResult)
return

sayCalcResult: procedure
  arg lineToPrint
  say 'sayCalcResult printing:' lineToPrint
return

sayCalcResultWithReturn: procedure
  arg lineToPrint
  say 'sayCalcResultWithReturn printing:' lineToPrint
return 8

