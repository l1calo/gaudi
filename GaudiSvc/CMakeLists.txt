gaudi_subdir(GaudiSvc v19r0)

gaudi_depends_on_subdirs(GaudiKernel)

find_package(AIDA)
find_package(Boost REQUIRED COMPONENTS regex)
find_package(ROOT COMPONENTS Hist RIO Tree)
find_package(CLHEP)

#---Libraries---------------------------------------------------------------
SET(GaudiSvc_srcs
DetectorDataSvc/*.cpp
NTupleSvc/*.cpp
RndmGenSvc/*.cpp
THistSvc/*.cpp)

gaudi_add_module(GaudiSvc ${GaudiSvc_srcs}
                        LINK_LIBRARIES GaudiKernel Boost ROOT CLHEP
                        INCLUDE_DIRS Boost ROOT AIDA CLHEP)

if(BUILD_TESTS)
  gaudi_add_module(GaudiSvcTest ../tests/src/component/*.cpp LINK_LIBRARIES GaudiKernel ${Boost_REGEX_LIBRARY})
endif()

#---Test-----------------------------------------------------------------------
gaudi_add_test(QMTest QMTEST)