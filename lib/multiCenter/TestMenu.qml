// import Quickshell
import QtQuick
import "../.."

Item {
  id: root
  anchors.fill: parent

  Toggle {
    activated: false
    MouseArea {
      anchors.fill: parent
      onClicked: {
        parent.activated = !parent.activated
      }
      cursorShape: Qt.PointingHandCursor
    }
  }
}
