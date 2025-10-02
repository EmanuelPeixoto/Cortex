import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import "../../components" as Components
import qs

Item {
  id: calendarRoot

  property date selectedDate: Globals.date
  property date displayDate: Globals.date

  signal dateSelected(date newDate)

  ColumnLayout {
    anchors.fill: parent
    spacing: 12

    // Clock section
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 70
      color: "transparent"
      radius: 8

      CalendarClock {
        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height) * 0.8
        height: width
      }
    }

    // Calendar section
    Rectangle {
      Layout.fillWidth: true
      Layout.preferredHeight: 320
      color: "transparent"
      radius: 8

      ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header with date and navigation buttons
        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 40
          color: "transparent"

          Row {
            anchors.fill: parent
            anchors.leftMargin: 24
            anchors.rightMargin: 24
            spacing: 10

            Button {
              id: prevButton
              anchors.verticalCenter: parent.verticalCenter
              width: 30
              height: 30
              text: ""
              onClicked: {
                var newDate = new Date(displayDate)
                newDate.setMonth(newDate.getMonth() - 1)
                displayDate = newDate
              }

              background: Rectangle {
                color: !prevButton.hovered ? "#22" + Globals.colors.colors.color0 : "#55" + Globals.colors.colors.color8
                radius: 4
              }

              contentItem: Text {
                text: prevButton.text
                color: "#A0A0A0"
                font.family: Globals.font
                font.pixelSize: 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
              }
            }

            Text {
              id: dateText
              anchors.verticalCenter: parent.verticalCenter
              width: parent.width - prevButton.width - nextButton.width - 20
              text: displayDate.toLocaleDateString(Qt.locale(), "MMMM yyyy")
              color: "#" + Globals.colors.colors.color6
              font.family: Globals.font
              font.pixelSize: 12
              font.weight: Font.Medium
              horizontalAlignment: Text.AlignHCenter
            }

            Button {
              id: nextButton
              anchors.verticalCenter: parent.verticalCenter
              width: 30
              height: 30
              text: ""
              onClicked: {
                var newDate = new Date(displayDate)
                newDate.setMonth(newDate.getMonth() + 1)
                displayDate = newDate
              }

              background: Rectangle {
                color: !nextButton.hovered ? "#22" + Globals.colors.colors.color0 : "#55" + Globals.colors.colors.color8
                radius: 4
              }

              contentItem: Text {
                text: nextButton.text
                color: "#A0A0A0"
                font.family: Globals.font
                font.pixelSize: 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
              }
            }
          }
        }

        // Calendar grid
        Item {
          Layout.fillWidth: true
          Layout.fillHeight: true
          Layout.leftMargin: 8
          Layout.rightMargin: 8
          Layout.bottomMargin: 8

          CalendarGrid {
            anchors.fill: parent
            selectedDate: calendarRoot.selectedDate
            displayDate: calendarRoot.displayDate

            onDateClicked: function(clickedDate) {
              calendarRoot.selectedDate = clickedDate
              calendarRoot.dateSelected(clickedDate)
            }
          }
        }
      }
    }
  }
}