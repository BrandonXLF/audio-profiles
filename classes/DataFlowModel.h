#pragma once
#include <QObject>
#include <QAbstractListModel>
#include <QModelIndex>
#include <QByteArray>
#include <QHash>
#include <QVariant>
#include <QString>
#include <mmdeviceapi.h>
#include "AudioDeviceModel.h"

class DataFlowModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(AudioDevices* devices WRITE setDevices MEMBER mDevices)

public:
    DataFlowModel(QObject *parent = nullptr);

    enum {
        TitleRole = Qt::DisplayRole,
        ModelRole
    };

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = TitleRole) const override;
    virtual QHash<int, QByteArray> roleNames() const override;

private:
    AudioDevices* mDevices = nullptr;
    QHash<EDataFlow, QString> typeNames;
    QHash<EDataFlow, AudioDeviceModel*> models;

    void setDevices(AudioDevices* devices);
};
