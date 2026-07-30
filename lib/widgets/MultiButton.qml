import QtQuick
import Quickshell.Widgets
import "../.."

Item {
  id: root

  implicitWidth: rect.implicitWidth
  implicitHeight: Theme.barHeight

  property color background: Theme.cyclingColor
  property bool expanded: false
  property bool hovered: mainHover.hovered || noCent.hovered
  property int expandedWidth: 500

  onHoveredChanged: {
    if (hovered) {
      root.expand()
    } else {
      root.delayedCollapse()
    }
  }

  function expand() {
    root.expanded = true
    collapseTimer.stop()
  }

  function collapse() {
    root.expanded = false
    collapseTimer.stop()
  }

  function delayedCollapse() {
    collapseTimer.restart()
  }

  Timer {
    id: collapseTimer
    interval: Theme.collapseTimeout * 0.5
    onTriggered: {
      root.expanded = false
    }
  }

  MultiCenter {
    id: noCent
    anchors.fill: parent
    open: root.expanded
    onClosed: {
      root.collapse()
    }
    expandedWidth: root.expandedWidth
  }

  Rectangle {
    id: rect
    anchors.centerIn: parent
    anchors.fill:  parent
    color: root.background
    implicitWidth: root.expanded
      ? root.expandedWidth
      : nixIcon.implicitWidth + Theme.horizMargin

    IconImage {
      id: nixIcon
      anchors.centerIn: parent
      implicitSize: Theme.iconSize
      mipmap: true
      source: Qt.resolvedUrl("../../svg/nix.svg")
    }

    HoverHandler {
      id: mainHover
    }
  }

  Behavior on implicitWidth {
    NumberAnimation {
      duration: Theme.animationDuration
      easing: Theme.animationEasing
    }
  }
}
