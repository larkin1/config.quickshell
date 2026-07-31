import QtQuick
import Quickshell.Widgets
import "../.."

Item {
  id: root

  implicitWidth: rect.implicitWidth
  implicitHeight: Theme.barHeight

  property color background: Theme.cyclingColor
  property int expandedWidth: 500

  MultiCenter {
    id: noCent
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
    implicitWidth: ShellUI.multiOpen
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
