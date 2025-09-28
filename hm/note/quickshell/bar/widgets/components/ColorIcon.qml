pragma ComponentBehavior: Bound
import QtQuick
import Qt5Compat.GraphicalEffects
import Quickshell.Widgets
import qs

Item {
  id: root
  required property var implicitSize
  required property var source
  property bool hovered: false

  width: implicitSize
  height: implicitSize

  IconImage {
    id: iconImage
    anchors.fill: parent
    source: root.source
  }
}
