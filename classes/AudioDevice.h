#pragma once
#include <QString>
#include <mmdeviceapi.h>
#include <endpointvolume.h>

class AudioDevices;

class AudioDevice : public IAudioEndpointVolumeCallback {
public:
    AudioDevice(AudioDevices* parent, EDataFlow flow, IMMDevice* winDevice);
    virtual ~AudioDevice();

    AudioDevices* parent = nullptr;
    EDataFlow flow;
    QString deviceID;
    QString name;
    IAudioEndpointVolume* endpointVolume = nullptr;
    float volume;
    BOOL muted;

    void setVolume(float volume);
    void setMute(bool mute);

    // IUnknown
    ULONG AddRef() { return 1; }
    ULONG Release() { return 1; }
    HRESULT QueryInterface(REFIID iid, LPVOID* object);

    // IAudioEndpointVolumeCallback
    HRESULT OnNotify(PAUDIO_VOLUME_NOTIFICATION_DATA notify);
};
