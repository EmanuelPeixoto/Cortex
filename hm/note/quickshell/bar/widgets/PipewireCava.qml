import QtQuick
import Quickshell
import QtQuick.Controls
import "components" as Components
import qs
import "services" as Service

Components.BarWidget {
  id: root
  color: "transparent"
  property date selectedDate: Globals.date
  property var focusManager: Service.FocusManager

  implicitWidth: button.width
  implicitHeight: button.height + 4

  Components.BarTooltip {
    relativeItem: mouseAreaButton.containsMouse ? hoverBackground : null
    offset: 2

    Label {
      font.family: Globals.font
      font.pixelSize: 11
      font.hintingPreference: Font.PreferFullHinting
      color: "white"
      text: "Pipewire"
    }
  }
  Button {
    id: button
    anchors.centerIn:  parent
    width: 50
    height: 22
    hoverEnabled: true
    background: null

    Rectangle {
      id: hoverBackground
      anchors.centerIn: button
      width: button.width + 8
      height: button.height + 5
      radius: 6
      color: mouseAreaButton.containsMouse ? "#11c1c1c1" : "transparent"
      z: -1
      Behavior on color {
        ColorAnimation {
          duration: 150
        }
      }
    }

    Loader {
      anchors.centerIn: parent
      sourceComponent: horizontalLayout
    }

    Component {
      id: horizontalLayout
      Row {
        spacing: 6
        Components.ColorIcon {
          id: outputDeviceH
          source: Service.AudioButtons.outputIcon
          implicitSize: 22
          hovered: mouseAreaButton.containsMouse
        }
        Components.ColorIcon {
          id: inputDeviceH
          source: Service.AudioButtons.inputIcon
          implicitSize: 22
          hovered: mouseAreaButton.containsMouse
        }
      }
    }

    MouseArea {
      id: mouseAreaButton
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: {
        if (popupLoader.item) {
          const popup = popupLoader.item;
          if (popup.visible) {
            popup.closeWithAnimation();
          } else {
            popup.show();
            focusManager.addPopup(popup);
            focusManager.activateFocusGrab();
          }
        } else {
          popupLoader.active = true;
          if (!popupLoader.item)
          return;
          const popup = popupLoader.item;
          popup.show();
          focusManager.addPopup(popup);
          focusManager.activateFocusGrab();
        }
      }
    }
  }

  LazyLoader {
    id: popupLoader
    active: false
    loading: false

    Component {
      id: popupComponent

      Components.SlidingPopup {
        id: pipewirePopup
        anchor {
          window: root.QsWindow.window
          rect.x: Screen.width * 2 + pipewirePopup.width * 2
          rect.y: 30
        }

        implicitWidth: 500
        implicitHeight: pipewireControl.implicitHeight + 20
        color: "transparent"
        visible: false

        onCloseAnimationFinished: {
          focusManager.removePopup(pipewirePopup);
          popupLoader.active = false;
        }

        Service.PipewireCtl {
          id: pipewireControl
          onVisibleChanged: {
            if (!visible && pipewirePopup.visible) {
              pipewirePopup.closeWithAnimation();
            }
          }
        }
      }
    }

    component: popupComponent
  }
}
