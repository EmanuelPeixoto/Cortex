import QtQuick
import Quickshell.Hyprland

Row {
  anchors.verticalCenter: parent.verticalCenter
  spacing: 3

  Repeater {
    model: Hyprland.workspaces

    delegate: Item {
      width: textItem.paintedWidth + 10
      height: textItem.paintedHeight

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Hyprland.dispatch("workspace " + modelData.id)
      }

      Rectangle {
        width: parent.width
        height: parent.height
        radius: width/2
        color: modelData.id === Hyprland.focusedWorkspace.id ? "white" : "#2e2e2e"

        Text {
          id: textItem
          text: modelData.name
          anchors.horizontalCenter: parent.horizontalCenter
          color: modelData.id === Hyprland.focusedWorkspace.id ? "#2e2e2e" : "white"
        }
      }
    }
  }
}
