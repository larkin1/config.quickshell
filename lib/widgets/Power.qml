import QtQuick
import "../.."

Item {
  id: root
  implicitWidth: powerButton.width
  height: Theme.barHeight

  Rectangle {
    id: powerButton
    width: Theme.barHeight
    height: Theme.barHeight
    radius: Theme.barHeight / 2
    color: Theme.surface2
    anchors.centerIn: parent

    StyledText {
      anchors.fill: parent
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      text: ""

      color: powerHover.hovered ? Theme.red : Theme.text

      Behavior on color {
        ColorAnimation { duration: Theme.colorAnimationDuration }
      }
    }

    HoverHandler {
      id: powerHover
      cursorShape: Qt.PointingHandCursor
    }
  }
}
