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

    property string appVersion: "0.2.2"
    property int activeCount: 0
    property string currentModem: manager.modems[0]
    property string sigStrengthLabel
    property int sigStrength
    property string technology
    property string networkName
    property string networkStatus
    property string connectionStatus

    onApplicationActiveChanged: {
        if(radioSwitcher.applicationActive) {
            radioSwitcher.deactivate();
            activeCount++
            if(activeCount > 1) {
                exitMenu.restart();
            }
        }
    }

    Timer {
        id: exitMenu
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

    OfonoNetworkRegistration {
        id: networkRegistration
        modemPath: currentModem

        onStatusChanged: {
            connectionStatus = status
        }
        onStrengthChanged: {
            radioSwitcher.retrieveAndShowData()
        }
        onTechnologyChanged: {
            radioSwitcher.retrieveAndShowData()
        }
    }

    function setupTechnologyPreference(selection) {
        radioSettings.technologyPreference = selection
        changetimer.start()
    }

    function retrieveAndShowData() {
        sigStrengthLabel = ""
        sigStrength = 0
        technology = ""
        networkName = ""
        networkStatus = "offline"

        // This is based on pretty random assumption about logic how RSSI/RSRP has been changed to percentange
        if ((status.value != "offline") && (offlineMode.value == "0")) {
            technology = networkRegistration.technology;
            switch(technology) {
            case "lte":
            case "any":
                sigStrengthLabel = "RSRP: "
                sigStrength = -137 + (siganlStrength.value * 92/100)
                break
            case "hspa":
            case "umts":
            case "edge":
            case "gsm":
                sigStrengthLabel = "RSSI: "
                sigStrength = -113 + (siganlStrength.value * 62/100)
                break
            }
            networkName = networkRegistration.name
            networkStatus = status.value
            connectionStatus = networkRegistration.status
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

