@echo off
chcp 65001 >nul
title Open Notebook Launcher

:: Set current directory to the batch file's location
cd /d "%~dp0"

echo ===================================================
echo [1/5] Cleaning up existing background processes...
echo ===================================================
taskkill /F /IM surreal.exe >nul 2>&1
taskkill /F /IM python.exe >nul 2>&1
taskkill /F /IM node.exe >nul 2>&1

for /f "tokens=5" %%a in ('netstat -aon ^| findstr :3000 ^| findstr LISTENING') do taskkill /F /PID %%a >nul 2>&1
timeout /t 2 /nobreak >nul

echo.
echo ===================================================
echo [2/5] Starting SurrealDB... (Port 8000)
echo ===================================================
:: Use persistent file storage (rocksdb) instead of in-memory to preserve DB schema/data
start "SurrealDB" /min cmd /k "surreal start --user root --pass root rocksdb:surreal.db --bind 127.0.0.1:8000"

echo Waiting for SurrealDB to initialize (3s)...
timeout /t 3 /nobreak >nul

echo.
echo ===================================================
echo [3/5] Starting Python API (FastAPI)... (Port 5055)
echo ===================================================
set SURREAL_USER=root
set SURREAL_PASS=root
set SURREAL_ADDRESS=127.0.0.1
set SURREAL_PORT=8000
set SURREAL_NAMESPACE=open_notebook
set SURREAL_DATABASE=open_notebook

start "Python API" cmd /k ".venv\Scripts\python.exe -m uvicorn api.main:app --host 127.0.0.1 --port 5055"

echo Waiting for API to initialize (5s)...
timeout /t 5 /nobreak >nul

echo.
echo ===================================================
echo [4/5] Starting Background Worker (Command Service)...
echo ===================================================
start "Background Worker" cmd /k "cd /d "%~dp0" && call .venv\Scripts\activate.bat && set SURREAL_USER=root&& set SURREAL_PASS=root&& set SURREAL_ADDRESS=127.0.0.1&& set SURREAL_PORT=8000&& set SURREAL_NAMESPACE=open_notebook&& set SURREAL_DATABASE=open_notebook&& surreal-commands-worker"

timeout /t 2 /nobreak >nul

echo.
echo ===================================================
echo [5/5] Starting Next.js Frontend... (Port 3000)
echo ===================================================
cd /d "%~dp0frontend"
start "Next.js Frontend" cmd /k "npm run dev"

echo.
echo ===================================================
echo All services have been launched successfully!
echo ===================================================
pause