#pragma once
#include <QObject>
#include <QAbstractListModel>
#include <QModelIndex>
#include <QByteArray>
#include <QHash>
#include <QVariant>
#include <QString>
#include <mmdeviceapi.h>
#include "AudioDevices.h"

class AudioDeviceModel : public QAbstractListModel {
    Q_OBJECT

public:
    AudioDeviceModel(AudioDevices* devices, EDataFlow flow);

    enum {
        NameRole = Qt::DisplayRole,
        IDRole,
        DefaultMainRole,
        DefaultCommRole,
        VolumeRole,
        MuteRole,
        HasPopupRole
    };

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = NameRole) const override;
    bool setData(const QModelIndex &index, const QVariant &value, const int role) override;
    virtual QHash<int, QByteArray> roleNames() const override;

private:
    AudioDevices* mDevices = nullptr;
    EDataFlow mFlow;
    QString popupID;
};
