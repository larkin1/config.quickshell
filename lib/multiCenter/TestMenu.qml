import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../.."

Item {
  id: root
  anchors.fill: parent

  ColumnLayout {
    id: content
    implicitWidth: parent.width - (Theme.horizMargin*2)
    implicitHeight: parent.height - (Theme.vertMargin*2)
    anchors.centerIn: parent
    spacing: Theme.vertMargin

    Rectangle {
      id: actionsBar
      implicitHeight: (root.height - (Theme.vertMargin*2)) / 13
      implicitWidth: parent.width
      color: "orange"
      RowLayout {
        // implicitHeight: parent.height
        // implicitWidth: parent.width
        anchors.fill: parent
        Rectangle {

          implicitHeight: parent.height
          implicitWidth: parent.width / 5
          color: "green"

          Layout.alignment: Qt.AlignRight

          Toggle {
            activated: true
            onText: "on"
            offText: "off"
          }
        }
        
        Item { Layout.fillWidth: true }

        Rectangle {

          implicitHeight: parent.height
          implicitWidth: parent.width / 5
          color: "green"

          // Layout.alignment: Qt.AlignRight

          StyledText {
            anchors.centerIn: parent
            text: "eee"
          }
        }
      }
    }

    Rectangle {
      id: devices
      implicitHeight: (root.height - (Theme.vertMargin*2)) - actionsBar.implicitHeight - parent.spacing
      implicitWidth: parent.width
      color: "blue"
      // ColumnLayout {
      // }
    }
  }

  // Toggle {
  //   activated: false
  //   MouseArea {
  //     anchors.fill: parent
  //     onClicked: {
  //       parent.activated = !parent.activated
  //     }
  //     cursorShape: Qt.PointingHandCursor
  //   }
  // }
}
