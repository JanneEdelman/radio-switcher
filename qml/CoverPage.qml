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
    property string icon2Gcover: "images/2G-cover-action.png"
    property string icon3Gcover: "images/3G-cover-action.png"
    property string icon4Gcover: "images/4G-cover-action.png"
    property string iconExit: "images/exit-icon.png"

    Image {
        id: title
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Theme.paddingLarge
        source: {
            switch(radioSettings.technologyPreference) {
            case "lte":
            case "any":
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

    Grid {
        id: statusView
        visible: !quitView.visible
        anchors.top: title.bottom
        anchors.left: cover.left
        anchors.right: cover.right
        anchors.margins: Theme.paddingMedium
        //anchors.horizontalCenter: parent.horizontalCenter
        clip: true
        rowSpacing: 2
        columnSpacing: Theme.paddingMedium
        columns: 2

        Label {
            height: operatorValue.height
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.highlightColor
            text: "Operator"
        }
        Label {
            id: operatorValue
            font.pixelSize: Theme.fontSizeSmall
            text: ((networkStatus !== "offline") && (networkStatus !== "no-sim")) ? networkName + " " : "---"
        }

        Label {
            height: networkValue.height
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.highlightColor
            text: "Network"
        }
        Label {
            id: networkValue
            font.pixelSize: Theme.fontSizeSmall
            text: ((networkStatus !== "offline") && (networkStatus !== "no-sim")) ? technology.toUpperCase() + " " : "---"
        }

        Label {
            height: signalValue.height
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.highlightColor
            text: "Signal"
        }
        Label {
            id: signalValue
            font.pixelSize: Theme.fontSizeSmall
            text: ((networkStatus !== "offline") && (networkStatus !== "no-sim")) ? sigStrength + " dBm" : "---";
        }

        Label {
            height: statusValue.height
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.highlightColor
            text: "Status"
        }
        Label {
            id: statusValue
            font.pixelSize: Theme.fontSizeSmall
            text: networkStatus + " "
        }
    }

    Label {
        id: connection
        visible: !quitView.visible
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: Theme.paddingSmall
        font.pixelSize: Theme.fontSizeExtraSmall
        color: Theme.highlightColor
        text: (connectionStatus !== "registered") ? connectionStatus : ""
    }


    Label {
        id: quitView
        visible: activeCount > 1
        //anchors.centerIn: parent
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            margins: Theme.paddingLarge
        }
        font.pixelSize: Theme.fontSizeSmall
        horizontalAlignment: Text.AlignHCenter
        text: "Radio Switcher\nVersion " + appVersion + "\n"
    }

    CoverActionList {
        id: coverAction
        enabled: activeCount == 1

        CoverAction {
            iconSource: (radioSettings.technologyPreference == "gsm") ? icon3Gcover : icon2Gcover
            onTriggered: {
                if(radioSettings.technologyPreference == "gsm") {
                    setupTechnologyPreference("umts")
                } else {
                    setupTechnologyPreference("gsm")
                }
            }
        }

        CoverAction {
            iconSource : (radioSettings.technologyPreference == "lte" || radioSettings.technologyPreference == "any") ? icon3Gcover : icon4Gcover
            onTriggered: {
                if(radioSettings.technologyPreference == "lte" || radioSettings.technologyPreference == "any") {
                    setupTechnologyPreference("umts")
                } else {
                    setupTechnologyPreference("any")
                }
            }
        }
    }

    CoverActionList {
        id: coverActionExit
        enabled: !coverAction.enabled

        CoverAction {
            iconSource : iconExit
            onTriggered: {
                Qt.quit();
            }
        }
    }
}
