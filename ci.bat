@echo off
:: CI.BAT script for Windows
:: Equivalent to the provided ci.sh

:: 1) mkdir build
:: Use 'if not exist' to mimic 'mkdir -p'
if not exist "build" mkdir "build"
if %ERRORLEVEL% neq 0 (
    echo "Failed to create build directory."
    exit /b %ERRORLEVEL%
)

:: 2) cd build
cd build
if %ERRORLEVEL% neq 0 (
    echo "Failed to change to build directory."
    exit /b %ERRORLEVEL%
)

:: Get number of processors for parallel build
:: Windows equivalent of nproc/sysctl is %NUMBER_OF_PROCESSORS%
set "NPROCS=%NUMBER_OF_PROCESSORS%"
if not defined NPROCS set "NPROCS=2"

:: 3) run cmake ..
echo "Running: cmake .."
cmake ..
if %ERRORLEVEL% neq 0 (
    echo "CMake configuration failed."
    exit /b %ERRORLEVEL%
)

:: 4) cmake --build .
:: On Windows with MSVC (the default), we pass /m:%NPROCS% to MSBuild
:: for parallel builds. This is the equivalent of -j%NPROCS% on Makefiles.
echo "Building (parallel jobs: %NPROCS%)"
cmake --build . --config Release -- /m:%NPROCS%
if %ERRORLEVEL% neq 0 (
    echo "Build failed."
    exit /b %ERRORLEVEL%
)

:: 5) run tests via CTest
:: The -C Release flag is correct for Windows to specify the configuration to test.
echo "Running tests with CTest"
ctest --output-on-failure -C Release
if %ERRORLEVEL% neq 0 (
    echo "Tests failed."
    exit /b %ERRORLEVEL%
)

echo "CI script completed successfully on Windows"
exit /b 0