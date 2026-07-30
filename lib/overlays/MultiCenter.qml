import QtQuick
import Quickshell
import "../.."

Item {
  id: root
  property var window: QsWindow.window
  property alias hovered: windowHover.hovered

  property bool open: false

  onOpenChanged: {
    if (open) {
      openAnim.start()
    } else {
      root.visible = false
    }
  }

  signal closed()

  implicitWidth: parent.width
  x: parent.x

  visible: false

  onVisibleChanged: {
    if (!visible) {
      closed()
    }
  }

  PopupWindow {
    id: window

    visible: root.visible
    color: "green"

    anchor.item: root

    anchor.rect.x: root.x
    anchor.rect.y: root.height
    implicitWidth: root.width
    implicitHeight: 1

    grabFocus: true

    Rectangle {
      anchors.fill: parent
      color: Theme.backgroundBlur
      bottomLeftRadius: 10
      bottomRightRadius: 10
    }

    Toggle {
      id: toggle
      activated: true
      anchors.centerIn: parent
    }

    MouseArea {
      anchors.fill: parent
      onClicked: {
        toggle.activated = !toggle.activated
      }
    }

    HoverHandler {
      id: windowHover
    }

    SequentialAnimation {
      id: openAnim
      PauseAnimation {
        duration: Theme.animationDuration
      }
      PropertyAction {
        target: root
        property: "visible"
        value: true
      }
      PropertyAnimation {
        target: window
        property: "implicitHeight"
        duration: Theme.animationDuration
        from: 1
        to: 600
      }
    }
  }
}
