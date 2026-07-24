import QtQuick
import Quickshell.Widgets
import "../.."

Item {
  id: root
  signal clicked()

  implicitWidth: powerButton.width
  height: Theme.barHeight

  Rectangle {
    id: powerButton
    width: Theme.barHeight
    height: Theme.barHeight
    radius: Theme.barHeight / 2
    color: Theme.surface2
    anchors.centerIn: parent

    IconImage {
      id: iconInactive
      anchors.centerIn: parent
      implicitSize: Theme.iconSize
      mipmap: true
      source: Qt.resolvedUrl("../../svg/power-button-inactive.svg")
      opacity: powerHover.hovered ? 0 : 1
      Behavior on opacity {
        NumberAnimation {
          duration: Theme.colorAnimationDuration
        }
      }
    }

    IconImage {
      id: iconActive
      anchors.centerIn: parent
      implicitSize: Theme.iconSize
      mipmap: true
      source: Qt.resolvedUrl("../../svg/power-button-active.svg")
      opacity: powerHover.hovered ? 1 : 0
      Behavior on opacity {
        NumberAnimation {
          duration: Theme.colorAnimationDuration
        }
      }
    }

    HoverHandler {
      id: powerHover
      cursorShape: Qt.PointingHandCursor
    }

    MouseArea {
      id: mouse
      anchors.fill: parent
      onClicked: root.clicked()
      cursorShape: Qt.PointingHandCursor
    }
  }
}
