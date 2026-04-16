#include "FusionMissionModel.h"
#include "MultiVehicleManager.h"
#include "Vehicle.h"
#include "MissionManager.h"
#include "MissionItem.h"

#include <QtPositioning/QGeoCoordinate>
#include <QtCore/QVariant>

FusionMissionModel::FusionMissionModel(QObject *parent)
    : QObject(parent)
{
    MultiVehicleManager *mgr = MultiVehicleManager::instance();
    if (mgr) {
        connect(mgr, &MultiVehicleManager::activeVehicleChanged,
                this, &FusionMissionModel::_onActiveVehicleChanged);
        _onActiveVehicleChanged(mgr->activeVehicle());
    }
}

void FusionMissionModel::_onActiveVehicleChanged(Vehicle *vehicle)
{
    if (_currentVehicle) {
        disconnect(_currentVehicle->missionManager(), &MissionManager::newMissionItemsAvailable,
                   this, &FusionMissionModel::_refreshWaypoints);
    }

    _currentVehicle = vehicle;

    if (_currentVehicle) {
        connect(_currentVehicle->missionManager(), &MissionManager::newMissionItemsAvailable,
                this, &FusionMissionModel::_refreshWaypoints);
    }

    _refreshWaypoints();
}

void FusionMissionModel::_refreshWaypoints()
{
    _waypointCoords.clear();

    if (_currentVehicle) {
        const QList<MissionItem *> &items = _currentVehicle->missionManager()->missionItems();
        for (const MissionItem *item : items) {
            if (item) {
                _waypointCoords.append(QVariant::fromValue(item->coordinate()));
            }
        }

        if (!items.isEmpty() && _currentWpIndex < items.size()) {
            const MissionItem *wp = items.at(_currentWpIndex);
            _currentWpAlt   = QString::number(wp->coordinate().altitude(), 'f', 1) + QStringLiteral(" m");
            _currentWpSpeed = QStringLiteral("8.0 m/s");
        } else {
            _currentWpAlt   = QStringLiteral("—");
            _currentWpSpeed = QStringLiteral("—");
        }
    } else {
        _currentWpAlt   = QStringLiteral("—");
        _currentWpSpeed = QStringLiteral("—");
    }

    emit waypointCoordinatesChanged();
    emit currentWaypointChanged();
}
