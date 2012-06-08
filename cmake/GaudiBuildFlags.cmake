#--- Gaudi Build Options -------------------------------------------------------
# Build options that map to compile time features
#
option(GAUDI_V21
       "disable backward compatibility hacks (implies all G21_* options)"
       OFF)
option(G21_HIDE_SYMBOLS
       "enable explicit symbol visibility on gcc-4"
       OFF)
option(G21_NEW_INTERFACES
       "disable backward-compatibility hacks in IInterface and InterfaceID"
       OFF)
option(G21_NO_ENDREQ
       "disable the 'endreq' stream modifier (use 'endmsg' instead)"
       OFF)
option(G21_NO_DEPRECATED
       "remove deprecated methods and functions"
       OFF)
option(G22_NEW_SVCLOCATOR
       "use (only) the new interface of the ServiceLocator"
       OFF)
option(GAUDI_V22
       "enable some API extensions"
       OFF)

option(GAUDI_CMT_RELEASE
       "use CMT deafult release flags instead of the CMake ones"
       ON)

#--- Compilation Flags ---------------------------------------------------------
if(MSVC90)
  add_definitions(/wd4275 /wd4251 /wd4351)
  add_definitions(-DBOOST_ALL_DYN_LINK -DBOOST_ALL_NO_LIB)
  add_definitions(/nologo)
  set(CMAKE_CXX_FLAGS_DEBUG "/D_NDEBUG /MD /Zi /Ob0 /Od /RTC1")
  if(GAUDI_CMT_RELEASE)
    set(CMAKE_CXX_FLAGS_RELEASE "/O2")
    set(CMAKE_C_FLAGS_RELEASE "/O2")
  endif()
else()
  #
  set(CMAKE_CXX_FLAGS "-fmessage-length=0 -pipe -ansi -Wall -Wextra -Werror=return-type -pthread")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pedantic -Wwrite-strings -Wpointer-arith -Woverloaded-virtual -Wno-long-long")
  if(GAUDI_CMT_RELEASE)
    set(CMAKE_CXX_FLAGS_RELEASE "-O2 -DNDEBUG")
    set(CMAKE_C_FLAGS_RELEASE "-O2 -DNDEBUG")
  endif()
  add_definitions(-D_GNU_SOURCE -Dunix -Df2cFortran)
  if (CMAKE_SYSTEM_NAME MATCHES Linux)
    add_definitions(-Dlinux)
  endif()
endif()

#--- Link shared flags ---------------------------------------------------------
if (CMAKE_SYSTEM_NAME MATCHES Linux)
  set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--as-needed -Wl,--no-undefined  -Wl,-z,max-page-size=0x1000")
  set(CMAKE_MODULE_LINKER_FLAGS "-Wl,--as-needed -Wl,--no-undefined  -Wl,-z,max-page-size=0x1000")
endif()

if(APPLE)
   set(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "${CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS} -flat_namespace -single_module -undefined dynamic_lookup")
   set(CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS "${CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS} -flat_namespace -single_module -undefined dynamic_lookup")
endif()

#--- Special build flags -------------------------------------------------------
if ((GAUDI_V21 OR G21_HIDE_SYMBOLS) AND (comp MATCHES gcc4))
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden -fvisibility-inlines-hidden")
endif()

if(NOT GAUDI_V21)
  if(GAUDI_V22)
    add_definitions(-DGAUDI_V22_API)
  else()
    add_definitions(-DGAUDI_V20_COMPAT)
  endif()
  # special case
  if(G21_HIDE_SYMBOLS AND (comp MATCHES gcc4))
    add_definitions(-DG21_HIDE_SYMBOLS)
  endif()
  #
  foreach (feature G21_NEW_INTERFACES G21_NO_ENDREQ G21_NO_DEPRECATED G22_NEW_SVCLOCATOR)
    if (${feature})
      add_definitions(-D${feature})
    endif()
  endforeach()
endif()

#--- Tuning of warnings --------------------------------------------------------
if(HIDE_WARNINGS)
  if(comp MATCHES clang)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated -Wno-overloaded-virtual -Wno-char-subscripts -Wno-unused-parameter")
  elseif(comp MATCHES gcc4[367] OR comp MATCHES gccmax)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated -Wno-empty-body")
  endif()
endif()

#--- Special flags -------------------------------------------------------------
add_definitions(-DBOOST_FILESYSTEM_VERSION=3)

if(comp MATCHES gcc47 OR comp MATCHES gccmax)
  set(GCCXML_CXX_FLAGS "-D__STRICT_ANSI__")
endif()
