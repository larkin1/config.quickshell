import QtQuick
import Quickshell
import "../.."

Item {
  id: root

  implicitWidth: parent.width
  x: parent.x
  visible: open

  signal closed()

  property var window: QsWindow.window
  property bool hovered: windowHover.hovered
  property bool open: false

  onOpenChanged: {
    if (open) {
      openAnim.start()
    } else {
      window.implicitHeight = root.height
    }
  }

  PopupWindow {
    id: window

    visible: root.visible

    onVisibleChanged: {
      if (!visible && root.open) {
        root.closed()
      }
    }

    color: "transparent"

    anchor.item: root

    anchor.rect.x: root.x
    anchor.rect.y: 0
    implicitWidth: root.width
    implicitHeight: root.height

    grabFocus: true

    Rectangle {
      anchors.topMargin: root.height
      anchors.fill: parent
      color: Theme.backgroundBlur
      bottomLeftRadius: 10
      bottomRightRadius: 10

      Rectangle {
        id: content
        color: "transparent"
        anchors.fill: parent

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
      }
    }

    HoverHandler {
      id: windowHover
    }

    SequentialAnimation {
      id: openAnim
      PropertyAction {
        target: content
        property: "opacity"
        value: 0
      }
      PauseAnimation {
        duration: Theme.animationDuration
      }
      PropertyAnimation {
        target: window
        property: "implicitHeight"
        duration: Theme.animationDuration
        from: root.height
        to: root.height + 600
      }
      PropertyAnimation {
        target: content
        property: "opacity"
        duration: Theme.animationDuration
        from: 0
        to: 1
      }
    }
  }
}
