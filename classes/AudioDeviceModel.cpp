#include "AudioDeviceModel.h"

AudioDeviceModel::AudioDeviceModel(AudioDevices* devices, EDataFlow flow) : QAbstractListModel() {
    mDevices = devices;
    mFlow = flow;

    connect(mDevices, &AudioDevices::beforeDeviceAdded, this, [=](EDataFlow flow, int row) {
        if (flow != mFlow) return;
        beginInsertRows(QModelIndex(), row, row);
    });

    connect(mDevices, &AudioDevices::afterDeviceAdded, this, [=](EDataFlow flow) {
        if (flow != mFlow) return;
        endInsertRows();
    });

    connect(mDevices, &AudioDevices::beforeDeviceRemoved, this, [=](EDataFlow flow, int row) {
        if (flow != mFlow) return;
        beginRemoveRows(QModelIndex(), row, row);
    });

    connect(mDevices, &AudioDevices::afterDeviceRemoved, this, [=](EDataFlow flow) {
        if (flow != mFlow) return;
        endRemoveRows();
    });

    connect(mDevices, &AudioDevices::deviceUpdated, this, [=](EDataFlow flow, int row) {
        if (flow != mFlow) return;
        emit dataChanged(index(row, 0, QModelIndex()), index(row, 0, QModelIndex()));
    });
}

int AudioDeviceModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid() || !mDevices)
        return 0;

    return mDevices->getCount(mFlow);
}

QVariant AudioDeviceModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || !mDevices)
        return QVariant();

    AudioDevice* device = mDevices->getDeviceByIndex(mFlow, index.row());
    QVariant out;

    switch (role) {
        case IDRole:
            out = device->deviceID;
            break;
        case NameRole:
            out = device->name;
            break;
        case DefaultMainRole:
            out = QVariant(mDevices->isDefaultDevice(eConsole, device));
            break;
        case DefaultCommRole:
            out = QVariant(mDevices->isDefaultDevice(eCommunications, device));
            break;
        case VolumeRole:
            out = device->volume;
            break;
        case MuteRole:
            out = device->muted;
            break;
        case HasPopupRole:
            out = QVariant(device->deviceID == popupID);
    }

    return out;
}

bool AudioDeviceModel::setData(const QModelIndex &index, const QVariant &value, const int role) {
    if (!index.isValid() || !mDevices)
        return false;

    AudioDevice* device = mDevices->getDeviceByIndex(mFlow, index.row());

    switch (role) {
        case VolumeRole:
            device->setVolume(value.toFloat());
            return true;
        case MuteRole:
            device->setMute(value.toBool());
            return true;
        case DefaultMainRole:
            mDevices->setDefaultDevice(eConsole, device);
            return value.toBool();
        case DefaultCommRole:
            mDevices->setDefaultDevice(eCommunications, device);
            return value.toBool();
        case HasPopupRole:
            if (value.toBool()) {
                popupID = device->deviceID;
            } else if (popupID == device->deviceID) {
                popupID = "";
            }

            return true;
    }

    return false;
}


QHash<int, QByteArray> AudioDeviceModel::roleNames() const {
    return {
        { NameRole, "name" },
        { IDRole, "id" },
        { DefaultMainRole, "defaultMain" },
        { DefaultCommRole, "defaultComm" },
        { VolumeRole, "volume" },
        { MuteRole, "mute" },
        { HasPopupRole, "hasPopup" }
    };
}
