#include "FusionStatusTextModel.h"
#include "MultiVehicleManager.h"
#include "Vehicle.h"

FusionStatusTextModel::FusionStatusTextModel(QObject *parent)
    : QAbstractListModel(parent)
{
    MultiVehicleManager *mgr = MultiVehicleManager::instance();
    if (mgr) {
        connect(mgr, &MultiVehicleManager::vehicleAdded,
                this, &FusionStatusTextModel::_onVehicleAdded);
        // Connect already-existing vehicles
        const auto *vehicles = mgr->vehicles();
        for (int i = 0; i < vehicles->count(); ++i) {
            _onVehicleAdded(vehicles->value<Vehicle *>(i));
        }
    }
}

void FusionStatusTextModel::resetUnread()
{
    if (_unreadCount != 0) {
        _unreadCount = 0;
        emit unreadCountChanged();
    }
}

void FusionStatusTextModel::clearAll()
{
    if (_entries.isEmpty()) {
        return;
    }
    beginResetModel();
    _entries.clear();
    endResetModel();

    if (_unreadCount != 0) {
        _unreadCount = 0;
        emit unreadCountChanged();
    }
}

int FusionStatusTextModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) {
        return 0;
    }
    return _entries.size();
}

QVariant FusionStatusTextModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= _entries.size()) {
        return QVariant();
    }
    const FusionAlertEntry &entry = _entries.at(index.row());
    switch (role) {
    case VehicleIdRole:  return entry.vehicleId;
    case SeverityRole:   return entry.severity;
    case TextRole:       return entry.text;
    case TimestampRole:  return entry.timestamp.toString(QStringLiteral("hh:mm:ss"));
    default:             return QVariant();
    }
}

QHash<int, QByteArray> FusionStatusTextModel::roleNames() const
{
    return {
        { VehicleIdRole,  "vehicleId"  },
        { SeverityRole,   "severity"   },
        { TextRole,       "alertText"  },
        { TimestampRole,  "timestamp"  },
    };
}

void FusionStatusTextModel::_onVehicleAdded(Vehicle *vehicle)
{
    if (!vehicle) {
        return;
    }
    connect(vehicle, &Vehicle::textMessageReceived,
            this, &FusionStatusTextModel::_onTextMessage,
            Qt::UniqueConnection);
}

void FusionStatusTextModel::_onTextMessage(int vehicleId, int /*componentId*/,
                                           int severity, QString text, QString /*description*/)
{
    beginInsertRows(QModelIndex(), _entries.size(), _entries.size());
    _entries.append({ vehicleId, severity, text, QDateTime::currentDateTime() });
    endInsertRows();

    _unreadCount++;
    emit unreadCountChanged();
}
