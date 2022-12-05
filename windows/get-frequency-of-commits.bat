@echo off
setlocal EnableDelayedExpansion

rem // NB! Place this script into a root folder of your project, which is under GIT control

rem // Checkout the master branch
git checkout master

rem // Get a list of all the files in the repository
set "files="

set "i=0"
for /f "tokens=*" %%f in ('git ls-tree --full-tree -r --name-only HEAD') do (
  set /a "i+=1"
  set "files[!i!]=%%f"
)
set last_index=%i%

rem // Calculate a frequency of edits for each file for the indicated period of time
rem // i.e. calculate number of commits for the file
set "lines="

rem // A git command returns lines like '<commit_hash> <commit_message>' for each file
for /l %%i in (1,1,%last_index%) do (
  set /a "commits=0"
  rem // Change --since to get frequency for the required period of time
  for /f "tokens=*" %%a in ('git log --follow --oneline --since="3 years ago"  !files[%%i]!') do (
    set /a "commits+=1"
  )
  set "lines[%%i]=!commits! !files[%%i]!" 
)

rem // Write array into a file
for /l %%i in (1,1,%last_index%) do (
  echo !lines[%%i]! >> "number_of_commits.txt"
)

rem // Sort by number of commits
set "file=number_of_commits.txt"
>"%file%.new1" (
  for /f "tokens=1* delims= " %%a in (%file%) do (
    set "n=000000000000000%%a"
    set "str=%%b"
    echo !n:~-15! - !str!
  )
)
>"%file%.new2" sort /r "%file%.new1"
>"%file%" (
  for /f "tokens=* delims=0" %%a in (%file%.new2) do echo %%a
)
del "%file%.new?"