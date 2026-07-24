pragma Singleton
import QtQuick
import Quickshell
// import Quickshell.Services.Pam
import Quickshell.Wayland
// import Quickshell.Hyprland
import Quickshell.Io
import "../.."

Scope {
  id: root
  property bool locked: false

  Variants {
    id: variantHost
    model: Quickshell.screens

    PanelWindow { // qmllint disable uncreatable-type
      id: win
      color: Theme.backgroundBlur

      property var modelData
      screen: modelData

      visible: LockScreen.locked

      WlrLayershell.namespace: "quickshell-blur" // you need to make a layer-rule in your hyprland config for this to work properly.
      WlrLayershell.layer: WlrLayer.Overlay
      exclusionMode: ExclusionMode.Ignore

      anchors {
        top: true
        bottom: true
        left: true
        right: true
      }

      mask: Region {
        item: background
      }

      onVisibleChanged: {
        if (visible) {
          content.forceActiveFocus()
        }
      }

      focusable: true

      Rectangle {
        id: background
        anchors.fill: parent
        color: "transparent"
        MouseArea {
          anchors.fill: parent
          onClicked: {
            LockScreen.locked = false
          }
        }
        Keys.onPressed: event => {
          if (event.key === Qt.Key_Escape) {
            console.log("ee")
            LockScreen.locked = false
            event.accepted = true;
          }
        }
      }

      Rectangle {
        id: content
        anchors.centerIn: parent
        implicitWidth: 100
        implicitHeight: 100
        MouseArea {
          anchors.fill: parent
        }
        Keys.onPressed: event => {
          if (event.key === Qt.Key_Escape) {
            console.log("ee")
            LockScreen.locked = false
            event.accepted = true;
          }
        }
      }


      // HyprlandFocusGrab {
      //   id: grab
      //   windows: [root]
      // }
      //
      // Connections {
      //   target: grab
      //   function onCleared() {LockScreen.locked = false}
      // }
    }
  }
  IpcHandler {
    target: "lockScreen"
    function activate(): void {
      root.locked = true;
    }
  }
}
