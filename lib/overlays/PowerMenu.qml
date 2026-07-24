pragma Singleton
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets
import "../.."

PanelWindow { //qmllint disable uncreatable-type
  id: root
  visible: false
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

  IpcHandler {
    target: "powerMenu"
    function toggle(): void {
      root.visible = !root.visible;
    }
  }

  component PowerButton: Rectangle {
    id: btn

    property string activeBtnPath
    property string inactiveBtnPath
    property var command
    property color baseColor
    property color hoverColor
    property int openDelay: 0
    property bool expanded: false
    property Item focusLeft: null
    property Item focusRight: null

    color: baseColor
    implicitWidth: expanded ? height : 0
    implicitHeight: parent.height
    Layout.fillHeight: true

    HoverHandler {
      id: btnHover
    }

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: {
        btn.run()
      }
    }

    function run() {
      if (btn.command !== undefined && btn.command !== null) {
        Quickshell.execDetached(btn.command)
      }
    }

    Keys.onPressed: event => {
      switch (event.key) {
        case Qt.Key_H:
        case Qt.Key_Left:
          if (focusLeft) focusLeft.forceActiveFocus();
          event.accepted = true;
          break;
        case Qt.Key_L:
        case Qt.Key_Right:
          if (focusRight) focusRight.forceActiveFocus();
          event.accepted = true;
          break;
        case Qt.Key_Return:
        case Qt.Key_Enter:
        case Qt.Key_Space:
          run();
          event.accepted = true;
          break;
      }
    }

    Rectangle {
      color: (btnHover.hovered || btn.activeFocus) ? btn.hoverColor : btn.baseColor
      implicitWidth: parent.width * 0.8
      implicitHeight: parent.height * 0.8
      radius: parent.height * 0.2
      anchors.centerIn: parent
      Behavior on color {
        ColorAnimation {
          duration: 200
        }
      }
    }

    IconImage {
      id: iconInactive
      anchors.centerIn: parent
      implicitSize: btn.height * 0.5
      mipmap: true
      source: Qt.resolvedUrl(btn.inactiveBtnPath)
      opacity: (btnHover.hovered || btn.activeFocus) ? 0 : 1
      Behavior on opacity {
        NumberAnimation {
          duration: Theme.colorAnimationDuration
        }
      }
    }

    IconImage {
      id: iconActive
      anchors.centerIn: parent
      implicitSize: btn.height * 0.5
      mipmap: true
      source: Qt.resolvedUrl(btn.activeBtnPath)
      opacity: (btnHover.hovered || btn.activeFocus) ? 1 : 0
      Behavior on opacity {
        NumberAnimation {
          duration: Theme.colorAnimationDuration
        }
      }
    }

    Behavior on implicitWidth {
      enabled: !btn.expanded
      SequentialAnimation {
        id: animation
        PropertyAction {
          target: iconInactive
          property: "opacity"
          value: 0
        }
        PauseAnimation { duration: btn.openDelay }
        NumberAnimation {
          duration: Theme.animationDuration
          easing.type: Easing.InQuart
        }
        PropertyAction {
          target: iconInactive
          property: "opacity"
          value: 1
        }
        PropertyAnimation {
          target: iconInactive
          property: "opacity"
          duration: 400
          from: 0
          to: 1
        }
      }
    }
  }

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
        root.visible = false;
        event.accepted = true;
      }
    }

    Border {
      background: "transparent"
      foreground: Theme.surface0
      itemHeight: parent.height
      reversed: true
    }

    PowerButton {
      id: placeholder
      focusRight: poweroff
      focusLeft: lock
      visible: false
    }

    PowerButton {
      id: poweroff
      activeBtnPath: "../../svg/shutdown-active.svg"
      inactiveBtnPath: "../../svg/shutdown-inactive.svg"
      command: ["poweroff"]
      baseColor: Theme.surface0
      hoverColor: Theme.surface1
      openDelay: 0
      expanded: root.visible
      focusLeft: lock
      focusRight: reboot
    }

    Border {
      foreground: Theme.surface0
      background: Theme.base
      itemHeight: parent.height
      reversed: false
    }

    PowerButton {
      id: reboot
      activeBtnPath: "../../svg/reboot-active.svg"
      inactiveBtnPath: "../../svg/reboot-inactive.svg"
      command: ["reboot"]
      baseColor: Theme.base
      hoverColor: Theme.surface0
      openDelay: 250
      expanded: root.visible
      focusLeft: poweroff
      focusRight: sleep
    }

    Border {
      foreground: Theme.base
      background: Theme.mantle
      itemHeight: parent.height
      reversed: false
    }

    PowerButton {
      id: sleep
      activeBtnPath: "../../svg/sleep-active.svg"
      inactiveBtnPath: "../../svg/sleep-inactive.svg"
      command: ["systemctl", "suspend"]
      baseColor: Theme.mantle
      hoverColor: Theme.base
      openDelay: 500
      expanded: root.visible
      focusLeft: reboot
      focusRight: lock
    }

    Border {
      foreground: Theme.mantle
      background: Theme.crust
      itemHeight: parent.height
      reversed: false
    }

    PowerButton {
      id: lock
      activeBtnPath: "../../svg/lock-active.svg"
      inactiveBtnPath: "../../svg/lock-inactive.svg"
      baseColor: Theme.crust
      hoverColor: Theme.mantle
      openDelay: 750
      expanded: root.visible
      focusLeft: sleep
      focusRight: poweroff
    }

    Border {
      foreground: Theme.crust
      background: "transparent"
      itemHeight: parent.height
      reversed: false
    }
  }

  HyprlandFocusGrab {
    id: grab
    windows: [root]
  }

  Connections {
    target: grab
    function onCleared() {root.visible = false}
  }
}
