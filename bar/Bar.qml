import Quickshell
import QtQuick
import QtQuick.Layouts
import ".."

Variants {
  model: Quickshell.screens

  PanelWindow { // qmllint disable uncreatable-type
    id: root

    screen: modelData
    color: "transparent"
    implicitHeight: Theme.barHeight + Theme.vertMargin

    anchors {
      top: true
      left: true
      right: true
    }

    property var modelData

    LeftGroup {
      id: leftGroup
      rightBoundary: middleGroup.x + middleGroup.contentLeft - Theme.horizMargin

      opacity: ShellUI.multiOpen ? 0 : 1
      Behavior on opacity {
        NumberAnimation {
          duration: Theme.animationDuration
          easing: Theme.animationEasing
        }
      }
    }

    Item { Layout.fillWidth: true }

    MiddleGroup {
      id: middleGroup
    }

    Item { Layout.fillWidth: true }

    RightGroup {
      id: rightGroup

      opacity: ShellUI.multiOpen ? 0 : 1
      Behavior on opacity {
        NumberAnimation {
          duration: Theme.animationDuration
          easing: Theme.animationEasing
        }
      }
    }
  }
}
