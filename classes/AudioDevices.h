#pragma once
#include <QObject>
#include <QString>
#include <QHash>
#include <QVector>
#include <utility>
#include <mutex>
#include <endpointvolume.h>
#include <mmdeviceapi.h>
#include "../headers/PolicyConfig.h"
#include "audiodevice.h"

class AudioDevices : public QObject, IMMNotificationClient {
    Q_OBJECT

private:
    IMMDeviceEnumerator* deviceEnum = nullptr;
    IPolicyConfigVista* policyConfig = nullptr;
    QHash<std::pair<EDataFlow, ERole>, QString> defaults;
    QHash<EDataFlow, QList<AudioDevice*>> devices;

    void populateDevices();
    void populateDefaults();
    void populateDefault(EDataFlow flow, ERole role);

    void ensurePolicyConfig();

    // IUnknown
    ULONG AddRef() { return 1; }
    ULONG Release() { return 1; }
    HRESULT QueryInterface(REFIID iid, LPVOID* object);

    // IMMNotificationClient
    HRESULT OnDefaultDeviceChanged(EDataFlow flow, ERole role, LPCWSTR deviceID);
    HRESULT OnDeviceAdded(LPCWSTR deviceID);
    HRESULT OnDeviceRemoved(LPCWSTR deviceID);
    HRESULT OnDeviceStateChanged(LPCWSTR deviceID, DWORD state);
    HRESULT OnPropertyValueChanged(LPCWSTR deviceID, const PROPERTYKEY key);

public:
    AudioDevices();
    ~AudioDevices();

    const QList<EDataFlow> flows = { eRender, eCapture };
    const QList<ERole> roles = { eConsole, eCommunications };

    int getCount(EDataFlow flow);
    AudioDevice* getDeviceByIndex(EDataFlow flow, int index);

    bool isDefaultDevice(ERole role, AudioDevice* device);
    void setDefaultDevice(ERole role, AudioDevice* device);
    QHash<std::pair<EDataFlow, ERole>, QString> getDefaults();
    void setDefaults(QHash<std::pair<EDataFlow, ERole>, QString> newDefaults);

    void markDeviceAsUpdated(AudioDevice* device);

signals:
    void deviceUpdated(EDataFlow flow, int index);

    void beforeDeviceAdded(EDataFlow flow, int index);
    void afterDeviceAdded(EDataFlow flow);

    void beforeDeviceRemoved(EDataFlow flow, int index);
    void afterDeviceRemoved(EDataFlow flow);
};
