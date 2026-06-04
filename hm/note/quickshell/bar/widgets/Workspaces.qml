import QtQuick
import Quickshell.Hyprland
import qs
import "components" as Components

Components.BarWidget {
  id: root
  property var japaneseNumerals: ["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"]

  // cached workspace list to prevent disappearing during model resets
  property var cachedWorkspaces: []
  property int cachedActiveId: -1
  property int cachedCount: 0

  implicitWidth: calculateDynamicWidth()
  implicitHeight: 23
  color: "transparent"
  radius: 8

  function calculateDynamicWidth() {
    const count = root.cachedCount
    if (count <= 0) return 180
    const baseWidth = 300 / (count + 2.5)
    const totalWorkspaceWidth = baseWidth * (count + 1.5)
    const spacing = Math.max(2, 10 - count) * (count - 1)
    const padding = 10
    return Math.ceil(totalWorkspaceWidth + spacing + padding)
  }

  Behavior on implicitWidth {
    NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
  }

  Component.onCompleted: {
    Hyprland.refreshWorkspaces()
    Hyprland.refreshMonitors()
    updateCache()
  }

  function updateCache() {
    const all = Hyprland.workspaces.values || []
    // filter: only real workspaces (id > 0), exclude special (-99, -1, etc.)
    const valid = []
    let active = -1
    for (let i = 0; i < all.length; i++) {
      const ws = all[i]
      if (ws && ws.id > 0) {
        valid.push({ id: ws.id, name: ws.name || "" + ws.id })
        if (Hyprland.focusedMonitor &&
            Hyprland.focusedMonitor.activeWorkspace &&
            Hyprland.focusedMonitor.activeWorkspace.id === ws.id) {
          active = ws.id
        }
      }
    }
    // sort by id
    valid.sort((a, b) => a.id - b.id)

    // only update if we have real data (avoids flicker on empty)
    if (valid.length > 0) {
      root.cachedWorkspaces = valid
      root.cachedCount = valid.length
      root.cachedActiveId = active
    } else if (root.cachedWorkspaces.length === 0) {
      // first load with no workspaces: show 1
      root.cachedWorkspaces = [{ id: 1, name: "1" }]
      root.cachedCount = 1
      root.cachedActiveId = 1
    }
    // else: keep previous cache, don't flicker
  }

  // poll Hyprland workspace state (avoids fragile Connections to null targets)
  Timer {
    interval: 300
    repeat: true
    running: true
    onTriggered: updateCache()
  }

  // ── visual ──

  Row {
    id: workspaceRow
    anchors.fill: parent
    spacing: Math.max(2, 10 - root.cachedCount)

    Repeater {
      model: root.cachedWorkspaces

      Item {
        id: workspaceContainer
        required property var modelData
        width: wsRect.width
        height: workspaceRow.height

        Rectangle {
          id: wsRect
          property bool isActive: modelData.id === root.cachedActiveId

          width: {
            const n = root.cachedCount
            const base = 300 / (n + 2.5)
            return isActive ? base * 2.5 : base
          }
          height: workspaceRow.height * 0.8
          anchors.centerIn: parent
          radius: 10
          color: isActive
            ? "#" + Globals.colors.colors.color6
            : "#33" + Globals.colors.colors.color7

          Behavior on width {
            NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
          }
          Behavior on height {
            NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
          }

          Text {
            id: workspaceId
            text: root.japaneseNumerals[modelData.id] || modelData.id
            color: wsRect.isActive
              ? "#" + Globals.colors.colors.color1
              : "#" + Globals.colors.colors.color6
            font {
              family: Globals.font
              pixelSize: 8
              bold: true
            }
            anchors.centerIn: parent
          }

          MouseArea {
            cursorShape: Qt.PointingHandCursor
            anchors.fill: parent
            onClicked: Hyprland.dispatch("workspace " + modelData.id)
          }
        }
      }
    }
  }
}
