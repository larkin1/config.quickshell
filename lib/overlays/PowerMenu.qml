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
  color: Qt.alpha(Colors.md3.surface, 0.38)

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
      open.restart()
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
      foreground: Colors.md3.surface_container_highest
      reversed: true
    }

    IconButton {
      id: poweroff
      iconPath: "../../svg/shutdown.svg"
      iconColor: active ? Colors.md3.primary : Colors.md3.on_surface
      command: ["poweroff"]
      baseColor: Colors.md3.surface_container_highest
      hoverColor: Qt.alpha(Colors.md3.on_surface, 0.08)
      focusLeft: lock
      focusRight: reboot
    }

    Border {
      foreground: Colors.md3.surface_container_highest
      background: Colors.md3.surface_container
      reversed: false
    }

    IconButton {
      id: reboot
      iconPath: "../../svg/reboot.svg"
      iconColor: active ? Colors.md3.primary : Colors.md3.on_surface
      command: ["reboot"]
      baseColor: Colors.md3.surface_container
      hoverColor: Qt.alpha(Colors.md3.on_surface, 0.08)
      focusLeft: poweroff
      focusRight: sleep
    }

    Border {
      foreground: Colors.md3.surface_container
      background: Colors.md3.surface_container_low
      reversed: false
    }

    IconButton {
      id: sleep
      iconPath: "../../svg/sleep.svg"
      iconColor: active ? Colors.md3.primary : Colors.md3.on_surface
      command: ["systemctl", "suspend"]
      baseColor: Colors.md3.surface_container_low
      hoverColor: Qt.alpha(Colors.md3.on_surface, 0.08)
      focusLeft: reboot
      focusRight: lock
    }

    Border {
      foreground: Colors.md3.surface_container_low
      background: Colors.md3.surface_container_lowest
      reversed: false
    }

    IconButton {
      id: lock
      iconPath: "../../svg/lock.svg"
      iconColor: active ? Colors.md3.primary : Colors.md3.on_surface
      baseColor: Colors.md3.surface_container_lowest
      hoverColor: Qt.alpha(Colors.md3.on_surface, 0.08)
      focusLeft: sleep
      focusRight: poweroff

      onClicked: {
        LockScreen.lock()
      }
    }

    Border {
      foreground: Colors.md3.surface_container_lowest
      background: "transparent"
      reversed: false
    }
  }

  SequentialAnimation {
    id: open
    PropertyAction {
      targets: [lock, sleep, poweroff, reboot]
      properties: "buttonOpacity,implicitWidth"
      value: 0
    }
    NumberAnimation { target: poweroff; property: "implicitWidth"; to: content.implicitHeight; duration: Theme.animationDuration; easing: Easing.InQuart; }
    NumberAnimation { target: poweroff; property: "buttonOpacity"; to: 1; duration: Theme.animationDuration*0.5; easing: Theme.animationEasing; }
    NumberAnimation { target: reboot; property: "implicitWidth"; to: content.implicitHeight; duration: Theme.animationDuration; easing: Easing.InQuart; }
    NumberAnimation { target: reboot; property: "buttonOpacity"; to: 1; duration: Theme.animationDuration*0.5; easing: Theme.animationEasing; }
    NumberAnimation { target: sleep; property: "implicitWidth"; to: content.implicitHeight; duration: Theme.animationDuration; easing: Easing.InQuart; }
    NumberAnimation { target: sleep; property: "buttonOpacity"; to: 1; duration: Theme.animationDuration*0.5; easing: Theme.animationEasing; }
    NumberAnimation { target: lock; property: "implicitWidth"; to: content.implicitHeight; duration: Theme.animationDuration; easing: Easing.InQuart; }
    NumberAnimation { target: lock; property: "buttonOpacity"; to: 1; duration: Theme.animationDuration*0.5; easing: Theme.animationEasing; }
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
