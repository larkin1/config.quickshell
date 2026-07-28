import Quickshell
import QtQuick
import QtQuick.Layouts
import ".."

Variants {
  model: Quickshell.screens

  PanelWindow { // qmllint disable uncreatable-type
    id: root
    property var modelData
    screen: modelData

    anchors {
      top: true
      left: true
      right: true
    }

    color: "transparent"

    implicitHeight: Theme.barHeight + Theme.vertMargin

    LeftGroup {
      id: leftGroup
      rightBoundary: middleGroup.x + middleGroup.contentLeft - Theme.horizMargin

      opacity: middleGroup.multiButtonExpanded ? 0 : 1
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

      opacity: middleGroup.multiButtonExpanded ? 0 : 1
      Behavior on opacity {
        NumberAnimation {
          duration: Theme.animationDuration
          easing: Theme.animationEasing
        }
      }
    }
  }
}
