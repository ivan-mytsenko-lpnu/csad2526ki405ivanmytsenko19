cmake_minimum_required(VERSION 3.14)
project(hello-world)
set(CMAKE_CXX_STANDARD 11)

add_executable(hello-world main.cpp math_operations.cpp)

enable_testing()

# Try to use system-installed GTest first, otherwise fetch it
find_package(GTest CONFIG QUIET)

if (NOT GTest_FOUND)
  include(FetchContent)
  FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.zip
  )
  set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
  FetchContent_MakeAvailable(googletest)
endif()

add_executable(unit_tests tests/unit_tests.cpp math_operations.cpp)
target_include_directories(unit_tests PRIVATE ${CMAKE_SOURCE_DIR})
target_link_libraries(unit_tests PRIVATE GTest::gtest_main)
add_test(NAME unit_tests COMMAND unit_tests)