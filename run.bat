@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

:MENU
echo.
echo ============================================
echo  Pulse Market - Meena Bazar
echo ============================================
echo  [1] Scrape data (update catalog/history)
echo  [2] Open dashboard (serve + launch browser)
echo  [3] Run all (scrape, then open dashboard)
echo  [4] Exit
echo.
set "choice="
set /p choice=Select an option (1-4): 

if "%choice%"=="1" goto SCRAPE
if "%choice%"=="2" goto DASH
if "%choice%"=="3" goto ALL
if "%choice%"=="4" exit /b 0
echo Invalid choice, try again.
goto MENU

:SCRAPE
echo.
echo [Scrape] Setting up environment and running scraper...
if not exist ".venv\Scripts\python.exe" (
    python -m venv .venv || exit /b 1
)
call ".venv\Scripts\activate.bat"
python -m pip install --upgrade pip >nul
pip install -r requirements.txt || exit /b 1
python scrape.py || exit /b 1
echo.
echo [Scrape] Complete.
goto MENU

:DASH
echo.
echo [Dashboard] Serving site at http://localhost:8080
start "" http://localhost:8080
python -m http.server 8080
goto MENU

:ALL
echo.
echo [Run all] Scraping first, then opening the dashboard...
if not exist ".venv\Scripts\python.exe" (
    python -m venv .venv || exit /b 1
)
call ".venv\Scripts\activate.bat"
python -m pip install --upgrade pip >nul
pip install -r requirements.txt || exit /b 1
python scrape.py || exit /b 1
echo.
echo [Run all] Opening dashboard at http://localhost:8080
start "" http://localhost:8080
python -m http.server 8080