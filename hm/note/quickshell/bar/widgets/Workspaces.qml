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
      Hyprland.refreshWorkspaces()
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

          // reactive: accesses Hyprland monitor refs which trigger re-eval on workspace switch
          property bool isActive: {
            if (!modelData) return false
            const monitors = Hyprland.monitors.values
            const m0 = monitors[0]
            const m1 = monitors[1]
            const aw0 = m0 ? m0.activeWorkspace : null
            const aw1 = m1 ? m1.activeWorkspace : null
            return (aw0 && aw0.id === modelData.id) || (aw1 && aw1.id === modelData.id)
          }
          property int monitorId: modelData && modelData.monitor ? modelData.monitor.id : 0

          width: {
            const n = root.sortedModel.length || 1
            const base = 300 / (n + 2.5)
            return isActive ? base * 2.5 : base
          }
          height: wsRow.height * 0.8
          anchors.centerIn: parent
          radius: 10
          color: {
            if (isActive) {
              return monitorId === 0
                ? "#" + Globals.colors.colors.color6
                : "#" + Globals.colors.colors.color13
            }
            return monitorId === 0
              ? "#4d" + Globals.colors.colors.color7
              : "#4d" + Globals.colors.colors.color13
          }

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
