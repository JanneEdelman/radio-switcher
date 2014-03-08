/*
  Copyright (C) 2014 Janne Edelman.
  Contact: Janne Edelman <janne.edelman@gmail.com>
  All rights reserved.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    id: cover
    property string icon2G: "images/2G-icon-86.png"
    property string icon3G: "images/3G-icon-86.png"
    property string icon4G: "images/4G-icon-86.png"

    Image {
        id: title
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Theme.paddingLarge
        source: {
            switch(radioSettings.technologyPreference) {
            case "lte":
                return icon4G
                break
            case "umts":
                return icon3G
                break
            case "gsm":
                return icon2G
                break
            default:
                return "image://theme/harbour-radio-switch"
            }
        }
    }

    Column {
        id: statusView
        visible: !quitView.visible
        anchors.top: title.bottom
        anchors.topMargin: Theme.paddingMedium
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 0

        Label {
            id: signalTitle
            //anchors.top: title.bottom
            anchors.topMargin: Theme.paddingMedium
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.highlightColor
            text: "Signal Strength"
        }
        Label {
            id: signalLabel
            //anchors.top: signalTitle.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.topMargin: Theme.paddingLarge*1.3
            font.pixelSize: Theme.fontSizeSmall
            text: sigStrengthLabel + sigStrength + " dBm"
        }
        Label {
            id: networkTitle
            //anchors.top: signalLabel.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Theme.paddingSmall
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.highlightColor
            text: "Network Status"
        }
        Label {
            id: networkLabel
            //anchors.top: networkTitle.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.topMargin: Theme.paddingLarge
            font.pixelSize: Theme.fontSizeSmall
            text: networkStatus
        }
    }

    Label {
        id: quitView
        visible: activeCount > 1
        anchors.centerIn: parent
        //anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: Theme.fontSizeSmall
        text: "Click again to quit"
    }

    CoverActionList {
        id: coverAction
        enabled: activeCount == 1

        CoverAction {
            iconSource: (radioSettings.technologyPreference == "gsm") ? icon3G : icon2G
            onTriggered: {
                if(radioSettings.technologyPreference == "gsm") {
                    setupTechnologyPreference("umts")
                } else {
                    setupTechnologyPreference("gsm")
                }
            }
        }

        CoverAction {
            iconSource : (radioSettings.technologyPreference == "lte") ? icon3G : icon4G
            onTriggered: {
                if(radioSettings.technologyPreference == "lte") {
                    setupTechnologyPreference("umts")
                } else {
                    setupTechnologyPreference("lte")
                }
            }
        }
    }
}
