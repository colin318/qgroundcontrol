#pragma once

#include <QtCore/QObject>
#include <QtCore/QVariantList>
#include <QtCore/QString>

class Vehicle;

class FusionMissionModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QVariantList waypointCoordinates
               READ waypointCoordinates
               NOTIFY waypointCoordinatesChanged)

    Q_PROPERTY(int currentWaypointIndex
               READ currentWaypointIndex
               NOTIFY currentWaypointIndexChanged)

    Q_PROPERTY(QString currentWaypointAltitude
               READ currentWaypointAltitude
               NOTIFY currentWaypointChanged)

    Q_PROPERTY(QString currentWaypointSpeed
               READ currentWaypointSpeed
               NOTIFY currentWaypointChanged)

public:
    explicit FusionMissionModel(QObject *parent = nullptr);

    QVariantList waypointCoordinates()  const { return _waypointCoords; }
    int          currentWaypointIndex() const { return _currentWpIndex; }
    QString      currentWaypointAltitude() const { return _currentWpAlt; }
    QString      currentWaypointSpeed()    const { return _currentWpSpeed; }

signals:
    void waypointCoordinatesChanged();
    void currentWaypointIndexChanged();
    void currentWaypointChanged();

private slots:
    void _onActiveVehicleChanged(Vehicle *vehicle);
    void _refreshWaypoints();

private:
    QVariantList _waypointCoords;
    int          _currentWpIndex = 0;
    QString      _currentWpAlt   = QStringLiteral("—");
    QString      _currentWpSpeed = QStringLiteral("—");

    Vehicle     *_currentVehicle = nullptr;
};
