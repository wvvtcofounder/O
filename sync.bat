@echo off
cd /d "P:\My Drive\!@!\$\\Projects\O"

:: Purge desktop.ini
for /r %%f in (desktop.ini Desktop.ini) do if exist "%%f" del "%%f" 2>nul
git rm --cached -r --ignore-unmatch **/desktop.ini desktop.ini >nul 2>&1

:: Pull
git fetch origin main --quiet 2>nul
git merge origin/main --no-edit --quiet 2>nul

:: Stage, strip desktop.ini again, commit, push
git add -A
git rm --cached --ignore-unmatch **/desktop.ini desktop.ini >nul 2>&1
git diff --cached --quiet && (
    echo Already in sync
    goto :eof
)
for /f "tokens=1-3 delims=/ " %%a in ('date /t') do set d=%%c-%%a-%%b
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set t=%%a%%b
git commit -m "sync: %d%_%t%"
git push origin main --quiet
echo Synced
