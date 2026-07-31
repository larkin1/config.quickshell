import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import "../.."

Item {
  id: root

  implicitWidth: rect.implicitWidth
  implicitHeight: Theme.barHeight

  readonly property bool onFocusedScreen:
    Hyprland.focusedMonitor?.name ===
    QsWindow.window?.screen.name // qmllint disable missing-property

  readonly property bool open: ShellUI.multiOpen && onFocusedScreen

  property color background: Theme.cyclingColor
  property int expandedWidth: 500

  MultiCenter {
    anchors.fill: parent
    expandedWidth: root.expandedWidth
  }

  MouseArea {
    anchors.fill: parent
    onClicked: {
      ShellUI.toggleMulti()
    }
  }

  Rectangle {
    id: rect
    anchors.centerIn: parent
    anchors.fill:  parent
    color: root.background
    implicitWidth: root.open
      ? root.expandedWidth
      : nixIcon.implicitWidth + Theme.horizMargin

    IconImage {
      id: nixIcon
      anchors.centerIn: parent
      implicitSize: Theme.iconSize
      mipmap: true
      source: Qt.resolvedUrl("../../svg/nix.svg")
    }
  }

  Behavior on implicitWidth {
    NumberAnimation {
      duration: Theme.animationDuration
      easing: Theme.animationEasing
    }
  }
}
