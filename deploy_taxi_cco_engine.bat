@echo off
set "REPO_URL=https://github.com/Aksl-Ushindi/Taxi-cco-engine.git"
set "REPO_DIR=%USERPROFILE%\Desktop\GitHub\Taxi-cco-engine"
set "SOURCE_DIR=C:\Users\Darboux\Desktop\API\taxi cco engine"
set "BR=main"

where git >nul 2>&1 || (echo Git manquant & pause & exit /b 1)

if not exist "%REPO_DIR%\.git" (
  if not exist "%REPO_DIR%" mkdir "%REPO_DIR%"
  git clone "%REPO_URL%" "%REPO_DIR%" || (echo Clone KO & pause & exit /b 1)
)

pushd "%REPO_DIR%"
git checkout "%BR%" 2>nul & git pull origin "%BR%"
popd

REM copie tous les fichiers (garde ce qui existe déjà dans le repo)
robocopy "%SOURCE_DIR%" "%REPO_DIR%" /E /R:1 /W:1 ^
 /XD .git node_modules .next dist build ^
 /XF Thumbs.db desktop.ini .DS_Store >nul

pushd "%REPO_DIR%"
git add -A
git diff --cached --quiet && (echo Rien a pousser & popd & goto :end)
git commit -m "Deploy sync %date% %time%"
git push origin "%BR%"
popd
:end
echo OK
pause
