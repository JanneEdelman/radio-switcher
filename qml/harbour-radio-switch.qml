/*
  Copyright (C) 2014 Janne Edelman.
  Contact: Janne Edelman <janne.edelman@gmail.com>
  All rights reserved.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import MeeGo.QOfono 0.2
import org.freedesktop.contextkit 1.0


ApplicationWindow
{
    id: radioSwitcher
    cover: Component { CoverPage { id: cover } }

    property int activeCount: 0
    property string currentModem: manager.modems[0]
    property string sigStrengthLabel
    property int sigStrength
    property string networkStatus

    onApplicationActiveChanged: {
        if(radioSwitcher.applicationActive) {
            radioSwitcher.deactivate();
            activeCount++
            if(activeCount == 2) {
                quitCancel.restart();
            }
            if(activeCount > 2) {
                Qt.quit();
            }
        }
    }

    Timer {
        id: quitCancel
        interval: 5000
        running: false
        onTriggered: {
            activeCount = 1;
        }
    }

    OfonoManager { id: manager }

    OfonoRadioSettings {
        id: radioSettings
        modemPath: currentModem
    }

    function setupTechnologyPreference(selection) {
        radioSettings.technologyPreference = selection
        changetimer.start()
    }

    function retrieveAndShowData() {
        sigStrengthLabel = ""
        sigStrength = 0
        networkStatus = "offline"

        if ((status.value != "offline") && (offlineMode.value == "0")) {
            sigStrength = -(siganlStrength.value*31)/100
            networkStatus = status.value
        }
        switch(radioSettings.technologyPreference) {
        case "lte":
            sigStrengthLabel = "RSRP: "
            break
        case "umts":
            sigStrengthLabel = "RSCP: "
            break
        case "gsm":
            sigStrengthLabel = "RSSI: "
            break
        }
    }

    Timer {
        id: changetimer
        interval: 5000
        running: true
        repeat: false
        onTriggered: radioSwitcher.retrieveAndShowData()
    }

    ContextProperty {
        key: "Cellular.SignalStrength"
        id: siganlStrength
        value: "0"
        onValueChanged: radioSwitcher.retrieveAndShowData()
    }

    ContextProperty {
        key: "Cellular.RegistrationStatus"
        id: status
        value: "offline"
        onValueChanged: radioSwitcher.retrieveAndShowData()
    }

    ContextProperty {
        key: "System.OfflineMode"
        id: offlineMode
        value: "0"
        onValueChanged: radioSwitcher.retrieveAndShowData()
    }
}

