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
      itemHeight: Theme.barHeight
      reversed: true
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
        activeTextColor: Theme.text
      }
    }

    Border {
      foreground: Theme.base
      background: Theme.crust
      itemHeight: Theme.barHeight
      outerMargin: Theme.horizMargin
    }

    Rectangle {
      id: mediaWidget
      color: Theme.mantle
      Layout.fillHeight: true
      implicitWidth: media.implicitWidth
      clip: true

      Layout.maximumWidth: Math.max(80, root.rightBoundary - mediaWidget.x - Theme.horizMargin)

      Behavior on implicitWidth {
        SpringAnimation {
          spring: 3
          damping: 0.2
        }
      }

      Mpris {
        id: media
        width: parent.width
        textColor: Theme.text
        activeBGColor: Theme.surface1
        bgColor: Theme.crust
      }
    }

    Border {
      foreground: Theme.crust
      background: "transparent"
      itemHeight: Theme.barHeight
    }
  }
}
