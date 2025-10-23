#!/usr/bin/env bash
# CI script
set -euo pipefail

# 1) mkdir build
mkdir -p build

# 2) cd build
cd build

# detect number of processors for parallel build
if command -v nproc >/dev/null 2>&1; then
  NPROCS=$(nproc)
elif command -v sysctl >/dev/null 2>&1; then
  NPROCS=$(sysctl -n hw.ncpu || echo 2)
else
  NPROCS=2
fi

# identify platform
OS="$(uname -s)"

# 3) run cmake ..
echo "Running: cmake .."
cmake ..

# 4) cmake --build .
echo "Building (parallel jobs: ${NPROCS})"
if [[ "${OS}" == MINGW* || "${OS}" == MSYS* || "${OS}" == CYGWIN* ]]; then
  # On Windows (MinGW/MSYS) use --config Release for multi-config generators if needed
  cmake --build . --config Release -- -j"${NPROCS}"
else
  cmake --build . -- -j"${NPROCS}"
fi

# 5) chmod +x build.sh
# try both relative paths (project root and build dir)
chmod +x ../build.sh 2>/dev/null || true
chmod +x build.sh 2>/dev/null || true

# 6) run tests via CTest
echo "Running tests with CTest"
if [[ "${OS}" == MINGW* || "${OS}" == MSYS* || "${OS}" == CYGWIN* ]]; then
  ctest --output-on-failure -C Release
else
  ctest --output-on-failure
fi

echo "CI script completed successfully on ${OS}"