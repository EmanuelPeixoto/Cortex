import Quickshell
import QtQuick

Scope {
  Variants {
    model: Quickshell.screens;

    PanelWindow {
      property var modelData
      screen: modelData

      anchors {
        bottom: true
        left: true
        right: true
      }

      implicitHeight: 20

      Rectangle {
        anchors.fill: parent
        color: "black"
        z: -1
      }

      WorkspaceWidget {
        anchors.verticalCenter: parent.verticalCenter
        anchors.top: parent.top
        anchors.leftMargin: 1
      }
      ClockWidget {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 1
      }
    }
  }
}
