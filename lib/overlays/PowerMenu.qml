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
      placeholder.forceActiveFocus()
      grab.active = true;
    }
  }

  RowLayout {
    id: content
    spacing: 0
    anchors.centerIn: parent
    implicitHeight: 150

    Keys.onPressed: event => {
      if (event.key === Qt.Key_Escape) {
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
      id: placeholder
      focusRight: poweroff
      focusLeft: lock
      visible: false
    }

    IconButton {
      id: poweroff
      activeBtnPath: "../../svg/shutdown-active.svg"
      inactiveBtnPath: "../../svg/shutdown-inactive.svg"
      command: ["poweroff"]
      baseColor: Theme.surface0
      hoverColor: Theme.surface1
      openDelay: 0
      expanded: ShellUI.powerOpen
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
      activeBtnPath: "../../svg/reboot-active.svg"
      inactiveBtnPath: "../../svg/reboot-inactive.svg"
      command: ["reboot"]
      baseColor: Theme.base
      hoverColor: Theme.surface0
      openDelay: 250
      expanded: ShellUI.powerOpen
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
      activeBtnPath: "../../svg/sleep-active.svg"
      inactiveBtnPath: "../../svg/sleep-inactive.svg"
      command: ["systemctl", "suspend"]
      baseColor: Theme.mantle
      hoverColor: Theme.base
      openDelay: 500
      expanded: ShellUI.powerOpen
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
      activeBtnPath: "../../svg/lock-active.svg"
      inactiveBtnPath: "../../svg/lock-inactive.svg"
      baseColor: Theme.crust
      hoverColor: Theme.mantle
      openDelay: 750
      expanded: ShellUI.powerOpen
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
