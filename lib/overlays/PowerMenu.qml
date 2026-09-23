pragma Singleton
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "../.."

PanelWindow { //qmllint disable uncreatable-type
  id: root
  visible: ShellUI.powerOpen
  color: Theme.backgroundBlur

  WlrLayershell.namespace: "quickshell-blur" // you need to make a layer-rule in your hyprland config for this to work properly.
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

  function onCleared() { ShellUI.close() }

  onVisibleChanged: {
    if (visible) {
      poweroff.forceActiveFocus()
      grab.active = true;
    }
  }

  RowLayout {
    id: content
    spacing: 0
    anchors.centerIn: parent
    implicitHeight: 150

    Keys.onPressed: event => {
      if (event.key === Qt.Key_Escape || event.key === Qt.Key_Q) {
        ShellUI.close()
        event.accepted = true;
      }
    }

    Border {
      background: "transparent"
      foreground: Theme.surface0
      reversed: true
    }

    IconButton {
      id: poweroff
      iconPath: "../../svg/shutdown.svg"
      iconColor: active ? Theme.red : Theme.text
      command: ["poweroff"]
      baseColor: Theme.surface0
      hoverColor: Theme.surface1
      focusLeft: lock
      focusRight: reboot
    }

    Border {
      foreground: Theme.surface0
      background: Theme.base
      reversed: false
    }

    IconButton {
      id: reboot
      iconPath: "../../svg/reboot.svg"
      iconColor: active ? Theme.red : Theme.text
      command: ["reboot"]
      baseColor: Theme.base
      hoverColor: Theme.surface0
      focusLeft: poweroff
      focusRight: sleep
    }

    Border {
      foreground: Theme.base
      background: Theme.mantle
      reversed: false
    }

    IconButton {
      id: sleep
      iconPath: "../../svg/sleep.svg"
      iconColor: active ? Theme.red : Theme.text
      command: ["systemctl", "suspend"]
      baseColor: Theme.mantle
      hoverColor: Theme.base
      focusLeft: reboot
      focusRight: lock
    }

    Border {
      foreground: Theme.mantle
      background: Theme.crust
      reversed: false
    }

    IconButton {
      id: lock
      iconPath: "../../svg/lock.svg"
      iconColor: active ? Theme.red : Theme.text
      baseColor: Theme.crust
      hoverColor: Theme.mantle
      focusLeft: sleep
      focusRight: poweroff

      onClicked: {
        LockScreen.lock()
      }
    }

    Border {
      foreground: Theme.crust
      background: "transparent"
      reversed: false
    }
  }

  HyprlandFocusGrab {
    id: grab
    windows: [root]
  }

  Connections {
    target: grab
    function onCleared() { ShellUI.close() }
  }
}
