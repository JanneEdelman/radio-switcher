# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-radio-switch

CONFIG += sailfishapp

SOURCES += src/harbour-radio-switch.cpp

OTHER_FILES += qml/harbour-radio-switch.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/harbour-radio-switch.spec \
    rpm/harbour-radio-switch.yaml \
    harbour-radio-switch.desktop \
    qml/pages/CoverPage.qml \
    qml/CoverPage.qml \
    qml/images/2G-icon-86.png \
    qml/images/4G-icon-86.png \
    qml/images/3G-icon-86.png \
    qml/images/4G-cover-action.png \
    qml/images/3G-cover-action.png \
    qml/images/2G-cover-action.png \
    qml/images/exit-icon.png

RESOURCES +=

