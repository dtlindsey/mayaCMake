# - Maya finder module
#
# Variables that will be defined:
# MAYA_FOUND                    Defined if a Maya installation has been detected
# MAYA_EXECUTABLE         Path to Maya's executable
# MAYA_<lib>_FOUND        Defined if <lib> has been found
# MAYA_<lib>_LIBRARY    Path to <lib> library
# MAYA_INCLUDE_DIR        Path to the devkit's include directories
# MAYA_LIBRARIES            All the Maya libraries
# This should endup in a modules dir within your base plugin dir

if(NOT DEFINED MAYA_VERSION)
    #CACHE STRING allows us to pass version as an arg in command line
    set(MAYA_VERSION 2015 CACHE STRING "Maya version")
endif()

# Maya compile defs
set(MAYA_COMPILE_DEFINITIONS "REQUIRE_IOSTREAM;_BOOL")
# Maya vars
set(MAYA_INSTALL_BASE_SUFFIX "")
set(MAYA_LIB_SUFFIX "lib")
set(MAYA_INC_SUFFIX "include")
# OS specific defs
if(WIN32)
    #Windows
    set(MAYA_INSTALL_BASE "C:/Programs Files/Autodesk")
    set(OPENMAYA OpenMaya.lib)
    set(MAYA_COMPILE_DEFINITIONS "${MAYA_COMPILE_DEFINITIONS};NT_PLUGIN")
    set(MAYA_PLUGIN_EXTENSION ".mll")
elseif(APPLE)
    #Mac
    set(MAYA_INSTALL_BASE "/Applications/Autodesk")
    set(MAYA_LIB_SUFFIX "Maya.app/Contents/MacOS")
    set(MAYA_INC_SUFFIX "devkit/include")
    set(OPENMAYA libOpenMaya.dylib)
    set(MAYA_COMPILE_DEFINITIONS "${MAYA_COMPILE_DEFINITIONS};OSMac_")
    set(MAYA_PLUGIN_EXTENSION ".bundle")
else()
    #Linux
    set(MAYA_INSTALL_BASE "/usr/autodesk")
    set(MAYA_INSTALL_BASE_SUFFIX "-x64")
    set(OPENMAYA libOpenMaya.so)
    set(MAYA_COMPILE_DEFINITIONS "${MAYA_COMPILE_DEFINITIONS};LINUX")
    set(MAYA_PLUGIN_EXTENSION ".so")
    # only needed for linux
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
endif()

set(MAYA_INSTALL_BASE_PATH ${MAYA_INSTALL_BASE} CACHE STRING 
    "Root Maya install path, e.g. /usr/autodesk")

set(MAYA_LOCATION 
    ${MAYA_INSTALL_BASE_PATH}/maya/${MAYA_VERSION}${MAYA_INSTALL_BASE_SUFFIX})

#find_path is a cmake built-in
find_path(MAYA_LIBRARY_DIR ${OPENMAYA}
    PATHS
        ${MAYA_LOCATION}
        $ENV{MAYA_LOCATION}
    PATH_SUFFIXES
        "${MAYA_LIB_SUFFIX}/"
    DOC "Maya library path")

find_path(MAYA_INCLUDE_DIR maya/MFn.h
    PATHS
        ${MAYA_LOCATION}
        $ENV{MAYA_LOCATION}
    PATH_SUFFIXES
        "${MAYA_INC_SUFFIX}/"
    DOC "Maya include path")

# Maya libs
set(_MAYA_LIBRARIES OpenMaya OpenMayaAnim OpenMayaFX OpenMayaRender OpenMayaUI 
    foundation)
foreach(MAYA_LIB ${_MAYA_LIBRARIES}
        find_library(MAYA_${MAYA_LIB}_LIBRARY NAMES ${MAYA_LIB} 
	    PATHS ${MAYA_LIBRARY_DIR} NO_DEFAULT_PATH)
        set(MAYA_LIBRARIES ${MAYA_LIBRARIES} ${MAYA_${MAYA_LIB}_LIBRARY})
endforeach()

# Maya includs
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Maya DEFAULT_MSG MAYA_INCLUDE MAYA_LIBRARIES)

# target function
function(MAYA_PLUGIN _target)
  # windows needs extra linking flags
  if (WIN32)
    set_target_properties(${_target} PROPERTIES
      LINK_FLAGS "/export:intializePlugin /export:uninitializePlugin")
  endif()
  #
  set_target_properties(${_target} PROPERTIES
    COMPILE_DEFINITIONS "${MAYA_COMPILE_DEFINITIONS}"
    # this is so mac and linux don't prepend lib to the head
    PREFIX ""
    SUFFIX ${MAYA_PLUGIN_EXTENSION}
    )
endfunction()