// import Quickshell.Io
// import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../.."

Item {
  id: root
  anchors.fill: parent
  
  onVisibleChanged: {
    if (visible) {
      content.forceActiveFocus()
    }
  }

  ColumnLayout {
    id: content
    implicitWidth: parent.width - (Theme.horizMargin*2)
    implicitHeight: parent.height - (Theme.vertMargin*2)
    anchors.centerIn: parent
    spacing: Theme.vertMargin

    Keys.onPressed: event => {
      switch (event.key) {
        case Qt.Key_H:
        case Qt.Key_Left:
          power.forceActiveFocus()
          event.accepted = true;
          break;
        case Qt.Key_L:
        case Qt.Key_Right:
          power.forceActiveFocus()
          event.accepted = true;
          break;
        case Qt.Key_J:
        case Qt.Key_Down:
          power.forceActiveFocus()
          event.accepted = true;
          break;
        case Qt.Key_K:
        case Qt.Key_Up:
          power.forceActiveFocus()
          event.accepted = true;
          break;
        case Qt.Key_Return:
        case Qt.Key_Enter:
        case Qt.Key_Space:
          power.clicked();
          power.forceActiveFocus()
          event.accepted = true;
          break;
      }
    }

    Rectangle {
      id: actionsBar
      implicitHeight: (root.height - (Theme.vertMargin*2)) / 13
      implicitWidth: parent.width
      color: "orange"
      RowLayout {
        anchors.fill: parent
        Rectangle {

          implicitHeight: parent.height
          implicitWidth: parent.width / 5
          color: "green"

          Layout.alignment: Qt.AlignRight

          Toggle {
            id: power
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
}
