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

    Image {
      id: iconInactive
      anchors.centerIn: parent
      width: parent.width * 0.55
      height: width
      sourceSize: Qt.size(width * 2, height * 2)
      source: "../../svg/power-button-inactive.svg"
      opacity: powerHover.hovered ? 0 : 1
      Behavior on opacity {
        NumberAnimation {
          duration: Theme.colorAnimationDuration
        }
      }
    }

    Image {
      id: iconActive
      anchors.centerIn: parent
      width: parent.width * 0.55
      height: width
      sourceSize: Qt.size(width * 2, height * 2)
      source: "../../svg/power-button-active.svg"
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

    PowerMenu {
      id: powerMenu
      visible: false
    }

    MouseArea {
      id: mouse
      anchors.fill: parent
      onClicked: {
        powerMenu.visible = !powerMenu.visible
      }
      cursorShape: Qt.PointingHandCursor
      onWheel: (wheel) => {
        if (wheel.angleDelta.y < 0) {
        }
        if (wheel.angleDelta.y > 0) {
        }
        wheel.accepted = true;
      }
    }
  }
}
