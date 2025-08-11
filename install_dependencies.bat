@echo off
setlocal enabledelayedexpansion

echo ========================================
echo    OptiScaler Dependency Installer
echo ========================================
echo.
echo This script will download and install all required dependencies
echo for building OptiScaler on Windows.
echo.

REM Check if git is available
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Git is not installed or not in PATH!
    echo Please install Git from: https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

REM Check if we're in the right directory
if not exist "OptiScaler.sln" (
    echo ERROR: Please run this script from the OptiScaler root directory!
    echo.
    pause
    exit /b 1
)

echo Checking current dependency status...
echo.

REM Initialize git submodules if not already done
if not exist "external\spdlog\.git" (
    echo Initializing git submodules...
    git submodule init
    if %errorlevel% neq 0 (
        echo ERROR: Failed to initialize git submodules!
        pause
        exit /b 1
    )
)

echo.
echo Downloading and updating dependencies...
echo.

REM Update all submodules
git submodule update --init --recursive
if %errorlevel% neq 0 (
    echo ERROR: Failed to update git submodules!
    pause
    exit /b 1
)

echo.
echo Checking for additional required dependencies...
echo.

REM Check if external directories exist and have content
set missingDeps=0

if not exist "external\spdlog\include\spdlog\spdlog.h" (
    echo [MISSING] spdlog headers
    set missingDeps=1
) else (
    echo [OK] spdlog
)

if not exist "external\simpleini\simpleini\SimpleIni.h" (
    echo [MISSING] simpleini headers
    set missingDeps=1
) else (
    echo [OK] simpleini
)

if not exist "external\unordered_dense\include\ankerl\unordered_dense.hpp" (
    echo [MISSING] unordered_dense headers
    set missingDeps=1
) else (
    echo [OK] unordered_dense
)

if not exist "external\vulkan\include\vulkan\vulkan.h" (
    echo [MISSING] Vulkan headers
    set missingDeps=1
) else (
    echo [OK] Vulkan headers
)

if not exist "external\FidelityFX-SDK\FidelityFX\include\FidelityFX.h" (
    echo [MISSING] FidelityFX SDK
    set missingDeps=1
) else (
    echo [OK] FidelityFX SDK
)

if not exist "external\magic_enum\include\magic_enum.hpp" (
    echo [MISSING] magic_enum
    set missingDeps=1
) else (
    echo [OK] magic_enum
)

if not exist "external\xess\inc\xess\xess.h" (
    echo [MISSING] Intel XeSS SDK
    set missingDeps=1
) else (
    echo [OK] Intel XeSS SDK
)

echo.

REM Check for Visual Studio build tools
echo Checking for Visual Studio build tools...
where cl >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Visual Studio build tools not found in PATH
    echo You may need to run this from a Visual Studio Developer Command Prompt
    echo or install Visual Studio Build Tools
    echo.
    set missingDeps=1
) else (
    echo [OK] Visual Studio build tools found
)

echo.

if %missingDeps% equ 0 (
    echo ========================================
    echo    All dependencies are ready!
    echo ========================================
    echo.
    echo You can now build OptiScaler using:
    echo   - Visual Studio 2022 (open OptiScaler.sln)
    echo   - MSBuild from command line
    echo   - Visual Studio Build Tools
    echo.
    echo Note: Some dependencies like NVIDIA DLSS SDK may need
    echo manual installation if you plan to use DLSS features.
    echo.
) else (
    echo ========================================
    echo    Some dependencies are missing!
    echo ========================================
    echo.
    echo Please check the missing dependencies above.
    echo You may need to:
    echo   1. Run this script again
    echo   2. Install Visual Studio Build Tools
    echo   3. Manually download missing SDKs
    echo.
)

echo Press any key to exit...
pause >nul