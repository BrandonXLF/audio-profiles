#pragma once
#include <QObject>
#include <QString>
#include <QAbstractListModel>
#include <QSettings>
#include <QList>
#include <QModelIndex>
#include <QHash>
#include <mmdeviceapi.h>
#include "AudioDevices.h"

class ProfileModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(AudioDevices* devices MEMBER mDevices)
    Q_PROPERTY(QSettings* settings WRITE setSettings MEMBER mSettings)

    struct Profile {
        QString name;
        QHash<std::pair<EDataFlow, ERole>, QString> defaults;
    };

public:
    ProfileModel(QObject *parent = nullptr);

    enum {
        NameRole = Qt::DisplayRole
    };

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = NameRole) const override;
    bool setData(const QModelIndex &index, const QVariant &value, const int role) override;
    virtual QHash<int, QByteArray> roleNames() const override;

public slots:
    void newProfile(QString name);
    void loadProfile(int index);
    void deleteProfile(int index);

private:
    AudioDevices* mDevices = nullptr;
    QSettings* mSettings = nullptr;
    QList<Profile> profiles;

    void setSettings(QSettings* settings);
    void load();
    void save();
};
