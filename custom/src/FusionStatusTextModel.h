#pragma once

#include <QtCore/QAbstractListModel>
#include <QtCore/QDateTime>
#include <QtCore/QList>
#include <QtCore/QString>

class Vehicle;

struct FusionAlertEntry {
    int       vehicleId;
    int       severity;
    QString   text;
    QDateTime timestamp;
};

class FusionStatusTextModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(int unreadCount READ unreadCount NOTIFY unreadCountChanged)

public:
    enum Roles {
        VehicleIdRole = Qt::UserRole + 1,
        SeverityRole,
        TextRole,
        TimestampRole
    };
    Q_ENUM(Roles)

    explicit FusionStatusTextModel(QObject *parent = nullptr);

    int      unreadCount() const { return _unreadCount; }
    Q_INVOKABLE void resetUnread();
    Q_INVOKABLE void clearAll();

    // QAbstractListModel
    int      rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

signals:
    void unreadCountChanged();

private slots:
    void _onVehicleAdded(Vehicle *vehicle);
    void _onTextMessage(int vehicleId, int componentId, int severity, QString text, QString description);

private:
    QList<FusionAlertEntry> _entries;
    int _unreadCount = 0;
};
