/* rexx unit test framework
   concatenate these files:
   t1.rexx test-script t2.rexx rexx-file-to-test t3.rexx > t.rexx
   then execute t.rexx
   this file is t3.rexx
*/

/* functions for the test framework */

init:
  checkNumber = 0
  count = 0
  mockPresented = 0
  mockedProcedure. = ''
  mockedProcedures = ''
  mockedProcedureCommands. = ''
  mockedProcedureNumber = 0
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

mock:
  parse arg procedureName, replaceCommands
  
  upper procedureName
  mockedProcedures = mockedProcedures' 'procedureName
  mockedProcedureNumber = mockedProcedureNumber + 1
  mockedProcedure.mockedProcedureNumber = procedureName
  mockedProcedureCommands.mockedProcedureNumber = replaceCommands
  mockPresented = 1
return ''

check:
  parse arg description, procedureCall, variableName, operation, expectedValue

  checkNumber = checkNumber + 1

  if mockPresented = 1 then do
    call readProgramSource
    call removeMockAndCheckFromSource
    call findAndReplaceMockedFunctions
    call writeNewProgramSource
    interpret "call '"newProgramSource"'"
    mockPresented = 0
    mockedProcedures = ''
    return ''
  end

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

readProgramSource:
  programSource = 't.rexx'
  if stream(programSource, 'C', 'QUERY EXISTS') ^= '' then do
    rc = stream(programSource, 'C', 'open read')
    if rc = 'READY:' then do
      ix = 0
      do while chars(programSource) > 0
        sourceLine = linein(programSource)
        ix = ix + 1
        sourceLine.ix = sourceLine
      end
      sourceLine.0 = ix
    end
    else do
      say 'Error opening programSource:' programSource'. Rc='rc' - Exiting'
      exit
    end
    rc = stream(programSource, 'C', 'close')
  end
  else do
    say 'programSource:' programSource 'does not exist - exiting.'
    exit
  end
return

removeMockAndCheckFromSource:
  iy = 0
  do ix = 1 to sourceLine.0
    upperSourceLine = strip(sourceLine.ix)
    upper upperSourceLine
    select
      when left(upperSourceLine,8) = 'CONTEXT(' then do
        iy = iy + 1
        outputSourceLine.iy = sourceLine.ix
        do while right(sourceLine.ix, 1) = ','
          ix = ix + 1
          iy = iy + 1
          outputSourceLine.iy = sourceLine.ix
        end
        iy = iy + 1
        parse value pickCheckNumber(checkNumber) with iz outputSourceLine.iy
        do while right(strip(outputSourceLine.iy,'T'),1) = ','
          iz = iz + 1
          iy = iy + 1
          outputSourceLine.iy = sourceLine.iz
        end
      end
      when left(upperSourceLine,5) = 'MOCK(' |,
           left(upperSourceLine,6) = 'CHECK(' then do
        do while right(strip(sourceLine.ix,'T'), 1) = ','
          ix = ix + 1
        end
      end
      otherwise do
        iy = iy + 1
        outputSourceLine.iy = sourceLine.ix
      end
    end
  end
  outputSourceLine.0 = iy
return

pickCheckNumber: procedure expose sourceLine.
  arg checknumber

  foundCheckNumber = 0
  returnLine = ''

  do ix = 0 to sourceline.0
    upperSourceLine = strip(sourceLine.ix)
    upper upperSourceLine
    if left(upperSourceLine,6) = 'CHECK(' then do
      foundCheckNumber = foundCheckNumber + 1
      if foundCheckNumber = checkNumber then do
        return ix sourceLine.ix
      end
    end
  end
return ''

findAndReplaceMockedFunctions:
  iy = 0
  do ix = 1 to outputSourceline.0
    upperSourceLine = strip(outputSourceline.ix)
    upper upperSourceLine
    calledProcedureName = findProcedureName(upperSourceLine)
    if calledProcedureName ^= '' then do
      mockedProcedureNumber = wordpos(calledProcedureName,mockedProcedures)
      if mockedProcedureNumber > 0 then do
        iy = iy + 1
        blanksInFront = length(outputSourceline.ix) - length(strip(outputSourceline.ix, 'L'))
        newOutputSourceLine.iy = left('', blanksInFront, ' ')'/*'strip(outputSourceline.ix)'*/'
        parse var mockedProcedureCommands.mockedProcedureNumber sourceLine';'rest
        iy = iy + 1
        newOutputSourceLine.iy = left('', blanksInFront, ' ')||strip(sourceLine)
        do while length(rest) > 0
          parse var rest sourceLine';'rest
          iy = iy + 1
          newOutputSourceLine.iy = left('', blanksInFront, ' ')||strip(sourceLine)
        end
      end
      else do
        iy = iy + 1
        newOutputSourceLine.iy = outputSourceLine.ix
      end
    end
    else do
      iy = iy + 1
      newOutputSourceLine.iy = outputSourceLine.ix
    end
  end
  newOutputSourceLine.0 = iy
return

findProcedureName: procedure
  arg sourceLine

  procedureName = ''

  if left(sourceLine,5) = 'CALL ' then
    procedureName = subword(sourceLine,2,1)
  else do
    parse var sourceLine token1'='token2
    leftBraketPos = pos('(', token2)
    rightBraketPos = pos(')', token2)
    
    if token2 ^= '' & leftBraketPos > 0 & rightBraketPos > 0 & leftBraketPos < rightBraketPos then
      procedureName = left(token2,leftBraketPos-1)
  end
return strip(procedureName)

writeNewProgramSource:
  newProgramSource = 'tm'checkNumber'.rexx'
  rc = stream(newProgramSource, 'C', 'open write replace')
  do ix = 1 to newOutputSourceLine.0
    rc = lineout(newProgramSource,newOutputSourceLine.ix)
  end
  rc = stream(newProgramSource, 'C', close)
return

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