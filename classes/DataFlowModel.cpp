#include "DataFlowModel.h"

DataFlowModel::DataFlowModel(QObject *parent) : QAbstractListModel(parent) {
    typeNames[eRender] = "Speakers";
    typeNames[eCapture] = "Microphones";
}

int DataFlowModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid())
        return 0;

    return 2;
}

QVariant DataFlowModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid())
        return QVariant();

    EDataFlow dataFlow = mDevices->flows[index.row()];
    QVariant out;

    switch (role) {
        case TitleRole:
            out = typeNames[dataFlow];
            break;
        case ModelRole:
            out = QVariant::fromValue(models[dataFlow]);
            break;
    }

    return out;
}

QHash<int, QByteArray> DataFlowModel::roleNames() const {
    return {
        { TitleRole, "groupTitle" },
        { ModelRole, "subModel" }
    };
}

void DataFlowModel::setDevices(AudioDevices* devices) {
    if (mDevices)
        for (auto &flow : mDevices->flows)
            delete models[flow];

    mDevices = devices;

    if (!mDevices) return;

    for (auto &flow : mDevices->flows)
        models[flow] = new AudioDeviceModel(mDevices, flow);
}
