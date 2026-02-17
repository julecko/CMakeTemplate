@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM Defaults

set "PROJECT_NAME=ProjectName"
set "BUILD_TYPE=Release"
set "RUN_EXEC=0"
set "RUN_ARGS="


REM Argument parsing

:parse_args
if "%~1"=="" goto build

if /I "%~1"=="-d" (
    set "BUILD_TYPE=Debug"
    shift
    goto parse_args
)

if /I "%~1"=="-r" (
    set "RUN_EXEC=1"
    shift
    goto collect_run_args
)

REM Unknown argument
echo Unknown argument: %~1
goto usage

REM Collect remaining args for runtime
:collect_run_args

if "%~1"=="" goto build

if defined RUN_ARGS (
    set "RUN_ARGS=!RUN_ARGS! %~1"
) else (
    set "RUN_ARGS=%~1"
)
shift
goto collect_run_args


REM Build

:build

set "BUILD_DIR=build"

if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
echo.
echo Configuring (%BUILD_TYPE%)...
cmake -S . -B "%BUILD_DIR%" ^
  -DCMAKE_BUILD_TYPE=%BUILD_TYPE%

if errorlevel 1 (
    echo.
    echo [ERROR] CMake configuration failed.
    exit /b 1
)

echo.
echo Building...

cmake --build "%BUILD_DIR%" --config %BUILD_TYPE%

if errorlevel 1 (
    echo.
    echo [ERROR] Build failed.
    exit /b 1
)


REM Run

if "%RUN_EXEC%"=="1" (
    echo.
    echo Running "%BUILD_DIR%\%BUILD_TYPE%\%PROJECT_NAME%.exe" %RUN_ARGS%
    "%BUILD_DIR%\%BUILD_TYPE%\%PROJECT_NAME%.exe" %RUN_ARGS%
)

endlocal
exit /b 0


REM --------------------------
:usage
echo.
echo Usage: %~nx0 [-d] [-r [args]]
echo.
echo    -d           Build in Debug mode (default is Release)
echo    -r [args]    Run the executable after build with optional arguments
echo.
exit /b 1
