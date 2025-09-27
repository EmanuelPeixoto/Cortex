pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property bool notificationsEnabled: true
    property var date: new Date()
    readonly property string font: "MesloLGS Nerd Font"
    readonly property bool toolTip: true
    readonly property color backgroundColor: "#BB" + colors.colors.color0
    readonly property var popupContext: PopupContext {}
    readonly property string homeDir: Quickshell.env("HOME")
    readonly property string cacheDir: Quickshell.env("XDG_CACHE_HOME")

    readonly property var fallbackColors: ({
            "colors": {
                "color0": "181818",
                "color1": "3f425e",
                "color2": "5d463e",
                "color3": "5a4c73",
                "color4": "906070",
                "color5": "b1948a",
                "color6": "c8c1ad",
                "color7": "c5c5c5",
                "color8": "515151",
                "color9": "3f425e",
                "color10": "5d463e",
                "color11": "5a4c73",
                "color12": "906070",
                "color13": "b1948a",
                "color14": "c8c1ad",
                "color15": "c5c5c5"
            }
        })

    readonly property var colors: colorManager.colorsLoaded ? colorManager.currentColors : fallbackColors

    property var colorComponents: []

    QtObject {
        id: colorManager
        property var currentColors: ({})
        property bool colorsLoaded: false

        property FileView colorFile: FileView {
            path: Qt.resolvedUrl(root.homeDir + "/.config/stylix/palette.json")
            preload: true
            watchChanges: true
            onFileChanged: {
                colorManager.reloadColors();
            }
            onLoaded: {
                colorManager.reloadColors();
            }
        }

        function reloadColors() {
            colorFile.reload();
            try {
                if (!colorFile.text()) {
                    return;
                }
                const palette = JSON.parse(colorFile.text());
                const newColors = { "colors": {} };

                // Map base16 colors to the application's color scheme
                newColors.colors.color0 = palette.base00;
                newColors.colors.color1 = palette.base01;
                newColors.colors.color2 = palette.base02;
                newColors.colors.color3 = palette.base03;
                newColors.colors.color4 = palette.base04;
                newColors.colors.color5 = palette.base05;
                newColors.colors.color6 = palette.base06;
                newColors.colors.color7 = palette.base07;
                newColors.colors.color8 = palette.base08;
                newColors.colors.color9 = palette.base09;
                newColors.colors.color10 = palette.base0A;
                newColors.colors.color11 = palette.base0B;
                newColors.colors.color12 = palette.base0C;
                newColors.colors.color13 = palette.base0D;
                newColors.colors.color14 = palette.base0E;
                newColors.colors.color15 = palette.base0F;

                currentColors = newColors;
                colorsLoaded = true;
            } catch (e) {
                colorsLoaded = false;
            }
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: root.date = new Date()
    }

    signal colorReloadRequested
    onColorReloadRequested: {
        colorManager.reloadColors();
    }

    function reloadColors() {
        colorManager.reloadColors();
    }

    Component.onCompleted: {
        colorManager.reloadColors();
    }
}
