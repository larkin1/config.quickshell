import QtQuick
import Quickshell.Widgets
import "../.."

Item {
  id: root

  implicitWidth: rect.implicitWidth
  implicitHeight: Theme.barHeight

  property color background: Theme.mauve
  property bool expanded: false

  function expand() {
    // console.log("expand")
    root.expanded = true
    collapseTimer.stop()
  }

  function collapse() {
    // console.log("collapse")
    root.expanded = false
    collapseTimer.stop()
  }

  function delayedCollapse() {
    // console.log("timerstart")
    collapseTimer.restart()
  }

  Timer {
    id: collapseTimer
    interval: Theme.collapseTimeout * 0.5
    onTriggered: {
      // console.log("timercomp")
      root.expanded = false
    }
  }

  MultiCenter {
    id: noCent
    anchors.fill: parent
    open: root.expanded
    onHoveredChanged: {
      if (hovered) {
        root.expand()
      } else {
        root.delayedCollapse()
      }
    }
    onClosed: {
      // console.log("forceclose")
      root.collapse()
    }
  }

  Rectangle {
    id: rect
    anchors.centerIn: parent
    anchors.fill:  parent
    color: root.background
    implicitWidth: root.expanded
      ? 500
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
      onHoveredChanged: {
        console.log("ee")
        if (hovered) {
          // console.log("mainexp")
          root.expand()
        } else {
          // console.log("maincol")
          root.delayedCollapse()
        }
      }
    }
  }

  Behavior on implicitWidth {
    NumberAnimation {
      duration: Theme.animationDuration
      easing: Theme.animationEasing
    }
  }
}
