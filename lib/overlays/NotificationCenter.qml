import QtQuick
import Quickshell
import Quickshell.Wayland
import "../.."

Item {
  id: root
  property var window: QsWindow.window
  property alias hovered: windowHover.hovered

  implicitWidth: parent.width
  x: parent.x

  visible: false

  onVisibleChanged: {
    window.implicitHeight = 1
  }

  PopupWindow {
    id: window

    visible: root.visible
    // color: implicitHeight <= 1 ? "transparent" : Theme.mantle
    color: "transparent"

    anchor.item: root

    anchor.rect.x: root.x
    anchor.rect.y: root.height
    implicitWidth: root.width
    implicitHeight: 1

    Rectangle {
      implicitWidth: 100
      implicitHeight: 100
      anchors.centerIn: parent
      Switch {
        id: toggle
        activated: true
        anchors.centerIn: parent
      }
    }

    MouseArea {
      anchors.fill: parent
      onClicked: {
        console.log("test")
        toggle.activated = !toggle.activated
      }
    }
    Rectangle {
      anchors.fill: parent
      color: Theme.backgroundBlur
      bottomLeftRadius: 10
      bottomRightRadius: 10
    }
    // WlrLayershell.namespace: "quickshell-blur" // you need to make a layer-rule in your hyprland config for this to work properly.

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
