import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "components" as Components

Item {
  id: wifiItem

  property string wifiIconSource: Quickshell.iconPath("network-wireless-signal-none")

  Process {
    id: wifiSignalProcess
    command: ["sh", "-c", "nmcli -t -f IN-USE,SIGNAL dev wifi | grep '^*' | cut -d: -f2"]
    stdout: SplitParser {
      onRead: data => {
        const signal = parseInt(data.trim());
        if (!isNaN(signal)) {
          let iconPath;
          if (signal >= 75) {
            iconPath = Quickshell.iconPath("network-wireless-signal-excellent");
          } else if (signal >= 50) {
            iconPath = Quickshell.iconPath("network-wireless-signal-good");
          } else if (signal >= 25) {
            iconPath = Quickshell.iconPath("network-wireless-signal-ok");
          } else if (signal >= 0) {
            iconPath = Quickshell.iconPath("network-wireless-signal-low");
          } else {
            iconPath = Quickshell.iconPath("network-wireless-signal-none");
          }
          wifiItem.wifiIconSource = iconPath;
        }
      }
    }
  }

  Layout.preferredHeight: 24
  Layout.preferredWidth: 24


  Components.SimpleImage {
    id: wifiIcon
    anchors.centerIn: parent
    source: wifiItem.wifiIconSource
    implicitHeight: 24
    implicitWidth: 24
  }

  Timer {
    id: wifiUpdateTimer
    interval: 4000
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: {
      wifiSignalProcess.running = true;
    }
  }
}
