import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import "../.."

Item {
  id: root
  component PowerButton: Rectangle {
    id: btn

    // property string btnText
    property string activeBtnPath
    property string inactiveBtnPath
    property var command
    property color baseColor
    property color hoverColor
    property int openDelay: 0
    property bool expanded: false

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
        Quickshell.execDetached(btn.command)
      }
    }

    Rectangle {
      color: btnHover.hovered ? btn.hoverColor : btn.baseColor
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
      opacity: btnHover.hovered ? 0 : 1
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
      opacity: btnHover.hovered ? 1 : 0
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

  PanelWindow { //qmllint disable uncreatable-type
    id: windowRoot

    visible: root.visible

    color: "transparent"

    property string screenwidth: QsWindow.window?.screen.width ?? "" // qmllint disable missing-property
    property string screenheight: QsWindow.window?.screen.height ?? "" // qmllint disable missing-property

    anchors {
      top: true
      bottom: true
      left: true
      right: true
    }

    mask: Region {
      item: content
    }

    RowLayout {
      id: content
      spacing: 0
      anchors.centerIn: parent
      implicitHeight: 100

      focus: true
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
        id: poweroff
        activeBtnPath: "../../svg/shutdown-active.svg"
        inactiveBtnPath: "../../svg/shutdown-inactive.svg"
        command: ["poweroff"]
        baseColor: Theme.surface0
        hoverColor: Theme.surface1
        openDelay: 0
        expanded: windowRoot.visible
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
        expanded: windowRoot.visible
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
        command: ["sleep"]
        baseColor: Theme.mantle
        hoverColor: Theme.base
        openDelay: 500
        expanded: windowRoot.visible
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
        expanded: windowRoot.visible
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
      windows: [windowRoot]
    }
    onVisibleChanged: if (visible) grab.active = true;

    Connections {
      target: grab
      function onCleared() {root.visible = false}
    }
  }
}
