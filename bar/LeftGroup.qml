import QtQuick
import QtQuick.Layouts
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
      foreground: Colors.md3.surface_container
      Layout.leftMargin: Theme.horizMargin
      reversed: true
      implicitHeight: Theme.barHeight
    }

    Rectangle { // Workspaces
      id: text1
      color: Colors.md3.surface_container
      Layout.fillHeight: true
      implicitWidth: workspaces.implicitWidth

      Workspaces {
        id: workspaces
        bgColor: Colors.md3.surface_container
        activeBGColor: Qt.alpha(Colors.md3.on_surface, 0.08)
        inactiveTextColor: Colors.md3.on_surface_variant
        activeTextColor: Colors.cyclingColor
      }
    }

    Border {
      foreground: Colors.md3.surface_container
      background: Colors.md3.surface_container_lowest
      outerMargin: Theme.horizMargin
      implicitHeight: Theme.barHeight
    }

    Rectangle {
      id: mediaWidget
      color: Colors.md3.surface_container_lowest
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

      Player {
        id: media
        width: parent.width
        textColor: Colors.md3.on_surface
        activeBGColor: Qt.alpha(Colors.md3.on_surface, 0.08)
        bgColor: Colors.md3.surface_container_lowest
        activeProgressbarColor: Colors.cyclingColor
        progressbarColor: Colors.md3.on_surface_variant
      }
    }

    Border {
      foreground: Colors.md3.surface_container_lowest
      background: "transparent"
      implicitHeight: Theme.barHeight
    }
  }
}
