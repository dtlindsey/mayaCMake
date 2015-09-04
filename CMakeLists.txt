cmake_minimum_required(VERSION 2.6)
# this needs to be the actual name of your project
project(sampleplugin)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/modules)

# will traverse into a src dir and look for more CMakeLists.txt files
add_subdirectory(src)


# pretend this is in the child dirs (example was /src)
# CMakeLists.txt in src dir
# You must specify all the source files in cmake
set(SOURCE_FILES
  "pluginMain.cpp"
  "sampleCmd.cpp"
  "sampleCmd.h"
  )

# CMake will fail if Maya Module isn't found
find_package(Maya REQUIRED)
#
# all the vars in the FindMaya.cmake are available now
include_directories(${MAYA_INCLUDE_DIR})
link_directories(${MAYA_LIBRARY_DIR})

# ${PROJECT_NAME} is auto created when project() is called in prior CMakeLists.txt
# add_library specifies you're created a shared library
add_library(${PROJECT_NAME} SHARED ${SOURCE_FILES})
target_link_libraries(${PROJECT_NAME} ${MAYA_LIBRARIES})
#
# Function call that puts it all together
MAYA_PLUGIN(${PROJECT_NAME})

# Using OpenMP
find_package(OpenMP)
if(OPENMP_FOUND)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
endif()
