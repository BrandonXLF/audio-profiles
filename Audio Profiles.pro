QT += quick axcontainer

SOURCES += \
    classes/AudioDevice.cpp \
    classes/DataFlowModel.cpp \
    main.cpp \
    classes/AudioDeviceModel.cpp \
    classes/AudioDevices.cpp \
    classes/ProfileModel.cpp

RESOURCES += \
    main.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    classes/DataFlowModel.h \
    classes/AudioDevice.h \
    headers/PolicyConfig.h \
    classes/AudioDevices.h \
    classes/AudioDeviceModel.h \
    classes/ProfileModel.h

RC_ICONS = images/icon.ico
