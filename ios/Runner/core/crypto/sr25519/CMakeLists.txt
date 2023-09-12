# General project setup
cmake_minimum_required (VERSION 3.1)
project (Sr25519 C)
message("Building project ${PROJECT_NAME}")
include(CTest)

# Set compiler flags
set(CMAKE_BUILD_TYPE Debug)

# Take care of libpthread
set(THREADS_PREFER_PTHREAD_FLAG ON)

find_package(Threads REQUIRED)

###############################################################################
# Dependencies:

file(GLOB_RECURSE strobe
			"strobe-code/*.h"
            "strobe-code/*.c.inc"
			"strobe-code/*.c"
    )

set (DEPENDENCY_LIBS Threads::Threads strobe dl)


# End of Dependencies
#########################################################

# Setup source files directories
file(GLOB_RECURSE examples ${PROJECT_SOURCE_DIR}/examples/*.c)
file(GLOB_RECURSE src ${PROJECT_SOURCE_DIR}/src/*.c)
file(GLOB_RECURSE srch ${PROJECT_SOURCE_DIR}/src/*.h)
file(GLOB_RECURSE srctest ${PROJECT_SOURCE_DIR}/test/*.c)

# Setup output directories
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

###############################################################################
# Polkadot C++ API Library

# Build library code from src folder
add_library(sr25519 ${strobe} ${src})

add_executable(sr25519test ${strobe} ${src} ${srch} ${srctest})
target_link_libraries (sr25519test sr25519)

