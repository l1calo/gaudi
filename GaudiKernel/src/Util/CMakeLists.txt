gaudi_subdir(Util v31r0)

gaudi_depends_on_subdirs(GaudiKernel GaudiPluginService)

find_package(Boost COMPONENTS program_options regex)
find_package(ROOT)

#---Util Executables--------------------------------------------------------
#set(CMAKE_BUILD_TYPE Release)
gaudi_add_executable(genconf genconf.cpp
                 LINK_LIBRARIES GaudiKernel GaudiPluginService
                                ${Boost_LIBRARIES} ${ROOT_LIBRARIES}
                 INCLUDE_DIRS Boost ROOT)
if(WIN32)
  gaudi_add_executable(genwindef genwindef.cpp LibSymbolInfo.cpp)
endif()
