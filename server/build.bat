@echo off
REM Build Remote Mouse Server for Windows
REM Run this on Windows PC

echo ========================================
echo Building Remote Mouse Server...
echo ========================================
echo.

REM Install dependencies
echo [1/3] Installing dependencies...
pip install -r requirements.txt
echo.

REM Build EXE with PyInstaller
echo [2/3] Building EXE with PyInstaller...
pyinstaller --onefile --noconsole --icon=icon.ico --name RemoteMouseServer main.py
if errorlevel 1 (
    echo ERROR: PyInstaller build failed!
    pause
    exit /b 1
)
echo.

REM Check if Inno Setup is installed
echo [3/3] Creating installer...
set INNO_PATH=
if exist "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" (
    set INNO_PATH=C:\Program Files (x86)\Inno Setup 6\ISCC.exe
) else if exist "C:\Program Files\Inno Setup 6\ISCC.exe" (
    set INNO_PATH=C:\Program Files\Inno Setup 6\ISCC.exe
)

if defined INNO_PATH (
    echo Building installer with Inno Setup...
    "%INNO_PATH%" installer.iss
    if errorlevel 1 (
        echo WARNING: Installer build failed. EXE is still available.
    ) else (
        echo.
        echo ========================================
        echo BUILD COMPLETE!
        echo ========================================
        echo.
        echo Installer: installer_output\RemoteMouseServer_Setup.exe
        echo Standalone EXE: dist\RemoteMouseServer.exe
        echo.
    )
) else (
    echo.
    echo ========================================
    echo BUILD COMPLETE (EXE only)
    echo ========================================
    echo.
    echo Standalone EXE: dist\RemoteMouseServer.exe
    echo.
    echo To create an installer:
    echo 1. Download Inno Setup from: https://jrsoftware.org/isdl.php
    echo 2. Install Inno Setup
    echo 3. Run this script again
    echo.
)

pause
