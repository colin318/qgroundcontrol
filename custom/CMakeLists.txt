message(STATUS "QGC: Adding Fusion GCS Custom Plugin")

# ============================================================================
# Custom Resources and Import Paths
# ============================================================================

list(APPEND CUSTOM_RESOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/custom.qrc
)
set(QGC_RESOURCES ${QGC_RESOURCES} ${CUSTOM_RESOURCES} CACHE STRING "Paths to .qrc Resources" FORCE)

set(QML_IMPORT_PATH ${QML_IMPORT_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/res" CACHE STRING "Extra qml import paths" FORCE)

# ============================================================================
# Custom QML Module
# ============================================================================

qt_add_library(CustomModule STATIC)

qt_add_qml_module(CustomModule
    URI FusionGCS
    VERSION 1.0
    RESOURCE_PREFIX /qml
    QML_FILES
        res/FusionGCS/FusionDashboard.qml
        res/FusionGCS/FusionSidebar.qml
        res/FusionGCS/FusionTopBar.qml
        res/FusionGCS/FusionVehicleCard.qml
        res/FusionGCS/FusionMapCard.qml
        res/FusionGCS/FusionAlertCard.qml
        res/FusionGCS/pages/OverviewPage.qml
        res/FusionGCS/pages/ControlPage.qml
        res/FusionGCS/pages/MissionPage.qml
        res/FusionGCS/pages/DevicePage.qml
        res/FusionGCS/pages/AnalyticsPage.qml
        src/FusionToolBarButton.qml
    NO_PLUGIN
)

# ============================================================================
# Custom Plugin Sources (C++ with Vehicle.h / MAVLink dependencies)
# ============================================================================

set(CUSTOM_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/src/CustomPlugin.h
    ${CMAKE_CURRENT_SOURCE_DIR}/src/CustomPlugin.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/FusionStatusTextModel.h
    ${CMAKE_CURRENT_SOURCE_DIR}/src/FusionStatusTextModel.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/FusionMissionModel.h
    ${CMAKE_CURRENT_SOURCE_DIR}/src/FusionMissionModel.cc
    CACHE INTERNAL "" FORCE
)

# ============================================================================
# Custom Build Configuration
# ============================================================================

set(CUSTOM_LIBRARIES
    CustomModule
    CACHE INTERNAL "" FORCE
)

set(CUSTOM_INCLUDE_DIRECTORIES
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    CACHE INTERNAL "" FORCE
)

set(CUSTOM_DEFINITIONS
    QGC_CUSTOM_BUILD
    CUSTOMHEADER="CustomPlugin.h"
    CUSTOMCLASS=CustomPlugin
    CACHE INTERNAL "" FORCE
)

set(CUSTOM_QT_COMPONENTS
    Location
    CACHE INTERNAL "" FORCE
)
