#include "ProfileModel.h"

ProfileModel::ProfileModel(QObject *parent) : QAbstractListModel(parent), mSettings(nullptr) { }

int ProfileModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid())
        return 0;

    return profiles.length();
}

QVariant ProfileModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid())
        return QVariant();

    switch (role) {
        case NameRole:
            return profiles[index.row()].name;
    }

    return QVariant();
}

bool ProfileModel::setData(const QModelIndex &index, const QVariant &value, const int role) {
    if (!index.isValid())
        return false;

    switch (role) {
        case NameRole:
            profiles[index.row()].name = value.toString();
            emit dataChanged(index, index);

            save();
            return true;
    }

    return false;
}

QHash<int, QByteArray> ProfileModel::roleNames() const {
    QHash<int, QByteArray> names;

    names[NameRole] = "name";

    return names;
}

void ProfileModel::newProfile(QString name) {
    beginInsertRows(QModelIndex(), profiles.length(), profiles.length());

    Profile profile;
    profile.name = name;
    profile.defaults = mDevices->getDefaults();
    profiles.append(profile);

    endInsertRows();

    save();
}

void ProfileModel::updateProfile(int index) {
    profiles[index].defaults = mDevices->getDefaults();
    save();
}

void ProfileModel::loadProfile(int index) {
    mDevices->setDefaults(profiles[index].defaults);
}

void ProfileModel::deleteProfile(int index) {
    beginRemoveRows(QModelIndex(), index, index);
    profiles.remove(index);
    endRemoveRows();

    save();
}

void ProfileModel::setSettings(QSettings* settings) {
    mSettings = settings;
    load();
}

void ProfileModel::load() {
    if (!mSettings) return;

    profiles.clear();

    int size = mSettings->beginReadArray("profiles");

    for (int i = 0; i < size; ++i) {
        mSettings->setArrayIndex(i);

        QHash<std::pair<EDataFlow, ERole>, QString> defaults;
        QList<QVariant> storableDefaults = mSettings->value("defaults").toList();

        for (const QVariant &storableDefault : storableDefaults) {
            QStringList keyParts = storableDefault.value<QString>().split(u'/');

            std::pair key = std::pair(
                static_cast<EDataFlow>(keyParts[0].toInt()),
                static_cast<ERole>(keyParts[1].toInt())
            );

            defaults[key] = keyParts[2];
        }

        Profile profile;
        profile.name = mSettings->value("name").toString();
        profile.defaults = defaults;

        profiles.append(profile);
    }

    mSettings->endArray();
}

void ProfileModel::save() {
    if (!mSettings) return;

    mSettings->beginWriteArray("profiles");

    for (int i = 0; i < profiles.size(); i++) {
        mSettings->setArrayIndex(i);
        mSettings->setValue("name", profiles[i].name);

        QList<QString> storableDefaults;

        for (auto [flowRole, deviceID] : profiles[i].defaults.asKeyValueRange()) {
            QString defaultInfo;

            defaultInfo.append(QString::number(flowRole.first));
            defaultInfo.append("/");
            defaultInfo.append(QString::number(flowRole.second));
            defaultInfo.append("/");
            defaultInfo.append(deviceID);

            storableDefaults += defaultInfo;
        }

        mSettings->setValue("defaults", storableDefaults);
    }

    mSettings->endArray();
}
