import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import ".."

Item {
  id: root

  required property int outerMarginU
  required property int innerMarginLR
  required property int barheight

  property real rightBoundary: 0

  implicitHeight: barheight

  RowLayout {
    id: innerLayout
    spacing: 0

    anchors {
      top: parent.top
      topMargin: root.outerMarginU
      bottom: parent.bottom
    }

    // Content
    Border {
      background: "transparent"
      foreground: Theme.base
      Layout.leftMargin: root.innerMarginLR
      itemHeight: root.barheight
      reversed: true
    }

    Rectangle { // Workspaces
      id: text1
      color: Theme.base
      Layout.fillHeight: true
      implicitWidth: workspaces.implicitWidth

      Behavior on implicitWidth {
        SpringAnimation {
          spring: 3
          damping: 0.2
        }
      }

      Workspaces {
        id: workspaces
        barheight: root.barheight
        bgColor: Theme.base
        activeBGColor: Theme.surface0
        inactiveTextColor: Theme.surface2
        activeTextColor: Theme.text
      }
    }

    Border {
      foreground: Theme.base
      background: Theme.mantle
      itemHeight: root.barheight
      outerMargin: root.innerMarginLR
    }

    Rectangle {
      id: mediaWidget
      color: Theme.mantle
      Layout.fillHeight: true
      implicitWidth: media.implicitWidth
      clip: true

      Layout.maximumWidth: Math.max(80, root.rightBoundary - mediaWidget.x - root.innerMarginLR)

      Behavior on implicitWidth {
        SpringAnimation {
          spring: 3
          damping: 0.2
        }
      }

      Mpris {
        id: media
        width: parent.width
        barheight: root.barheight
        textColor: Theme.text
        activeBGColor: Theme.surface1
        bgColor: Theme.mantle
      }
    }

    Border {
      foreground: Theme.mantle
      background: "transparent"
      itemHeight: root.barheight
    }
  }
}
