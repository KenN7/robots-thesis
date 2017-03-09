#  argos3core_simulator
#  argos3plugin_simulator_genericrobot)

if(ARGOS_BUILD_FOR_SIMULATOR)
    add_library(epuck_test_lightsensors MODULE epuck_test_lightsensors.h
                                            epuck_test_lightsensors.cpp)
    target_link_libraries(epuck_test_lightsensors
                          argos3plugin_${ARGOS_BUILD_FOR}_epuck)


    else()
    add_executable(epuck_test_lightsensors
      epuck_test_lightsensors.h
      epuck_test_lightsensors.cpp)
    target_link_libraries(epuck_test_lightsensors
                          argos3plugin_${ARGOS_BUILD_FOR}_epuck)

endif(ARGOS_BUILD_FOR_SIMULATOR)
