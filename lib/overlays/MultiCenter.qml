import QtQuick
import QtQuick.Layouts
import Quickshell
import "../.."

Item {
  id: root
  property var window: QsWindow.window
  property alias hovered: windowHover.hovered

  signal closed()

  implicitWidth: parent.width
  x: parent.x

  visible: false

  onVisibleChanged: {
    window.implicitHeight = 1
  }

  PopupWindow {
    id: window

    visible: root.visible
    color: "transparent"

    anchor.item: root

    anchor.rect.x: root.x
    anchor.rect.y: root.height
    implicitWidth: root.width
    implicitHeight: 1

    grabFocus: true

    onVisibleChanged: {
      if (!visible) {
        root.closed()
      }
    }

    Rectangle {
      anchors.fill: parent
      color: Theme.backgroundBlur
      bottomLeftRadius: 10
      bottomRightRadius: 10
    }
    // Toggle {
    //   id: toggle
    //   activated: true
    //   anchors.centerIn: parent
    // }

    MouseArea {
      anchors.fill: parent
      onClicked: {
        // toggle.activated = !toggle.activated
      }
    }

    HoverHandler {
      id: windowHover
    }

    Behavior on visible {
      SequentialAnimation {
        PauseAnimation {
          duration: Theme.animationDuration
        }
        PropertyAnimation {
          target: window
          property: "implicitHeight"
          duration: Theme.animationDuration
          to: 600
        }
      }
    }
  }
}
