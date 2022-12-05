@echo off
setlocal EnableDelayedExpansion

rem Checkout the master branch
git checkout master

rem Get a list of all the files in the repository
set files=

set i=0
for /f "tokens=*" %%f in ('git ls-tree --full-tree -r --name-only HEAD') do (
  set /a i+=1
  set files[!i!]=%%f
)

set last_index=%i%

rem Display array elements
rem TO CALCULATE ADDITIONS/DELETES, SEE 
rem https://stackoverflow.com/questions/9933325/is-there-a-way-of-having-git-show-lines-added-lines-changed-and-lines-removed
rem e.g. git log --numstat --oneline src/main/java/app/controllers/ClientController.java

set lines=

for /L %%i in (1,1,%last_index%) do (
  @echo !files[%%i]! >> tmp.txt
  
  set commits=
  
  for /f "tokens=1, 2" %%a in ('git log --numstat --pretty^="format:" !files[%%i]!') do (
    set /a commits[%%i]+=%%a + %%b
  )

  set lines[%%i]=!commits[%%i]! 
)

for /L %%i in (1,1,%last_index%) do (
  @echo !lines[%%i]! >> tmp3.txt
)

sort /R tmp3.txt
