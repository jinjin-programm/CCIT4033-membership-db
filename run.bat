@echo off
REM ============================================================
REM Membership System — Windows Batch Launcher
REM ============================================================
title Membership Database System

:MENU
cls
echo ================================================
echo    Membership Database System
echo ================================================
echo.
echo  [1] Initialize Database (create/reset)
echo  [2] Open Interactive SQLite Shell
echo  [3] Run Sample Queries
echo  [4] View Reports (via Views)
echo  [5] Check Database Schema
echo  [6] Exit
echo.
set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto INIT
if "%choice%"=="2" goto SHELL
if "%choice%"=="3" goto QUERIES
if "%choice%"=="4" goto REPORTS
if "%choice%"=="5" goto SCHEMA
if "%choice%"=="6" goto END
echo Invalid choice. Please try again.
pause
goto MENU

:INIT
echo.
echo Initializing database...
if exist membership.db (
    echo WARNING: This will delete the existing database.
    set /p confirm="Are you sure? (y/n): "
    if /i not "%confirm%"=="y" goto MENU
    del membership.db
)
sqlite3 membership.db < init_database.sql
if %errorlevel% equ 0 (
    echo.
    echo Database initialized successfully!
) else (
    echo.
    echo ERROR: Failed to initialize database.
    echo Make sure sqlite3 is installed and in your PATH.
)
pause
goto MENU

:SHELL
echo.
echo Opening interactive SQLite shell...
echo Type '.help' for commands, '.quit' to exit.
echo.
sqlite3 membership.db
goto MENU

:QUERIES
echo.
echo Running sample queries...
echo.
sqlite3 -header -column membership.db < sample_queries.sql
pause
goto MENU

:REPORTS
cls
echo ================================================
echo    Reports Menu
echo ================================================
echo.
echo  [1] Member List Report
echo  [2] Membership Status Report
echo  [3] Payment Transaction Report
echo  [4] Sports Event Schedule Report
echo  [5] Event Registration Summary Report
echo  [6] Back to Main Menu
echo.
set /p rchoice="Enter your choice (1-6): "

if "%rchoice%"=="1" goto RPT_MEMBER
if "%rchoice%"=="2" goto RPT_STATUS
if "%rchoice%"=="3" goto RPT_PAYMENT
if "%rchoice%"=="4" goto RPT_EVENT
if "%rchoice%"=="5" goto RPT_REGISTRATION
if "%rchoice%"=="6" goto MENU
echo Invalid choice.
pause
goto REPORTS

:RPT_MEMBER
echo.
echo === Member List Report ===
sqlite3 -header -column membership.db "SELECT * FROM vw_MemberList;"
pause
goto REPORTS

:RPT_STATUS
echo.
echo === Membership Status Report ===
sqlite3 -header -column membership.db "SELECT * FROM vw_MembershipStatus;"
pause
goto REPORTS

:RPT_PAYMENT
echo.
echo === Payment Transaction Report ===
sqlite3 -header -column membership.db "SELECT * FROM vw_PaymentReport;"
pause
goto REPORTS

:RPT_EVENT
echo.
echo === Sports Event Schedule Report ===
sqlite3 -header -column membership.db "SELECT * FROM vw_EventList;"
pause
goto REPORTS

:RPT_REGISTRATION
echo.
echo === Event Registration Summary Report ===
sqlite3 -header -column membership.db "SELECT * FROM vw_EventRegistrationReport;"
pause
goto REPORTS

:SCHEMA
echo.
echo === Database Schema ===
sqlite3 membership.db ".schema"
pause
goto MENU

:END
echo.
echo Goodbye!
exit /b
