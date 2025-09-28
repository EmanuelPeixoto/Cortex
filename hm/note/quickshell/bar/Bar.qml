import QtQuick
import QtQuick.Layouts
import Quickshell
import Qt5Compat.GraphicalEffects
import Quickshell.Wayland
import "widgets" as Widgets
import qs

Variants {
  model: Quickshell.screens
  PanelWindow {
    id: root

    required property var modelData
    property int vertMargin: 3
    screen: modelData
    property color backgroundColor: Globals.backgroundColor

    WlrLayershell.namespace: "thorn"

    implicitHeight: 42
    implicitWidth: 44
    color: "transparent"

    anchors {
      top: true
      left: true
      right: true
    }

    Rectangle {
      id: bar
      anchors {
        fill: parent
        margins: 5
      }
      layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: -2
        verticalOffset: 2
        radius: 6
        spread: 0.2
        samples: 20
        color: "#30000000"
      }

      y: 10
      implicitWidth: Screen.width - 8
      implicitHeight: 42
      color: root.backgroundColor
      radius: 8
      layer.enabled: true
      layer.smooth: true
      layer.samples: 8

      Loader {
        anchors.fill: parent
        sourceComponent: horizontalLayoutComponent
      }
      Component {
        id: horizontalLayoutComponent

        RowLayout {
          anchors.fill: parent
          spacing: 0

          RowLayout {
            Layout.alignment: Qt.AlignLeft
            Layout.fillWidth: false
            Widgets.Power {
              Layout.fillWidth: true
              Layout.leftMargin: 8
            }
            Widgets.Workspaces {
              Layout.fillWidth: true

              Layout.alignment: Qt.AlignHCenter
              Layout.topMargin: -2
              Layout.leftMargin: 4
            }

            Widgets.ActiveWindow {
              layer.enabled: true
              Layout.fillHeight: true
              Layout.topMargin: -9
            }
          }

          Item {
            Layout.fillWidth: true
          }

          Item {
            Layout.fillWidth: true
          }

          RowLayout {
            Layout.alignment: Qt.AlignRight
            Layout.fillWidth: false

            Widgets.SystemTray {
              Layout.fillHeight: true
            }

            Widgets.PipewireCava {
              Layout.bottomMargin: 1.3
              Layout.rightMargin: 6
            }

            Widgets.Mpris {
              Layout.fillHeight: true
              Layout.topMargin: 2
              Layout.rightMargin: 6
            }
          }
        }
      }

      Component {
        id: verticalLayoutComponent

        ColumnLayout {
          anchors.fill: parent
          spacing: 0

          ColumnLayout {
            Layout.alignment: Qt.AlignTop
            Layout.fillHeight: false

            Widgets.Workspaces {
              Layout.topMargin: 2
              Layout.leftMargin: root.vertMargin
            }

            Widgets.Clock {
              Layout.topMargin: 250
              Layout.leftMargin: root.vertMargin
            }
          }

          Item {
            Layout.fillHeight: true
          }

          Item {
            Layout.fillHeight: true
          }
          Widgets.SystemTray {}

          ColumnLayout {
            Layout.alignment: Qt.AlignBottom
            Layout.fillHeight: false

            Item {
              Layout.fillWidth: true
            }
            Widgets.PipewireCava {}

            Widgets.Mpris {
              Layout.fillWidth: true
              Layout.leftMargin: root.vertMargin + 2
              // Layout.alignment: Qt.AlignHCenter
              Layout.bottomMargin: 60
            }
          }
        }
      }
    }
  }
}
