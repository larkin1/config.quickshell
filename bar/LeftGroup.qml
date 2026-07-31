import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import ".."

Item {
  id: root

  property real rightBoundary: 0

  implicitHeight: Theme.barHeight

  RowLayout {
    id: innerLayout
    spacing: 0

    anchors {
      top: parent.top
      topMargin: Theme.vertMargin
      bottom: parent.bottom
    }

    // Content
    Border {
      background: "transparent"
      foreground: Theme.base
      Layout.leftMargin: Theme.horizMargin
      reversed: true
      implicitHeight: Theme.barHeight
    }

    Rectangle { // Workspaces
      id: text1
      color: Theme.base
      Layout.fillHeight: true
      implicitWidth: workspaces.implicitWidth

      Workspaces {
        id: workspaces
        bgColor: Theme.base
        activeBGColor: Theme.surface0
        inactiveTextColor: Theme.surface2
        activeTextColor: Theme.cyclingColor
      }
    }

    Border {
      foreground: Theme.base
      background: Theme.mantle
      outerMargin: Theme.horizMargin
      implicitHeight: Theme.barHeight
    }

    Rectangle {
      id: mediaWidget
      color: Theme.mantle
      Layout.fillHeight: true
      implicitWidth: media.implicitWidth
      clip: true

      Layout.maximumWidth: Math.max(80, root.rightBoundary - mediaWidget.x - Theme.horizMargin)

      Behavior on implicitWidth {
        NumberAnimation {
          duration: Theme.animationDuration
          easing.type: Theme.animationEasing
        }
      }

      Mpris {
        id: media
        width: parent.width
        textColor: Theme.text
        activeBGColor: Theme.surface1
        bgColor: Theme.mantle
      }
    }

    Border {
      foreground: Theme.mantle
      background: "transparent"
      implicitHeight: Theme.barHeight
    }
  }
}
