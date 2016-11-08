# Produces dependencies of Klampt
# Given KLAMPT_ROOT (optional)
# Produces
# - KLAMPT_LIBRARIES
# - KLAMPT_INCLUDE_DIRS
# - KLAMPT_DEFINITIONS
#
# May also need to set BOOST_ROOT on Windows

IF(NOT KLAMPT_ROOT)
  MESSAGE("KLAMPT_ROOT not defined, setting to .")
  SET(KLAMPT_ROOT .)
ENDIF( )

IF(WIN32)
  #Assume binaries for KrisLibrary, ODE, GLPK, GLUI, tinyxml are in the library
  #directory as given by the prebuilt binary package.
  #Assume ode is double
  SET(KRISLIBRARY_ROOT ${KLAMPT_ROOT}/Library CACHE PATH "Library subdirectory")
  SET(KLAMPT_DEFINITIONS -DHAVE_GLUI=1 -DHAVE_GLUT=1 -DHAVE_TIXML=1 -DTIXML_USE_STL -DdDOUBLE -DNOMINMAX -DGLUI_NO_LIB_PRAGMA -DUSE_BOOST_THREADS=1)

  # Boost threads vs pthreads
  SET(Boost_USE_STATIC_LIBS ON)
  SET(Boost_USE_MULTITHREADED ON)
  SET(Boost_USE_STATIC_RUNTIME OFF)
  FIND_PACKAGE(Boost REQUIRED COMPONENTS thread system)

  include(FindPackageHandleStandardArgs)
  FIND_PATH(KRISLIBRARY_INCLUDE_DIR KrisLibrary/myfile.h
    PATHS ${KRISLIBRARY_ROOT}  )
  FIND_LIBRARY(KRISLIBRARY_LIBRARY_DEBUG 
	NAMES KrisLibraryd
	PATHS ${KRISLIBRARY_ROOT})
  FIND_LIBRARY(KRISLIBRARY_LIBRARY_RELEASE
	NAMES KrisLibrary
	PATHS ${KRISLIBRARY_ROOT})
  find_package_handle_standard_args(KRISLIBRARY
	DEFAULT_MSG
	KRISLIBRARY_INCLUDE_DIR
	KRISLIBRARY_LIBRARY_DEBUG
	KRISLIBRARY_LIBRARY_RELEASE)
  if(NOT KRISLIBRARY_FOUND)
    MESSAGE("KrisLibrary not found!")
  endif( )

  FIND_PATH(ODE_INCLUDE_DIR ode/ode.h
    PATHS ${KRISLIBRARY_ROOT}/ode-0.11.1/include  )
  FIND_LIBRARY(ODE_LIBRARY_DEBUG 
	NAMES ode_doubled
	PATHS ${KRISLIBRARY_ROOT})
  FIND_LIBRARY(ODE_LIBRARY_RELEASE
	NAMES ode_double
	PATHS ${KRISLIBRARY_ROOT})
  find_package_handle_standard_args(ODE
	DEFAULT_MSG
	ODE_INCLUDE_DIR
	ODE_LIBRARY_DEBUG
	ODE_LIBRARY_RELEASE)
  if(NOT ODE_FOUND)
    MESSAGE("ODE not found!")
  endif( )

  FIND_PATH(GLPK_INCLUDE_DIR glpk.h
	PATHS ${KRISLIBRARY_ROOT}/glpk-4.52/src  )
  FIND_LIBRARY(GLPK_LIBRARY
	NAMES glpk_4_52
	PATHS ${KRISLIBRARY_ROOT})
  find_package_handle_standard_args(GLPK
	DEFAULT_MSG
	GLPK_INCLUDE_DIR
	GLPK_LIBRARY)
  if(NOT GLPK_FOUND)
    MESSAGE("GLPK not found!")
  endif( )

  FIND_PATH(GLUI_INCLUDE_DIR GL/glui.h
	PATHS ${KRISLIBRARY_ROOT}/glui-2.36/src/include  )
  FIND_LIBRARY(GLUI_LIBRARY_DEBUG
	NAMES glui32d
	PATHS ${KRISLIBRARY_ROOT})
  FIND_LIBRARY(GLUI_LIBRARY_RELEASE
	NAMES glui32
	PATHS ${KRISLIBRARY_ROOT})
  find_package_handle_standard_args(GLUI
	DEFAULT_MSG
	GLUI_INCLUDE_DIR
	GLUI_LIBRARY_DEBUG
	GLUI_LIBRARY_RELEASE)
  if(NOT GLUI_FOUND)
    MESSAGE("GLUI not found!")
  endif( )

  FIND_PATH(TINYXML_INCLUDE_DIR tinyxml.h
	PATHS ${KRISLIBRARY_ROOT}/tinyxml )
  FIND_LIBRARY(TINYXML_LIBRARY_DEBUG
	NAMES tinyxmld_STL
	PATHS ${KRISLIBRARY_ROOT})
  FIND_LIBRARY(TINYXML_LIBRARY_RELEASE
	NAMES tinyxml_STL
	PATHS ${KRISLIBRARY_ROOT})
  find_package_handle_standard_args(TINYXML
	DEFAULT_MSG
	TINYXML_INCLUDE_DIR
	TINYXML_LIBRARY_DEBUG
	TINYXML_LIBRARY_RELEASE)
  if(NOT TINYXML_FOUND)
    MESSAGE("TinyXML not found!")
  endif( )

  SET(KLAMPT_LIBRARIES debug ${KRISLIBRARY_LIBRARY_DEBUG} optimized ${KRISLIBRARY_LIBRARY_RELEASE} debug ${ODE_LIBRARY_DEBUG} optimized ${ODE_LIBRARY_RELEASE} ${GLPK_LIBRARY} debug ${GLUI_LIBRARY_DEBUG} optimized ${GLUI_LIBRARY_RELEASE} debug ${TINYXML_LIBRARY_DEBUG} optimized ${TINYXML_LIBRARY_RELEASE} glut32 opengl32 Ws2_32 winmm Gdiplus ${Boost_LIBRARIES})
  SET(KLAMPT_INCLUDE_DIRS ${KRISLIBRARY_INCLUDE_DIR} ${Boost_INCLUDE_DIR} ${ODE_INCLUDE_DIR} ${GLPK_INCLUDE_DIR} ${GLUI_INCLUDE_DIR} ${TINYXML_INCLUDE_DIR})
  #Boost should be included as a lib directory
  LINK_DIRECTORIES(${Boost_LIBRARY_DIR})

  #Optional: Assimp package
  IF(NOT ASSIMP_ROOT)
    SET(ASSIMP_ROOT "${KRISLIBRARY_ROOT}/assimp--3.0.1270-sdk" 
       CACHE PATH
       "Root of Assimp package"
       FORCE
    )
  ENDIF(NOT ASSIMP_ROOT)
  FIND_PACKAGE(Assimp)
  IF(ASSIMP_FOUND)
    SET(KLAMPT_INCLUDE_DIRS ${KLAMPT_INCLUDE_DIRS} ${ASSIMP_INCLUDE_DIR})
    SET(KLAMPT_LIBRARIES ${KLAMPT_LIBRARIES} ${ASSIMP_LIBRARY})
  ENDIF(ASSIMP_FOUND)

ELSE(WIN32)

  SET(KRISLIBRARY_ROOT "${KLAMPT_ROOT}/Library" CACHE PATH "Library subdirectory" FORCE)
  FIND_PACKAGE(KrisLibrary REQUIRED)
  SET(KLAMPT_DEFINITIONS ${KRISLIBRARY_DEFINITIONS})
  SET(KLAMPT_INCLUDE_DIRS ${KRISLIBRARY_INCLUDE_DIRS})
  SET(KLAMPT_LIBRARIES ${KRISLIBRARY_LIBRARIES})

  # ODE
  SET(ODE_ROOT "${KLAMPT_ROOT}/Library/ode-0.11.1" CACHE PATH "Open Dynamics Engine path" FORCE)
  FIND_PACKAGE(ODE REQUIRED)
  IF(ODE_FOUND)
    MESSAGE("Open Dynamics Engine library found")
    MESSAGE("  Compiler definitions: ${ODE_DEFINITIONS}") 
    SET(KLAMPT_DEFINITIONS ${KLAMPT_DEFINITIONS} ${ODE_DEFINITIONS})
    SET(KLAMPT_INCLUDE_DIRS ${KLAMPT_INCLUDE_DIRS} ${ODE_INCLUDE_DIRS})
    SET(KLAMPT_LIBRARIES ${KLAMPT_LIBRARIES} ${ODE_LIBRARIES})
  ENDIF(ODE_FOUND)

  # GL Extension Wrangler (GLEW)
  FIND_PACKAGE(GLEW)
  IF(GLEW_FOUND)
    SET(KLAMPT_DEFINITIONS ${KLAMPT_DEFINITIONS} -DHAVE_GLEW=1)
    SET(KLAMPT_LIBRARIES ${KLAMPT_LIBRARIES} ${GLEW_LIBRARY})
  ELSE(GLEW_FOUND)
    MESSAGE("GLEW library not found, camera simulation will be slow")
    SET(KLAMPT_DEFINITIONS ${KLAMPT_DEFINITIONS} -DHAVE_GLEW=0)
  ENDIF(GLEW_FOUND)
ENDIF(WIN32)

SET(ROSDEPS tf rosconsole roscpp roscpp_serialization rostime )
FIND_PACKAGE(ROS)
IF(ROS_FOUND)
  MESSAGE("ROS found, version " ${ROS_VERSION})
  LIST(APPEND KLAMPT_INCLUDE_DIRS ${ROS_INCLUDE_DIR})
  LIST(APPEND KLAMPT_LIBRARIES ${ROS_LIBRARIES})
  LIST(APPEND KLAMPT_DEFINITIONS "-DHAVE_ROS=1")
ENDIF(ROS_FOUND)

LIST(REMOVE_DUPLICATES KLAMPT_INCLUDE_DIRS)