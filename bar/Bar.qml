import QtQuick
import Quickshell
import Quickshell.Hyprland
import ".."

Variants {
  model: Quickshell.screens

  PanelWindow { // qmllint disable uncreatable-type
    id: root

    screen: modelData
    color: "transparent"
    implicitHeight: Theme.barHeight + Theme.barVertSpacing

    anchors {
      top: true
      left: true
      right: true
    }

    property var modelData

    readonly property bool onFocusedScreen:
      Hyprland.focusedMonitor?.name ===
      modelData.name

    LeftGroup {
      id: leftGroup
      rightBoundary: middleGroup.x + middleGroup.contentLeft - Theme.margin

      opacity: ShellUI.multiOpen && root.onFocusedScreen ? 0 : 1
      Behavior on opacity {
        NumberAnimation {
          duration: Theme.animationDuration
          easing: Theme.animationEasing
        }
      }
    }

    MiddleGroup {
      id: middleGroup
    }

    RightGroup {
      id: rightGroup

      opacity: ShellUI.multiOpen && root.onFocusedScreen ? 0 : 1
      Behavior on opacity {
        NumberAnimation {
          duration: Theme.animationDuration
          easing: Theme.animationEasing
        }
      }
    }
  }
}
