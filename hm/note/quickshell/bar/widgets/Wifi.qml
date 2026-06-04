import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import "components" as Components
import qs

Components.BarWidget {
  id: root
  color: "transparent"
  implicitHeight: 24
  implicitWidth: 24

  property string wifiIconSource: Quickshell.iconPath("network-wireless-signal-none")
  property string currentSsid: ""
  property int currentSignal: 0
  property string currentSecurity: ""
  property var networks: []
  property var savedSsids: []
  property bool connected: false
  property color backgroundColor: Globals.backgroundColor

  function iconForStrength(signal) {
    if (signal >= 75) return Quickshell.iconPath("network-wireless-signal-excellent")
    if (signal >= 50) return Quickshell.iconPath("network-wireless-signal-good")
    if (signal >= 25) return Quickshell.iconPath("network-wireless-signal-ok")
    if (signal > 0)  return Quickshell.iconPath("network-wireless-signal-low")
    return Quickshell.iconPath("network-wireless-signal-none")
  }

  function securityIcon(sec) {
    if (!sec || sec === "" || sec === "--") return ""
    return " \uD83D\uDD12"
  }

  function refreshWifi() {
    scanBuffer = []
    root.savedSsids = []
    root.connected = false
    root.networks = []
    scanProcess.running = true
    savedProcess.running = true
  }

  property var scanBuffer: []

  // ── scan networks ──────────────────────────────────

  Process {
    id: scanProcess
    running: false
    command: ["sh", "-c", "nmcli -t -f SSID,SIGNAL,SECURITY,IN-USE dev wifi list 2>&1"]

    stdout: SplitParser {
      onRead: line => {
        const t = line.trim()
        if (t) root.scanBuffer.push(t)
      }
    }

    onRunningChanged: {
      if (!running && root.scanBuffer.length > 0) {
        parseScanResults(root.scanBuffer)
      }
    }
  }

  function parseScanResults(lines) {
    // console.log("wifi: processing", lines.length, "lines")
    let nets = []
    let foundConnected = false
    for (const line of lines) {
      const parts = line.split(":")
      if (parts.length < 3) continue
      const inuse = parts[3] && parts[3].trim() === "*"
      const ssid = parts[0] && parts[0].trim() || "(hidden)"
      const signal = parseInt(parts[1]) || 0
      const security = parts[2] && parts[2].trim() || "--"
      const net = { ssid, signal, security, connected: inuse }
      const existing = nets.find(n => n.ssid === net.ssid)
      if (existing) {
        if (net.signal > existing.signal) existing.signal = net.signal
        if (net.connected) existing.connected = true
      } else {
        nets.push(net)
      }
      if (inuse) {
        foundConnected = true
        root.connected = true
        root.currentSsid = ssid
        root.currentSignal = signal
        root.wifiIconSource = iconForStrength(signal)
      }
    }
    nets.sort((a, b) => b.signal - a.signal)
    root.networks = nets.slice(0, 20)
    console.log("wifi: networks set, count:", root.networks.length, "connected:", foundConnected)

    if (!foundConnected) {
      root.connected = false
      connectionCheckProcess.running = true
    }
  }

  // ── fallback connection check (wired / hidden ssid) ─

  Process {
    id: connectionCheckProcess
    command: ["sh", "-c",
      "nmcli -t -f GENERAL.CONNECTION,DEVICE,TYPE connection show --active 2>/dev/null | head -5"
    ]
    stdout: SplitParser {
      onRead: data => {
        const lines = data.trim().split("\n").filter(l => l)
        let found = false
        for (let line of lines) {
          const [key, val] = line.split(":", 2)
          if (val && val.toLowerCase() !== "lo" && val !== "--") {
            root.connected = true
            root.currentSsid = val
            found = true
            break
          }
        }
        if (!found) {
          root.connected = false
          root.wifiIconSource = Quickshell.iconPath("network-wireless-signal-none")
        }
      }
    }
  }

  // ── connect to network ─────────────────────────────

  property string pendingSsid: ""
  property string pendingSecurity: ""
  property bool showPasswordInput: false

  function connectToNetwork(ssid, security) {
    root.pendingSsid = ssid
    root.pendingSecurity = security
    // try without password first — nmcli uses saved credentials
    connectProcess.command = ["sh", "-c",
      "nmcli dev wifi connect '" + ssid.replace(/'/g, "'\\''") + "' 2>&1"
    ]
    connectProcess.running = true
  }

  function submitPassword() {
    const pw = passInput.text
    connectProcess.command = ["sh", "-c",
      "nmcli dev wifi connect '" + root.pendingSsid.replace(/'/g, "'\\''") +
      "' password '" + pw.replace(/'/g, "'\\''") + "' 2>&1"
    ]
    connectProcess.running = true
    root.showPasswordInput = false
    passInput.text = ""
  }

  Process {
    id: connectProcess
    command: []
    running: false
    stdout: SplitParser {
      onRead: data => {
        const txt = data.trim()
        console.log("wifi: connect stdout:", txt)
        if (txt.indexOf("successfully") >= 0 || txt.indexOf("Error") < 0) {
          root.showPasswordInput = false
        }
        root.refreshWifi()
      }
    }
    stderr: SplitParser {
      onRead: data => {
        const txt = data.trim()
        console.log("wifi: connect stderr:", txt)
        // if secrets required, show password input
        if (txt.indexOf("Secrets") >= 0 || txt.indexOf("password") >= 0 || txt.indexOf("No valid") >= 0) {
          root.showPasswordInput = true
        } else if (txt.indexOf("Error") >= 0 || txt.indexOf("failure") >= 0) {
          root.showPasswordInput = true
        }
      }
    }
  }

  // ── disconnect ─────────────────────────────────────

  Process {
    id: disconnectProcess
    command: []
    stdout: SplitParser {
      onRead: data => {
        root.refreshWifi()
      }
    }
  }

  function disconnect() {
    disconnectProcess.command = ["sh", "-c",
      "nmcli dev disconnect wlan0 2>&1 || nmcli dev disconnect wlp0s20f3 2>&1 || " +
      "IFACE=$(nmcli -t -f DEVICE,TYPE dev | grep ':wifi$' | cut -d: -f1 | head -1) && " +
      "[ -n \"$IFACE\" ] && nmcli dev disconnect \"$IFACE\""
    ]
    disconnectProcess.running = true
  }

  // ── fetch saved connections ────────────────────────

  Process {
    id: savedProcess
    running: false
    command: ["sh", "-c", "nmcli -t -f NAME,TYPE connection show 2>/dev/null | grep ':802-11-wireless$' | cut -d: -f1"]
    stdout: SplitParser {
      onRead: line => {
        const t = line.trim()
        if (t && root.savedSsids.indexOf(t) < 0) {
          root.savedSsids.push(t)
        }
      }
    }
  }

  // ── UI: icon + popup ───────────────────────────────

  Components.IconButton {
    id: wifiBtn
    anchors.centerIn: parent
    icon: root.connected ? "network-wireless-signal-excellent-symbolic" : "network-wireless-signal-none-symbolic"
    size: 16
    outerSize: 20
    clickable: true
    onClicked: {
      root.refreshWifi()
      wifiPopup.show()
      wifiGrab.active = true
    }
  }

  HyprlandFocusGrab {
    id: wifiGrab
    windows: [wifiPopup]
    onCleared: {
      wifiPopup.closeWithAnimation()
    }
  }

  Components.SlidingPopup {
    id: wifiPopup
    anchor {
      item: root
      margins.top: -14
      edges: Edges.Right
      gravity: Edges.Bottom
    }
    implicitWidth: 280
    implicitHeight: Math.min(450, headerCol.implicitHeight + networkList.contentHeight + 20)
    visible: false
    color: "transparent"

    Rectangle {
      anchors.fill: parent
      anchors.margins: 10
      color: root.backgroundColor
      radius: 14
      border.width: 1
      border.color: "#44" + Globals.colors.colors.color4

      ColumnLayout {
        id: headerCol
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        // ── header ──
        RowLayout {
          Layout.fillWidth: true
          spacing: 8

          Text {
            text: "Wi-Fi"
            font.family: Globals.font
            font.pixelSize: 16
            font.bold: true
            color: "#" + Globals.colors.colors.color6
          }

          Item { Layout.fillWidth: true }

          Components.IconButton {
            icon: "view-refresh-symbolic"
            size: 14
            outerSize: 18
            clickable: true
            onClicked: root.refreshWifi()
          }
        }

        // ── current connection ──
        Rectangle {
          visible: root.connected
          Layout.fillWidth: true
          Layout.preferredHeight: 32
          radius: 8
          color: root.connected ? "#22" + Globals.colors.colors.color11 : "transparent"

          RowLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 8

            Components.SimpleImage {
              source: iconForStrength(root.currentSignal)
              size: 16
              implicitWidth: 16
              implicitHeight: 16
            }

            Text {
              text: root.currentSsid
              font.family: Globals.font
              font.pixelSize: 13
              font.bold: true
              color: "#" + Globals.colors.colors.color6
              Layout.fillWidth: true
              elide: Text.ElideRight
            }

            Text {
              text: "✓"
              font.pixelSize: 12
              color: "#" + Globals.colors.colors.color11
            }
          }
        }

        // ── password input (shown when connecting to secured network) ──
        ColumnLayout {
          visible: root.showPasswordInput
          Layout.fillWidth: true
          spacing: 8

          Text {
            text: "Enter password for " + root.pendingSsid
            font.family: Globals.font
            font.pixelSize: 12
            color: "#" + Globals.colors.colors.color6
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
          }

          Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 32
            radius: 6
            color: "#22" + Globals.colors.colors.color0
            border.width: 1
            border.color: "#44" + Globals.colors.colors.color4

            TextInput {
              id: passInput
              anchors.fill: parent
              anchors.margins: 8
              font.family: Globals.font
              font.pixelSize: 12
              color: "#" + Globals.colors.colors.color6
              echoMode: TextInput.Password
              focus: true
              Keys.onReturnPressed: root.submitPassword()
            }
          }

          RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Item { Layout.fillWidth: true }

            Rectangle {
              Layout.preferredWidth: 70
              Layout.preferredHeight: 26
              radius: 6
              color: cancelPwHover.containsMouse ? "#33" + Globals.colors.colors.color8 : "#18" + Globals.colors.colors.color0

              Text {
                anchors.centerIn: parent
                text: "Cancel"
                font.family: Globals.font
                font.pixelSize: 11
                color: "#" + Globals.colors.colors.color6
              }
              MouseArea {
                id: cancelPwHover
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                  root.showPasswordInput = false
                  passInput.text = ""
                }
              }
            }

            Rectangle {
              Layout.preferredWidth: 70
              Layout.preferredHeight: 26
              radius: 6
              color: connectPwHover.containsMouse ? "#55" + Globals.colors.colors.color11 : "#22" + Globals.colors.colors.color11

              Text {
                anchors.centerIn: parent
                text: "Connect"
                font.family: Globals.font
                font.pixelSize: 11
                font.bold: true
                color: "#" + Globals.colors.colors.color6
              }
              MouseArea {
                id: connectPwHover
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: root.submitPassword()
              }
            }
          }
        }

        // ── scan indicator ──
        Text {
          visible: !root.showPasswordInput && root.networks.length === 0
          text: root.connected ? "Already connected" : "Scanning..."
          font.family: Globals.font
          font.pixelSize: 12
          color: "#88" + Globals.colors.colors.color7
          Layout.fillWidth: true
        }

        // ── network list ──
        ListView {
          id: networkList
          visible: !root.showPasswordInput
          Layout.fillWidth: true
          Layout.fillHeight: true
          clip: true
          model: root.networks
          spacing: 2

          delegate: Rectangle {
            width: networkList.width
            height: 36
            radius: 6
            color: netMouse.containsMouse ? "#22" + Globals.colors.colors.color2 : "transparent"

            required property var modelData
            required property int index

            RowLayout {
              anchors.fill: parent
              anchors.margins: 6
              spacing: 8

              Components.SimpleImage {
                source: iconForStrength(modelData.signal)
                size: 14
                implicitWidth: 14
                implicitHeight: 14
              }

              Text {
                text: modelData.ssid
                font.family: Globals.font
                font.pixelSize: 12
                color: modelData.connected
                  ? "#" + Globals.colors.colors.color11
                  : "#" + Globals.colors.colors.color6
                Layout.fillWidth: true
                elide: Text.ElideRight
              }

              Text {
                visible: !modelData.connected && modelData.security && modelData.security !== "--"
                text: "🔓"
                font.pixelSize: 10
              }

              Text {
                visible: !modelData.connected && root.savedSsids.indexOf(modelData.ssid) >= 0
                text: "★"
                font.pixelSize: 10
                color: "#" + Globals.colors.colors.color9
              }
            }

            MouseArea {
              id: netMouse
              anchors.fill: parent
              cursorShape: Qt.PointingHandCursor
              hoverEnabled: true
              onClicked: {
                if (modelData.connected) {
                  root.disconnect()
                } else {
                  root.connectToNetwork(modelData.ssid, modelData.security)
                }
                // keep popup open for password input (showPasswordInput handles this)
                if (!modelData.security || modelData.security === "--" || modelData.connected) {
                  wifiPopup.closeWithAnimation()
                }
              }
            }
          }
        }
      }
    }
  }

  // ── auto-refresh timer ─────────────────────────────

  Timer {
    id: wifiUpdateTimer
    interval: 15000
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: root.refreshWifi()
  }
}
