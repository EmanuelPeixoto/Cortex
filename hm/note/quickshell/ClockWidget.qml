import QtQuick

Rectangle {
  width: textItem.paintedWidth + 10
  height: textItem.paintedHeight
  radius: width/height
  color: "#2e2e2e"

  Text {
    id: textItem
    text: Time.time
    color: "white"
    anchors.centerIn: parent
  }
}
