# ============================================================================
# Vehicle Unit Tests
# Tests for vehicle connection, FTP, MAVLink commands, and link management
# ============================================================================

if(NOT QGC_DISABLE_APM_PLUGIN)
    set(_apm_test_sources
        APMAirframeComponentControllerTest.cc
        APMAirframeComponentControllerTest.h
    )
endif()

target_sources(${CMAKE_PROJECT_NAME}
    PRIVATE
        FTPManagerTest.cc
        FTPManagerTest.h
        FTPControllerTest.cc
        FTPControllerTest.h
        FirmwareUpgradeControllerTest.cc
        FirmwareUpgradeControllerTest.h
        InitialConnectTest.cc
        InitialConnectTest.h
        InitialConnectPeripheralStartupTest.cc
        InitialConnectPeripheralStartupTest.h
        MAVLinkLogManagerTest.cc
        MAVLinkLogManagerTest.h
        ${_apm_test_sources}
        RequestMessageTest.cc
        RequestMessageTest.h
        SendMavCommandWithHandlerTest.cc
        SendMavCommandWithHandlerTest.h
        SendMavCommandWithSignallingTest.cc
        SendMavCommandWithSignallingTest.h
        VehicleLinkManagerTest.cc
        VehicleLinkManagerTest.h
)

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
)
if(NOT QGC_DISABLE_APM_PLUGIN)
    target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
        ${CMAKE_SOURCE_DIR}/src/AutoPilotPlugins/APM
    )
endif()

# ----------------------------------------------------------------------------
# Component Information Tests
# ----------------------------------------------------------------------------
add_subdirectory(ComponentInformation)
