import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../.."

Item {
  id: root
  anchors.fill: parent

  required property bool open
  required property bool buttonReady
  required property int expandedWidth

  property int expandedHeight: 500

  readonly property bool panelVisible: background.height > 0
  readonly property bool panelReady: background.height >= root.expandedHeight

  PopupWindow {
    id: window

    visible: root.open || root.panelVisible
    color: "transparent"
    implicitWidth: root.expandedWidth
    implicitHeight: root.expandedHeight

    anchor.item: root //qmllint disable missing-property
    anchor.edges: Edges.Bottom //qmllint disable missing-property
    anchor.gravity: Edges.Bottom //qmllint disable missing-property

    Rectangle {
      id: background

      anchors {
        top: parent.top
        left: parent.left
        right: parent.right
      }

      height: root.open && root.buttonReady ? root.expandedHeight : 0
      clip: true
      color: Colors.md3.surface
      bottomLeftRadius: Theme.radius
      bottomRightRadius: Theme.radius

      Behavior on height {
        SequentialAnimation {
          NumberAnimation {
            duration: Theme.animationDuration
            easing.type: Theme.animationEasing
          }
        }
      }

      Keys.onPressed: event => {
        switch (event.key) {
        case Qt.Key_Escape:
        case Qt.Key_Q:
          ShellUI.close();
          event.accepted = true;
        }
      }

      MultiUI {
        opacity: root.open && root.panelReady ? 1 : 0
        height: root.expandedHeight
        anchors {
          top: parent.top
          left: parent.left
          right: parent.right
        }

        Behavior on opacity {
          NumberAnimation {
            duration: Theme.animationDuration / 2
            easing.type: Theme.animationEasing
          }
        }
      }
    }
  }

  HyprlandFocusGrab {
    windows: [window]
    active: root.open
    onCleared: ShellUI.close()
  }
}
