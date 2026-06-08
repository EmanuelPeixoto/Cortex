import QtQuick
import Quickshell.Hyprland
import qs
import "components" as Components

Components.BarWidget {
  id: root
  property bool debug: false
  property var japaneseNumerals: ["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"]
  property var sortedModel: []

  implicitWidth: Math.max(60, wsRow.implicitWidth + 8)
  implicitHeight: 23
  color: "transparent"
  radius: 8

  Component.onCompleted: {
    Hyprland.refreshWorkspaces()
    Hyprland.refreshMonitors()
    updateModel()
  }

  Timer {
    interval: 500
    repeat: true
    running: true
    onTriggered: {
      if (root.sortedModel.length === 0) {
        Hyprland.refreshWorkspaces()
      }
      updateModel()
    }
  }

  function updateModel() {
    let all = []
    const src = Hyprland.workspaces

    if (src && src.values) {
      for (let i = 0; i < src.values.length; i++) {
        const ws = src.values[i]
        if (ws && ws.id > 0) all.push(ws)
      }
    } else if (src && typeof src.count !== "undefined" && typeof src.get === "function") {
      for (let i = 0; i < src.count; i++) {
        const ws = src.get(i)
        if (ws && ws.id > 0) all.push(ws)
      }
    } else if (Array.isArray(src)) {
      for (let i = 0; i < src.length; i++) {
        const ws = src[i]
        if (ws && ws.id > 0) all.push(ws)
      }
    }

    all.sort((a, b) => a.id - b.id)

    // only update if the workspace list changed (preserves animations)
    const changed = all.length !== root.sortedModel.length
      || all.some((ws, i) => ws.id !== root.sortedModel[i]?.id)

    if (changed) {
      if (root.debug) console.log("ws: updated", all.length, "workspaces")
      root.sortedModel = all
    }
  }

  Row {
    id: wsRow
    anchors.fill: parent
    spacing: Math.max(2, 10 - root.sortedModel.length)

    Repeater {
      model: root.sortedModel

      Item {
        required property var modelData
        width: wsRect.width
        height: wsRow.height

        Rectangle {
          id: wsRect
          property bool isActive: Hyprland.focusedMonitor
            && Hyprland.focusedMonitor.activeWorkspace
            && Hyprland.focusedMonitor.activeWorkspace.id === modelData.id

          width: {
            const n = root.sortedModel.length || 1
            const base = 300 / (n + 2.5)
            return isActive ? base * 2.5 : base
          }
          height: wsRow.height * 0.8
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
            text: root.japaneseNumerals[modelData.id] || modelData.id
            color: wsRect.isActive
              ? "#" + Globals.colors.colors.color1
              : "#" + Globals.colors.colors.color6
            font { family: Globals.font; pixelSize: 8; bold: true }
            anchors.centerIn: parent
          }

          MouseArea {
            cursorShape: Qt.PointingHandCursor
            anchors.fill: parent
            onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + modelData.id + " })")
          }
        }
      }
    }
  }
}
