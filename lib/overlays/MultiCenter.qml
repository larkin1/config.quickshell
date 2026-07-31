import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../.."

Item {
  id: root

  implicitWidth: parent.width
  visible: open

  required property int expandedWidth
  readonly property bool onFocusedScreen:
    Hyprland.focusedMonitor?.name ===
    QsWindow.window?.screen.name // qmllint disable missing-property
  readonly property bool open: ShellUI.multiOpen && onFocusedScreen

  onOpenChanged: {
    if (open) {
      if (Hyprland.focusedMonitor) {
        window.visible = false
        openAnim.start()
        grab.active = true;
        background.forceActiveFocus()
      }
    } else {
      window.visible = false
      window.implicitHeight = 1
    }
  }

  PopupWindow {
    id: window

    visible: false
    color: "transparent"
    implicitWidth: root.expandedWidth
    anchor.item: root
    anchor.rect.x: 0
    anchor.rect.y: root.height

    Rectangle {
      id: background
      anchors.fill: parent
      color: Theme.backgroundBlur
      bottomLeftRadius: Theme.vertMargin
      bottomRightRadius: Theme.vertMargin
      Keys.onEscapePressed: {
        ShellUI.close()
      }
    }
  }

  SequentialAnimation {
    id: openAnim
    PauseAnimation { duration: Theme.animationDuration }
    PropertyAction {
      target: window
      property: "visible"
      value: true
    }
    PropertyAnimation {
      target: window
      property: "implicitHeight"
      duration: Theme.animationDuration
      from: root.height
      to: 500
    }
  }

  HyprlandFocusGrab {
    id: grab
    windows: [window]
  }

  Connections {
    target: grab
    function onCleared() { ShellUI.close() }
  }
}
