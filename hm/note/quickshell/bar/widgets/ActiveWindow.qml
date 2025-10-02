import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Hyprland
import "components" as Components
import "services/osd" as OSDInterface
import "services/notis" as Notis
import "services/cal" as Cal
import qs

Components.BarWidget {
  id: roots
  implicitWidth: notiSparkle.visible ? notiSparkle.implicitWidth + buttonWrapper.width + row.spacing + 20 : buttonWrapper.width + 20
  color: "transparent"
  property date selectedDate: Globals.date
  property color backgroundColor: Globals.backgroundColor

  Row {
    id: row
    anchors.fill: parent
    anchors.margins: 8
    spacing: 6
    anchors.verticalCenter: parent.verticalCenter

    Item {
      id: buttonWrapper
      width: button.implicitWidth + notiSparkle.width + 10
      height: button.implicitHeight

      Rectangle {
        id: hoverBackground
        anchors.centerIn: button
        width: button.width + 8
        height: button.height
        color: mouseAreaButton.containsMouse ? "#11c1c1c1" : "transparent"
        radius: 6
        z: -1
        Behavior on color {
          ColorAnimation {
            duration: 150
          }
        }
      }

      Button {
        id: button
        anchors.centerIn: parent
        hoverEnabled: true
        background: null
        implicitWidth: Math.min(titleText.implicitWidth + 20, 250)
        implicitHeight: 27

        contentItem: Item {
          anchors.fill: parent
          Text {
            id: titleText
            anchors.fill: parent
            anchors.margins: 4
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            maximumLineCount: 1
            text: ToplevelManager.activeToplevel?.title ?? "󱨱 "
            color: "#" + Globals.colors.colors.color6
            font.family: Globals.font
            font.pixelSize: 13
            font.styleName: "Bold"
          }
        }

        MouseArea {
          id: mouseAreaButton
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            const window = roots.QsWindow.window;
            const itemRect = window.contentItem.mapFromItem(roots, 0, roots.height);
            dashboardPopup.anchor.rect.x = itemRect.x - (dashboardPopup.width / 2) + (roots.width / 2);
            dashboardPopup.anchor.rect.y = itemRect.y - 6;
            dashboardPopup.show();
            grab.active = true;
          }
        }
      }
    }
    RowLayout {

      Notis.NotificationIndicator {
        id: notiSparkle
        visible: hasNotification
        Layout.topMargin: 5
        implicitWidth: 20
        implicitHeight: 20
      }
    }
  }
  Connections {
    target: Notis.NotiServer.notificationServer
    function onNotification(n) {
      if (!n.transient) {
        n.tracked = true;
        notiSparkle.hasNotification = true;
        n.closed.connect(() => notiSparkle.hasNotification = false);
      }
    }
  }

  Behavior on implicitWidth {
    NumberAnimation {
      duration: 300
      easing.type: Easing.InOutQuad
    }
  }

  RowLayout {
    spacing: 8
    Layout.fillWidth: true
    Layout.fillHeight: true

    OSDInterface.OSD {
      id: osd
      parentQsWindow: parent.QsWindow.window
    }
    Notis.NotificationPopup {
      id: notificationPopupManager
      notificationServer: Notis.NotiServer.notificationServer
      parentQsWindow: parent.QsWindow.window
      silenced: !notiView.notificationsEnabled
      offset: 40
    }

    Components.SlidingPopup {
      id: dashboardPopup
      anchor.window: roots.QsWindow.window
      anchor.margins.top: -2
      implicitWidth: 550
      implicitHeight: 800

      property date displayMonth: selectedDate

      ClippingRectangle {
        id: activeWindowRect
        anchors.fill: parent
        color: roots.backgroundColor
        radius: 16
        layer.smooth: true
        layer.samples: 8
        layer.enabled: true
        contentInsideBorder: true

        z: 1

        ColumnLayout {
          anchors.fill: parent
          anchors.centerIn: parent
          anchors.margins: 12
          spacing: 12

          Cal.Calendar {
            id: calendarComponent
            Layout.preferredWidth: 500
            Layout.preferredHeight: 350
            selectedDate: roots.selectedDate
          }

          Notis.NotificationView {
            id: notiView
            Layout.fillWidth: true
            Layout.fillHeight: true
            isVisible: dashboardPopup.visible
            notificationServer: Notis.NotiServer.notificationServer
          }
        }
      }
    }

    HyprlandFocusGrab {
      id: grab
      windows: [dashboardPopup]
      onCleared: {
        dashboardPopup.closeWithAnimation();
      }
    }
  }
}