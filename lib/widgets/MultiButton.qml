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
    console.log("expand")
    noCent.visible = true
    root.expanded = true
    collapseTimer.stop()
  }

  function delayedCollapse() {
    console.log("timerstart")
    collapseTimer.restart()
  }

  function collapse() {
    console.log("collapse")
    root.expanded = false
    noCent.visible = false
    collapseTimer.stop()
  }

  Timer {
    id: collapseTimer
    interval: Theme.collapseTimeout * 0.5
    onTriggered: {
      console.log("timercomp")
      root.expanded = false
      noCent.visible = false
    }
  }

  MultiCenter {
    id: noCent
    anchors.fill: parent
    onHoveredChanged: {
      if (hovered) {
        root.expand()
      } else {
        root.delayedCollapse()
      }
    }
    onClosed: {
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
  }

  HoverHandler {
    id: mainHover
    onHoveredChanged: {
      if (hovered) {
        console.log("mainexp")
        root.expand()
        collapseTimer.stop()
      } else {
        console.log("maincol")
        root.delayedCollapse()
      }
    }
  }

  Behavior on implicitWidth {
    SequentialAnimation {
      NumberAnimation {
        duration: Theme.animationDuration
        easing: Theme.animationEasing
      }
    }
  }
}
