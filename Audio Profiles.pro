QT += quick
LIBS += -lole32

SOURCES += \
    classes/AudioDevice.cpp \
    classes/DataFlowModel.cpp \
    main.cpp \
    classes/AudioDeviceModel.cpp \
    classes/AudioDevices.cpp \
    classes/ProfileModel.cpp
    

HEADERS += \
    classes/DataFlowModel.h \
    classes/AudioDevice.h \
    headers/PolicyConfig.h \
    classes/AudioDevices.h \
    classes/AudioDeviceModel.h \
    classes/ProfileModel.h

RESOURCES += main.qrc
RC_ICONS = images/icon.ico
QMAKE_TARGET_COPYRIGHT = Brandon Fowler

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
