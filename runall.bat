@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ============================================
echo  Pulse Market - Meena Bazar run all
echo ============================================

if not exist ".env" (
    echo [WARN] .env not found. Copy .env.example to .env and set MEENA_BEARER_TOKEN first.
    echo        Falling back to .env.example values.
    set "ENV_FILE=.env.example"
) else (
    set "ENV_FILE=.env"
)

for /f "usebackq eol=# tokens=1,* delims==" %%A in ("%ENV_FILE%") do (
    if not "%%A"=="" set "%%A=%%B"
)

if "%MEENA_BEARER_TOKEN%"=="" (
    echo [INFO] MEENA_BEARER_TOKEN is empty. Running as guest.
)
if "%MEENA_BEARER_TOKEN%"=="replace-with-a-fresh-authorized-token" (
    echo [INFO] MEENA_BEARER_TOKEN is placeholder. Running as guest.
    set "MEENA_BEARER_TOKEN="
)

echo [1/3] Setting up Python environment...
if not exist ".venv\Scripts\python.exe" (
    python -m venv .venv || exit /b 1
)
call ".venv\Scripts\activate.bat"

echo [2/3] Installing dependencies...
python -m pip install --upgrade pip >nul
pip install -r requirements.txt || exit /b 1

echo [3/3] Running scraper...
python scrape.py || exit /b 1

echo.
echo ============================================
echo  Scrape complete. Serving site at:
echo    http://localhost:8080
echo  Press Ctrl+C to stop.
echo ============================================
python -m http.server 8080
