#include "AudioDevices.h"
#include "functiondiscoverykeys_devpkey.h"

AudioDevices::AudioDevices() : policyConfig(nullptr) {
    CoInitialize(nullptr);

    CoCreateInstance(
        __uuidof(MMDeviceEnumerator),
        NULL,
        CLSCTX_ALL,
        __uuidof(IMMDeviceEnumerator),
        (void**)&deviceEnum
    );

    populateDevices();
    populateDefaults();

    deviceEnum->RegisterEndpointNotificationCallback(this);
}

AudioDevices::~AudioDevices() {
    deviceEnum->UnregisterEndpointNotificationCallback(this);
    deviceEnum->Release();

    if (policyConfig)
        policyConfig->Release();

    for (auto& subDevices : devices)
        for (auto& device : subDevices)
            delete device;
}

void AudioDevices::populateDevices() {
    for (EDataFlow flow : flows) {
        IMMDeviceCollection* deviceCollection;
        UINT count;

        deviceEnum->EnumAudioEndpoints(flow, DEVICE_STATE_ACTIVE, &deviceCollection);
        deviceCollection->GetCount(&count);

        for (UINT i = 0; i < count; i++) {
            IMMDevice* winDevice;
            deviceCollection->Item(i, &winDevice);

            devices[flow] += new AudioDevice(this, flow, winDevice);

            winDevice->Release();
        }
    }
}

void AudioDevices::populateDefaults() {
    for (EDataFlow flow : flows)
        for (ERole role : roles)
            populateDefault(flow, role);
}

void AudioDevices::populateDefault(EDataFlow flow, ERole role) {
    IMMDevice* defaultDevice;
    LPWSTR deviceID;

    deviceEnum->GetDefaultAudioEndpoint(flow, role, &defaultDevice);
    defaultDevice->GetId(&deviceID);

    defaults[std::pair(flow, role)] = QString::fromWCharArray(deviceID);

    CoTaskMemFree(deviceID);
    defaultDevice->Release();
}

void AudioDevices::ensurePolicyConfig() {
    if (policyConfig) return;

    CoCreateInstance(
        CLSID_CPolicyConfigVistaClient,
        NULL,
        CLSCTX_ALL,
        IID_IPolicyConfigVista,
        (LPVOID*)&policyConfig
    );
}

HRESULT AudioDevices::QueryInterface(REFIID iid, void** object) {
    if (iid == IID_IUnknown || iid == __uuidof(IMMNotificationClient)) {
        *object = static_cast<IMMNotificationClient*>(this);
        return S_OK;
    }

    *object = NULL;
    return E_NOINTERFACE;
}

HRESULT AudioDevices::OnDefaultDeviceChanged(EDataFlow flow, ERole role, LPCWSTR deviceID) {
    // eMultimedia is same as eConsole
    if (role == eMultimedia)
        return S_OK;

    int oldIndex = -1;
    int newIndex = -1;

    for (int i = 0; i < devices[flow].length(); i++) {
        AudioDevice* device = devices[flow][i];

        if (device->deviceID == defaults[std::pair(flow, role)]) {
            oldIndex = i;
        }

        if (device->deviceID == QString::fromWCharArray(deviceID)) {
            newIndex = i;
        }

        if (oldIndex != -1 && newIndex !=- 1) break;
    }

    defaults[std::pair(flow, role)] = QString::fromWCharArray(deviceID);

    emit deviceUpdated(flow, oldIndex);
    emit deviceUpdated(flow, newIndex);

    return S_OK;
}

HRESULT AudioDevices::OnDeviceAdded(LPCWSTR deviceID) {
    // Handled by OnDeviceStateChanged

    return S_OK;
}

HRESULT AudioDevices::OnDeviceRemoved(LPCWSTR deviceID) {
    // Handled by OnDeviceStateChanged

    return S_OK;
}

HRESULT AudioDevices::OnDeviceStateChanged(LPCWSTR deviceID, DWORD state) {
    IMMDevice* winDevice;
    deviceEnum->GetDevice(deviceID, &winDevice);

    IMMEndpoint* endpoint;
    winDevice->QueryInterface(__uuidof(IMMEndpoint), (LPVOID*)&endpoint);

    EDataFlow flow;
    endpoint->GetDataFlow(&flow);

    if (state == DEVICE_STATE_ACTIVE) {
        emit beforeDeviceAdded(flow, 0);
        devices[flow].prepend(new AudioDevice(this, flow, winDevice));
        emit afterDeviceAdded(flow);
    } else {
        int index = -1;

        for (int i = 0; i < devices[flow].length(); i++)
            if (devices[flow][i]->deviceID == QString::fromWCharArray(deviceID)) {
                index = i;
                break;
            }

        if (index != -1) {
            emit beforeDeviceRemoved(flow, index);
            devices[flow].remove(index);
            emit afterDeviceRemoved(flow);
        }
    }

    winDevice->Release();

    return S_OK;
}

HRESULT AudioDevices::OnPropertyValueChanged(LPCWSTR deviceID, const PROPERTYKEY key) {
    if (key != PKEY_Device_FriendlyName) return S_OK;

    IMMDevice* winDevice;
    deviceEnum->GetDevice(deviceID, &winDevice);

    IMMEndpoint* endpoint;
    winDevice->QueryInterface(__uuidof(IMMEndpoint), (LPVOID*)&endpoint);

    EDataFlow flow;
    endpoint->GetDataFlow(&flow);

    int index = -1;

    for (int i = 0; i < devices[flow].length(); i++) {
        if (devices[flow][i]->deviceID == QString::fromWCharArray(deviceID)) {
            index = i;
            break;
        }
    }

    IPropertyStore* propStore;
    winDevice->OpenPropertyStore(STGM_READ, &propStore);

    PROPVARIANT friendlyName;
    PropVariantInit(&friendlyName);
    propStore->GetValue(PKEY_Device_FriendlyName, &friendlyName);

    devices[flow][index]->name = QString::fromWCharArray(friendlyName.pwszVal);

    propStore->Release();
    winDevice->Release();

    emit deviceUpdated(flow, index);

    return S_OK;
}

void AudioDevices::markDeviceAsUpdated(AudioDevice* device) {
    int index = -1;

    for (int i = 0; i < devices[device->flow].length(); i++) {
        if (devices[device->flow][i] == device) {
            index = i;
            break;
        }
    }

    emit deviceUpdated(device->flow, index);
}

int AudioDevices::getCount(EDataFlow flow) {
    return devices[flow].size();
}

AudioDevice* AudioDevices::getDeviceByIndex(EDataFlow flow, int index) {
    return devices[flow][index];
}

bool AudioDevices::isDefaultDevice(ERole role, AudioDevice* device) {
    return defaults[std::pair(device->flow, role)] == device->deviceID;
}

void AudioDevices::setDefaultDevice(ERole role, AudioDevice* device) {
    ensurePolicyConfig();

    policyConfig->SetDefaultEndpoint((LPWSTR)device->deviceID.utf16(), role);
}

 QHash<std::pair<EDataFlow, ERole>, QString> AudioDevices::getDefaults() {
    return defaults;
}

void AudioDevices::setDefaults(QHash<std::pair<EDataFlow, ERole>, QString> newDefaults) {
    ensurePolicyConfig();

    for (auto [flowRole, deviceID] : newDefaults.asKeyValueRange())
        policyConfig->SetDefaultEndpoint((LPWSTR)deviceID.utf16(), flowRole.second);
}
