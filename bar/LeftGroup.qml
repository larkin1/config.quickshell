import QtQuick
import QtQuick.Layouts
import ".."

RowLayout {
  id: innerLayout
  implicitHeight: Theme.barHeight
  spacing: 0

  // Content
  Border {
    background: "transparent"
    foreground: Colors.md3.surface_container
    Layout.leftMargin: Theme.margin
    reversed: true
  }

  Rectangle { // Workspaces
    color: Colors.md3.surface_container
    Layout.fillHeight: true
    implicitWidth: workspaces.implicitWidth

    Workspaces {
      id: workspaces
      activeBGColor: Qt.alpha(Colors.md3.on_surface, 0.08)
      inactiveTextColor: Colors.md3.on_surface_variant
      activeTextColor: Colors.md3.primary
    }
  }

  Border {
    foreground: Colors.md3.surface_container
    background: Colors.md3.surface_container_lowest
    outerMargin: Theme.margin
  }

  Rectangle {
    id: mediaWidget
    color: Colors.md3.surface_container_lowest
    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.maximumWidth: implicitWidth
    implicitWidth: media.implicitWidth

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
  }

  Item {
    Layout.fillWidth: true
    Layout.minimumWidth: Theme.margin
  }

  Border {
    background: "transparent"
    foreground: Colors.md3.surface_container
    reversed: true
  }

  Rectangle {
    color: Colors.md3.surface_container
    Layout.fillHeight: true
    implicitWidth: mem.width + Theme.margin
    Mem {
      id: mem
      anchors.centerIn: parent
    }
  }

  Border {
    foreground: Colors.md3.surface_container_highest
    background: Colors.md3.surface_container
    reversed: true
  }

  Rectangle {
    color: Colors.md3.surface_container_highest
    Layout.fillHeight: true
    implicitWidth: cpu.width + Theme.margin
    Cpu {
      id: cpu
      anchors.centerIn: parent
    }
  }

  Border {
    background: Colors.md3.surface_container_highest
    foreground: "transparent"
    reversed: true
  }
}
