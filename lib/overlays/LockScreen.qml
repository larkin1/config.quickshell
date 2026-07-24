pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pam
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import "../.."

Item {
  id: controller
  property bool locked: false

  Variants {
    id: vars
    model: Quickshell.screens

    PanelWindow { // qmllint disable uncreatable-type
      id: root
      color: Theme.backgroundBlur

      property var modelData
      screen: modelData

      visible: controller.locked

      // WlrLayershell.namespace: "quickshell-blur" // you need to make a layer-rule in your hyprland config for this to work properly.
      WlrLayershell.layer: WlrLayer.Top
      exclusionMode: ExclusionMode.Ignore

      anchors {
        top: true
        bottom: true
        left: true
        right: true
      }

      mask: Region {
        item: content
      }

      onVisibleChanged: {
        if (visible) {
          content.forceActiveFocus()
          grab.active = true
        } else {
          grab.active = false
        }
      }

      Rectangle {
        id: content
        anchors.centerIn: parent
        implicitWidth: 100
        implicitHeight: 100
        Keys.onPressed: event => {
          if (event.key === Qt.Key_Escape) {
            controller.locked = false
            event.accepted = true;
          }
        }
      }

      HyprlandFocusGrab {
        id: grab
        windows: [root]
      }

      Connections {
        target: grab
        function onCleared() {controller.locked = false}
      }
    }
  }
  IpcHandler {
    target: "lockScreen"
    function activate(): void {
      controller.locked = true;
    }
  }
}
