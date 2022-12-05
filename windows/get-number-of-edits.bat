@echo off
setlocal EnableDelayedExpansion

rem // NB! Place this script into a root folder of your project, which is under GIT control

rem // Checkout the master branch
git checkout master

rem // Get a list of all the files in the repository
set files=

set i=0
for /f "tokens=*" %%f in ('git ls-tree --full-tree -r --name-only HEAD') do (
  set /a i+=1
  set files[!i!]=%%f
)
set last_index=%i%

rem // Calculate a number of edits (additions and deletions) for each file
set lines=

rem // A git command returns lines like '3       1       .gitignore'
for /l %%i in (1,1,%last_index%) do (
  set edits=
  for /f "tokens=1, 2" %%a in ('git log --numstat --pretty^="format:" !files[%%i]!') do (
    set /a edits[%%i]+=%%a + %%b
  )
  set lines[%%i]=!edits[%%i]! !files[%%i]! 
)

rem // Write array into a file
for /l %%i in (1,1,%last_index%) do (
  @echo !lines[%%i]! >> number_of_edits.txt
)

set "file=number_of_edits.txt"
>"%file%.new1" (
  for /f "usebackq tokens=1* delims= " %%A in ("%file%") do (
    set "n=000000000000000%%A"
    set "str=%%B"
    setlocal enableDelayedExpansion
    echo !n:~-15! - !str!
    endlocal
  )
)
>"%file%.new2" sort /r "%file%.new1"
>"%file%" (
  for /f "usebackq tokens=* delims=0" %%A in ("%file%.new2") do echo %%A
)
del "%file%.new?"