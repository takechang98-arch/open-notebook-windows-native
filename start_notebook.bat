@echo off
chcp 65001 >nul
title Open Notebook Launcher

echo ===================================================
echo [1/5] 既存の残存プロセスを完全にクリーンアップ中...
echo ===================================================
taskkill /F /IM surreal.exe >nul 2>&1
taskkill /F /IM python.exe >nul 2>&1
taskkill /F /IM node.exe >nul 2>&1

for /f "tokens=5" %%a in ('netstat -aon ^| findstr :3000 ^| findstr LISTENING') do taskkill /F /PID %%a >nul 2>&1
timeout /t 2 /nobreak >nul

echo.
echo ===================================================
echo [2/5] SurrealDB を起動中... (Port 8000)
echo ===================================================
cd /d "C:\Python\open-notebook"

:: メモリ上ではなくファイル保存（rocksdb）にしてDB構造を維持する
start "SurrealDB" /min cmd /k "surreal start --user root --pass root rocksdb:surreal.db --bind 127.0.0.1:8000"

echo DBの完全起動を待機中 (3秒)...
timeout /t 3 /nobreak >nul

echo.
echo ===================================================
echo [3/5] Python API (FastAPI) を起動中... (Port 5055)
echo ===================================================
set SURREAL_USER=root
set SURREAL_PASS=root
set SURREAL_ADDRESS=127.0.0.1
set SURREAL_PORT=8000
set SURREAL_NAMESPACE=open_notebook
set SURREAL_DATABASE=open_notebook

start "Python API" cmd /k ".venv\Scripts\python.exe -m uvicorn api.main:app --host 127.0.0.1 --port 5055"

echo APIの初期化を待機中 (5秒)...
timeout /t 5 /nobreak >nul

echo.
echo ===================================================
echo [4/5] Background Worker (Command Service) を起動中...
echo ===================================================
start "Background Worker" cmd /k "cd /d C:\Python\open-notebook && call .venv\Scripts\activate.bat && set SURREAL_USER=root&& set SURREAL_PASS=root&& set SURREAL_ADDRESS=127.0.0.1&& set SURREAL_PORT=8000&& set SURREAL_NAMESPACE=open_notebook&& set SURREAL_DATABASE=open_notebook&& surreal-commands-worker"

timeout /t 2 /nobreak >nul

echo.
echo ===================================================
echo [5/5] Next.js フロントエンドを起動中... (Port 3000)
echo ===================================================
cd /d "C:\Python\open-notebook\frontend"
start "Next.js Frontend" cmd /k "npm run dev"

echo.
echo ===================================================
echo すべてのサービスを起動しました！
echo ===================================================
pause