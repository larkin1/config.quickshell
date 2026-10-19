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
      topMargin: Theme.barVertSpacing
      bottom: parent.bottom
    }

    // Content
    Border {
      background: "transparent"
      foreground: Colors.md3.surface_container
      Layout.leftMargin: Theme.margin
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
        activeTextColor: Colors.md3.primary
      }
    }

    Border {
      foreground: Colors.md3.surface_container
      background: Colors.md3.surface_container_lowest
      outerMargin: Theme.margin
      implicitHeight: Theme.barHeight
    }

    Rectangle {
      id: mediaWidget
      color: Colors.md3.surface_container_lowest
      Layout.fillHeight: true
      implicitWidth: media.implicitWidth
      clip: true

      Layout.maximumWidth: Math.max(80, root.rightBoundary - mediaWidget.x - Theme.margin)

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
        bgColor: Colors.md3.surface_container_lowest
        activeProgressbarColor: Colors.md3.primary
        progressbarColor: Qt.alpha(Colors.md3.on_surface_variant, 0.50)
      }
    }

    Border {
      foreground: Colors.md3.surface_container_lowest
      background: "transparent"
      implicitHeight: Theme.barHeight
    }
  }
}
