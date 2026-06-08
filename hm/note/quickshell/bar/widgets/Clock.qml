import QtQuick
import QtQuick.Layouts
import qs

Item {
  id: root
  property bool horizontal: true
  implicitWidth: horizontal ? timeText.implicitWidth + 16 : 42
  implicitHeight: horizontal ? 24 : clockLayout.height + 16
  readonly property var colors: Globals.colors.colors

  Rectangle {
    id: clockBox
    anchors.centerIn: parent
    width: root.horizontal ? parent.width - 4 : parent.width - 14
    height: root.horizontal ? parent.height - 4 : parent.height
    color: "#44" + colors.color0
    radius: 6

    // ── horizontal: single line "14:30" ──
    Text {
      id: timeText
      visible: root.horizontal
      anchors.centerIn: parent
      text: "00:00"
      font.family: Globals.font
      font.pixelSize: 13
      font.bold: true
      color: "#" + colors.color6
    }

    // ── vertical: stacked hours / minutes ──
    ColumnLayout {
      id: clockLayout
      visible: !root.horizontal
      anchors.centerIn: parent
      spacing: 0

      Text {
        id: hourText
        Layout.alignment: Qt.AlignHCenter
        text: "00"
        font.family: Globals.font
        font.pixelSize: 18
        color: "#" + colors.color6
      }

      Text {
        id: minuteText
        Layout.alignment: Qt.AlignHCenter
        text: "00"
        font.family: Globals.font
        font.pixelSize: 16
        color: "#" + colors.color4
      }
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: updateTime()
  }

  Component.onCompleted: updateTime()

  function updateTime() {
    var now = new Date();
    var hours = now.getHours();
    var minutes = now.getMinutes();

    hourText.text = hours.toString().padStart(2, '0');
    minuteText.text = minutes.toString().padStart(2, '0');
    timeText.text = hours.toString().padStart(2, '0') + ":" + minutes.toString().padStart(2, '0');
  }
}
