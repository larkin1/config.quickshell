import QtQuick
import Quickshell.Widgets
import "../.."

Item {
  id: root

  property color background: Theme.mauve

  property bool expanded: false

  Timer {
    id: collapseTimer
    interval: Theme.collapseTimeout * 0.5
    onTriggered: {
      root.expanded = false
    }
  }

  function expand() {
    root.expanded = true
    collapseTimer.stop()
  }

  function delayedCollapse() {
    collapseTimer.restart()
  }

  function collapse() {
    collapseTimer.stop()
    root.expanded = false
  }

  implicitWidth: rect.implicitWidth
  implicitHeight: Theme.barHeight

  Rectangle {
    id: rect
    anchors.centerIn: parent
    anchors.fill:  parent
    color: root.background
    implicitWidth: root.expanded
      ? 1000
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

  HoverHandler {
    id: mainHover
    onHoveredChanged: {
      if (hovered) {
        root.expand()
      } else {
        root.delayedCollapse()
      }
    }
  }
}
