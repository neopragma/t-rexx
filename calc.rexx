/* a rexx application to demonstrate the unit test framework */

calc:
  parse arg val1, op, val2
  if op == '+' then 
    calcResult = val1 + val2
  if op == '-' then 
    calcResult = val1 - val2
  if op == '*' then 
    calcResult = val1 * val2
  if op == '/' then 
    calcResult = val1 / val2
  call sayCalcResult2 calcResult
return calcResult

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

sayCalcResult2: procedure
  arg lineToPrint
  say 'sayCalcResult2 printing:' lineToPrint
return

sayCalcResultWithReturn: procedure
  arg lineToPrint
  say 'sayCalcResultWithReturn printing:' lineToPrint
return 8

