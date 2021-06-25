/* rexx unit test framework
   concatenate these files:
   t1.rexx test-script t2.rexx rexx-file-to-test t3.rexx > t.rexx
   then execute t.rexx
   this file is t1.rexx
*/

call init

/* Test script below *********************************************************/

/*******************************************************************************
 * test script to demonstrate the rexx unit test framework                    
 * Syntax:                                                                    
 *   context('descripttion') is the test suite description                      
 *
 *   check() is the check procedure to check returncodes from a function or 
 *   variables set or changed in a pr   ocedure.
 *   input to check()   
 *      arg1: Description of the test  
 *      arg2: procedure call incl. argum   ents
 *      arg3: variable name to check if    any
 *      arg4: operand like =, <>, >, <, >= or <=
 *      arg5: expected value
 ******************************************************************************/

context('Checking the calc function and calcWithoutAnyReturn procedure')
check( 'Check if variable "op" is set to "to be"', "calc(3, '+', 4)", 'op', 'to be', 'to be'  )
check( 'Check if variable "op" is set to "="', "calc(3, '+', 4)", 'op', '=', '='  )
check( 'Adding 5 and 2', "calc(5,  '+', 2)",, 'to be', 7)
check( 'Subtracting 3 from 10', "calc(10, '-', 3)",, 'to be', 7)
check( 'Multiplying 15 and 2 - must fail',  "calc(15, '*', 2)",, 'to be', 31)
check( 'Dividing 3 into 15 not to be 13', "calc(15, '/', 3)",, 'not to be', 13)
check( 'Dividing 3 into 15 ^= 13', "calc(15, '/', 3)",, '^=', 13)
check( 'Dividing 3 into 15 <> 13', "calc(15, '/', 3)",, '<>', 13)
check( 'Dividing 3 into 15 not to be 5 - must fail', "calc(15, '/', 3)",, 'not to be', 5)
check( 'Dividing 3 into 15 ^= 5 - must fail', "calc(15, '/', 3)",, '^=', 5)
check( 'Dividing 3 into 15 <> 5 - must fail', "calc(15, '/', 3)",, '<>', 5)
check( 'Dividing 15 by 3 > 4', "calc(15, '/', 3)",, '>', 4)
check( 'Dividing 15 by 3 >= 4', "calc(15, '/', 3)",, '>=', 4)
check( 'Dividing 15 by 3 >= 5', "calc(15, '/', 3)",, '>=', 5)
check( 'Dividing 15 by 3 < 6', "calc(15, '/', 3)",, '<', 6)
check( 'Dividing 15 by 3 <= 6', "calc(15, '/', 3)",, '<=', 6)
check( 'Dividing 15 by 3 <= 5', "calc(15, '/', 3)",, '<=', 5)
check( 'Dividing 15 by 3 > 6 - must fail', "calc(15, '/', 3)",, '>', 6)
check( 'Dividing 15 by 3 >= 6 - must fail', "calc(15, '/', 3)",, '>=', 6)
check( 'Dividing 15 by 3 < 6 - must fail', "calc(15, '/', 3)",, '<', 5)
check( 'Dividing 15 by 3 <= 6 - must fail', "calc(15, '/', 3)",, '<=', 4)
check( 'Dividing 15 by 3 = 5', "calcWithoutAnyReturn 15, '/', 3", 'calcResult', '=', 5)
check( 'Dividing 15 by 3 >= 4', "calcWithoutAnyReturn 15, '/', 3", 'calcResult', '>=', 4)
check( 'Dividing 15 by 3 != 4', "calcWithoutAnyReturn 15, '/', 3", 'calcResult', '>=', 4)

/* rexx unit test framework
   concatenate these files:
   t1.rexx test-script t2.rexx rexx-file-to-test t3.rexx > t.rexx
   then execute t.rexx
   this file is t2.rexx
*/

/* display the test results */

say divider
say contextdesc
say spacer

do i = 1 to checkresult.0
  say checkresult.i
end    

say spacer

text = counts()
do i = 1 to text.0
  say text.i
end

say divider

exit

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

/* rexx unit test framework
   concatenate these files:
   t1.rexx test-script t2.rexx rexx-file-to-test t3.rexx > t.rexx
   then execute t.rexx
   this file is t3.rexx
*/

/* functions for the test framework */

init:
  count = 0
  passed = 0
  failed = 0
  contextdesc = ''
  checkresult. = ''
  divider = '----------------------------------------'
  spacer = ' '
return

context:
  parse arg desc
  contextdesc = desc
return ''

check:
  parse arg description, procedureCall, variableName, operation, expectedValue
  count = count + 1
  checkresult.0 = count
  if right(procedureCall,1) = ')' then
    interpret 'returnedValue = 'procedureCall
  else do
    interpret 'call 'procedureCall
    returnedValue = ''
  end
  assertion = expect(returnedValue, variableName, operation, expectedValue)
  checkresult.count = right(count,2) || '. ' || assertion || ' - Test: ' || description
return ''

expect:
  parse arg actual, variableName, op, expected
  if variableName <> '' then 
    actualValue = value(variableName)
  else
    actualValue = actual

  select
    when op == 'to be' | op == '=' then 
      return report(actualValue, op, expected, actualValue == expected)
    when op == 'not to be' | op == '^=' | op == '<>' then 
      return report(actualValue, op, expected, actualValue \== expected)
    when op == 'larger than' | op == '>' then 
      return report(actualValue, op, expected, actualValue > expected)
    when op == 'larger than or equal to' | op == '>=' then 
      return report(actualValue, op, expected, actualValue >= expected)
    when op == 'less than' | op == '<' then 
      return report(actualValue, op, expected, actualValue < expected)
    when op == 'less than or equal to' | op == '<=' then 
      return report(actualValue, op, expected, actualValue <= expected)
    otherwise do
      say 'operand 'op' unknown. Known operands are:'
      say '  to be (=), '
      say '  not to be (^= or <>), '
      say '  larger than (>),'
      say '  larger than or equal to (>=), '
      say '  less than (<) and'
      say '  less than or equal to (<=)'
      say '.......exiting'
      exit
    end
  end
return

report:
  parse arg actual, op, expected, res
  lineout = ''
  select
    when res == 0 then do
      failed = failed + 1
      lineout = '*** FAILED: Expected "' || expected || '" but got "' || actual || '"'
    end
    when res == 1 then do
      passed = passed + 1
      lineout = '    PASSED: Expected "' || expected || '" and got "' || actual || '"'
    end   
  end     
return lineout    

counts:
  text.0 = 3
  text.1 = count ' checks were executed'
  text.2 = passed ' checks passed'
  text.3 = failed ' checks failed'
return text