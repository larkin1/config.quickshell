import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import "../.."

Item {
  id: root

  implicitHeight: Theme.barHeight
  implicitWidth: row.implicitWidth

  readonly property bool onFocusedScreen: Hyprland.focusedMonitor?.name === QsWindow.window?.screen.name // qmllint disable missing-property
  readonly property bool open: ShellUI.multiOpen && onFocusedScreen

  readonly property bool expanded: root.open || center.panelVisible

  property color background: Colors.md3.primary
  property int expandedWidth: 500

  MouseArea {
    anchors.fill: parent
    onClicked: {
      ShellUI.toggleMulti();
    }
  }

  Row {
    id: row
    height: parent.height

    Border {
      id: leftBorder
      background: "transparent"
      foreground: Colors.md3.primary
      reversed: true
    }

    Rectangle {
      id: rect
      color: root.background
      implicitWidth: 2 * Math.round(animWidth / 2)
      implicitHeight: parent.height
      property real animWidth: root.expanded ? root.expandedWidth : nixIcon.implicitWidth + Theme.margin

      Behavior on animWidth {
        NumberAnimation {
          duration: Theme.animationDuration
          easing.type: Theme.animationEasing
        }
      }

      MultiCenter {
        id: center
        anchors.fill: parent
        open: root.open
        expandedWidth: root.expandedWidth
        buttonReady: rect.width >= root.expandedWidth
      }

      IconImage {
        id: nixIcon
        anchors.centerIn: parent
        implicitSize: Theme.iconSize
        mipmap: true
        source: Qt.resolvedUrl("../../svg/nix.svg")
        layer.enabled: true
        layer.effect: MultiEffect {
          colorization: 1.00
          colorizationColor: Colors.md3.on_primary
        }
      }
    }

    Border {
      foreground: Colors.md3.primary
      background: "transparent"
    }
  }
}
