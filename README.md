# t.rexx

Unit testing framework for Rexx.

The test framework comprises three files: t1, t2, and t3. Each contains a piece of the test framework. The code works by concatenating thesse files with a test script and with the Rexx file to be tested, resulting in a single Rexx program. The order of concatenation is:

1. t1 -> variables used by the test framework
1. the file containing the test script
1. t2 -> boilerplate code that displays the results of the tests
1. the file containing the code to be tested
1. t3 -> test framework functions

## Running tests with bash

The bash script ```runt``` performs the concatenation and executes the resulting file. For example, to run the 'calc' example provided in this repo, run ```runt``` as follows:

```shell
./runt calc-check calc
```

## Running tests with JCL

On a zOS system, concatenate the files and run the resulting Rexx program using any mechanism you prefer. For example, you could use ```IKJEFT01``` to run a test script. The JCL might look something like this (from http://documentation.microfocus.com/help/index.jsp?topic=%2Fcom.microfocus.eclipse.infocenter.enterpriseserver.net%2FGUID-64EB1C60-F89C-4C9F-9D55-03B15A2AAB60.html):

```
//REXXTSO JOB 'IKJEFT01 REXX',CLASS=A,MSGCLASS=A
//* 
//CREATE    EXEC  PGM=IEBGENER 
//SYSIN     DD  DUMMY 
//SYSPRINT  DD  SYSOUT=A,HOLD=YES 
//SYSUT2    DD  DSN=&TEMPREX(REXTSO),DISP=(,PASS), 
// SPACE=(CYL,(1,1,1)),UNIT=3390, 
// DCB=(LRECL=80,RECFM=FB,DSORG=PO) 
//SYSUT1    DD  DSN=[t1 file],DISP=SHR
            DD  DSN=[test script file],DISP=SHR
            DD  DSN=[t2 file],DISP=SHR
            DD  DSN=[file to be tested],DISP=SHR
            DD  DSN=[t3 file],DISP=SHR
//RUN       EXEC PGM=IKJEFT01,PARM='REXTSO' 
//SYSEXEC   DD DSN=&TEMPREX,DISP=(SHR,PASS) 
//SYSTSPRT  DD SYSOUT=A,HOLD=YES 
//SYSTSIN   DD DUMMY
// 
```

