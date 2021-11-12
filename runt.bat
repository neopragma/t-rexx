@echo off
rem ----------------------------------------------------------------------------
rem Script runner for t.rexx
rem
rem %1 -> the test script (rexx)
rem %2 -> the application to test (rexx)
rem
rem This script concatenates the files:
rem t1.rexx + $1 + t2.rexx + $2 + t3.rexx
rem
rem and executes the resulting file.
rem
rem Dave Nicolette
rem Version 0.0.1
rem 03 Apr 2015
rem ----------------------------------------------------------------------------

type t1.rexx %1.rexx t2.rexx %2.rexx t3.rexx > t.rexx
rexx t.rexx
