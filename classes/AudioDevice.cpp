#include "audiodevice.h"
#include "audiodevices.h"
#include "functiondiscoverykeys_devpkey.h"

AudioDevice::AudioDevice(AudioDevices* parent, EDataFlow flow, IMMDevice* winDevice) {
    this->parent = parent;
    this->flow = flow;

    IPropertyStore* propStore;
    winDevice->OpenPropertyStore(STGM_READ, &propStore);

    PROPVARIANT friendlyName;
    PropVariantInit(&friendlyName);
    propStore->GetValue(PKEY_Device_FriendlyName, &friendlyName);

    this->name = QString::fromWCharArray(friendlyName.pwszVal);

    propStore->Release();

    LPWSTR deviceID;
    winDevice->GetId(&deviceID);

    this->deviceID = QString::fromWCharArray(deviceID);
    CoTaskMemFree(deviceID);

    winDevice->Activate(
        __uuidof(IAudioEndpointVolume),
        CLSCTX_INPROC_SERVER,
        NULL,
        (LPVOID*)&this->endpointVolume
    );

    this->endpointVolume->GetMasterVolumeLevelScalar(&this->volume);
    this->endpointVolume->GetMute(&this->muted);
    this->endpointVolume->RegisterControlChangeNotify(this);
}

AudioDevice::~AudioDevice() {
    this->endpointVolume->UnregisterControlChangeNotify(this);
    this->endpointVolume->Release();
}

void AudioDevice::setVolume(float volume) {
    endpointVolume->SetMasterVolumeLevelScalar(volume, NULL);
}

void AudioDevice::setMute(bool mute) {
    endpointVolume->SetMute((BOOL)mute, NULL);
}

HRESULT AudioDevice::QueryInterface(REFIID iid, LPVOID* object) {
    if (iid == IID_IUnknown || iid == __uuidof(IAudioEndpointVolumeCallback)) {
        *object = static_cast<IAudioEndpointVolumeCallback*>(this);
        return S_OK;
    }

    *object = NULL;
    return E_NOINTERFACE;
}

HRESULT AudioDevice::OnNotify(PAUDIO_VOLUME_NOTIFICATION_DATA notify) {
    volume = notify->fMasterVolume;
    muted = notify->bMuted;

    parent->markDeviceAsUpdated(this);

    return S_OK;
}
