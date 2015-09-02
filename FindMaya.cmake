# - Maya finder module
#
# Variables that will be defined:
# MAYA_FOUND                    Defined if a Maya installation has been detected
# MAYA_EXECUTABLE         Path to Maya's executable
# MAYA_<lib>_FOUND        Defined if <lib> has been found
# MAYA_<lib>_LIBRARY    Path to <lib> library
# MAYA_INCLUDE_DIR        Path to the devkit's include directories
# MAYA_LIBRARIES            All the Maya libraries
#

if(NOT DEFINED MAYA_VERSION)
    #CACHE STRING allows us to pass version as an arg in command line
    set(MAYA_VERSION 2015 CACHE STRING "Maya version")
endif()

# Maya vars
set(MAYA_INSTALL_BASE_SUFFIX "")
set(MAYA_LIB_SUFFIX "lib")
set(MAYA_INC_SUFFIX "include")
# OS specific defs
if(WIN32)
    #Windows
    set(MAYA_INSTALL_BASE "C:/Programs Files/Autodesk")
    set(OPENMAYA OpenMaya.lib)
elseif(APPLE)
    #Mac
    set(MAYA_INSTALL_BASE "/Applications/Autodesk")
    set(MAYA_LIB_SUFFIX "Maya.app/Contents/MacOS")
    set(MAYA_INC_SUFFIX "devkit/include")
    set(OPENMAYA libOpenMaya.dylib)
else()
    #Linux
    set(MAYA_INSTALL_BASE "/usr/autodesk")
    set(MAYA_INSTALL_BASE_SUFFIX "-x64")
    set(OPENMAYA libOpenMaya.so)
endif()

set(MAYA_INSTALL_BASE_PATH ${MAYA_INSTALL_BASE} CACHE STRING 
    "Root Maya install path, e.g. /usr/autodesk")

set(MAYA_LOCATION ${MAYA_INSTALL_BASE_PATH}/maya/${MAYA_VERSION}${MAYA_INSTALL_BASE_SUFFIX})

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
set(_MAYA_LIBRARIES OpenMaya OpenMayaAnim OpenMayaFX OpenMayaRender OpenMayaUI foundation)
foreach(MAYA_LIB ${_MAYA_LIBRARIES}
        find_library(MAYA_${MAYA_LIB}_LIBRARY NAMES ${MAYA_LIB} PATHS ${MAYA_LIBRARY_DIR} 
	    NO_DEFAULT_PATH)
        set(MAYA_LIBRARIES ${MAYA_LIBRARIES} ${MAYA_${MAYA_LIB}_LIBRARY})
endforeach()

# Maya includs
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Maya DEFAULT_MSG MAYA_INCLUDE MAYA_LIBRARIES)
