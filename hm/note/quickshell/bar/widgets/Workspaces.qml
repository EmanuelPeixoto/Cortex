import QtQuick
import Quickshell.Hyprland
import qs
import "components" as Components

Components.BarWidget {
  id: root
  property var japaneseNumerals: ["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"]

  function calculateDynamicWidth() {

    const count = workspaceListView.count;

    if (count === 0)
    return 180;

    const baseWidth = 175 / (count + 2.5);
    const totalWorkspaceWidth = baseWidth * (count + 1.5);
    const spacing = Math.max(2, 10 - count) * (count - 1);
    const padding = 10;

    return Math.ceil(totalWorkspaceWidth + spacing + padding);
  }

  implicitWidth: calculateDynamicWidth()
  implicitHeight: 23

  color: "transparent"
  radius: 8

  Component.onCompleted: {
    Hyprland.refreshWorkspaces();
    Hyprland.refreshMonitors();
  }

  ListView {
    id: workspaceListView
    width: 180

    anchors {
      fill: parent
      topMargin: 0
    }

    orientation: ListView.Horizontal
    model: Hyprland.workspaces
    spacing: Math.max(2, 10 - count)
    clip: true

    delegate: Item {
      id: workspaceContainer

      property bool isValid: modelData.id > 0
      visible: isValid

      width: workspaceRect.width
      height: workspaceListView.height

      Rectangle {
        id: workspaceRect
        visible: workspaceContainer.isValid

        property bool isActive: Hyprland.focusedMonitor && Hyprland.focusedMonitor.activeWorkspace && Hyprland.focusedMonitor.activeWorkspace.id === modelData.id

        width: calculateWidth()
        height: calculateHeight() + 1
        anchors.centerIn: parent

        radius: 10
        color: isActive ? "#" + Globals.colors.colors.color6 : "#33" + Globals.colors.colors.color7

        function calculateWidth() {
          const totalWorkspaces = workspaceListView.count;
          const availableWidth = 175;
          const baseWidth = availableWidth / (totalWorkspaces + 2.5);
          return isActive ? baseWidth * 2.5 : baseWidth;
        }

        function calculateHeight() {
          return workspaceListView.height * 0.8;
        }

        Text {
          id: workspaceId
          text: root.japaneseNumerals[modelData.id] || modelData.id

          property bool isActive: Hyprland.focusedMonitor && Hyprland.focusedMonitor.activeWorkspace && Hyprland.focusedMonitor.activeWorkspace.id === modelData.id

          color: isActive ? "#" + Globals.colors.colors.color1 : "#" + Globals.colors.colors.color6
          font {
            family: Globals.font
            pixelSize: 10
            bold: true
          }
          anchors.centerIn: parent
        }

        MouseArea {
          cursorShape: Qt.PointingHandCursor
          anchors.fill: parent
          onClicked: Hyprland.dispatch("workspace " + modelData.id)
        }

        Behavior on width {
          NumberAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
          }
        }

        Behavior on height {
          NumberAnimation {
            duration: 200
            easing.type: Easing.InOutQuad
          }
        }
      }
    }
  }
}
