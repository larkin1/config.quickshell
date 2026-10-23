import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../.."

Item {
  id: root

  implicitWidth: parent.width

  required property int expandedWidth
  readonly property bool onFocusedScreen:
    Hyprland.focusedMonitor?.name ===
    QsWindow.window?.screen.name // qmllint disable missing-property
  readonly property bool open: ShellUI.multiOpen && onFocusedScreen

  onOpenChanged: {
    if (open) {
      if (Hyprland.focusedMonitor) {
        window.visible = true
        background.opacity = 0
        openAnim.start()
        grab.active = true
      }
    } else {
      openAnim.stop()
      window.visible = false
      background.implicitHeight = 1
      grab.active = false
    }
  }

  PopupWindow {
    id: window

    visible: false
    color: "transparent"

    implicitWidth: root.expandedWidth
    implicitHeight: 500
    anchor.item: root //qmllint disable missing-property
    anchor.rect.x: 0 //qmllint disable unresolved-type unqualified
    anchor.rect.y: root.height

    Rectangle {
      id: background

      Keys.onPressed: event => {
        switch (event.key) {
          case Qt.Key_Escape:
          case Qt.Key_Q:
            ShellUI.close();
            event.accepted = true;
        }
      }

      color: Colors.md3.surface
      bottomLeftRadius: Theme.radius
      bottomRightRadius: Theme.radius

      implicitWidth: parent.width
      anchors.top: parent.top

      MultiUI {
        id: screens
      }
    }
  }

  SequentialAnimation {
    id: openAnim
    PauseAnimation { duration: Theme.animationDuration }
    ScriptAction { script: window.anchor.updateAnchor() }
    PropertyAction {
      target: background
      property: "opacity"
      value: 1
    }
    PropertyAnimation {
      target: background
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
