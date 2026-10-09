import QtQuick
import QtQuick.Layouts
import ".."

Item {
  id: root

  readonly property real contentLeft: leftLayout.x

  implicitHeight: Theme.barHeight

  anchors {
    horizontalCenter: parent.horizontalCenter
  }

  RowLayout {
    id: leftLayout
    spacing: 0

    anchors {
      top: parent.top
      topMargin: Theme.vertMargin
      bottom: parent.bottom
      right: centerLayout.left
    }

    Border {
      background: "transparent"
      foreground: Colors.md3.surface_container
      implicitHeight: Theme.barHeight
      reversed: true
    }

    Rectangle {
      color: Colors.md3.surface_container
      Layout.fillHeight: true
      implicitWidth: mem.width + Theme.horizMargin
      Mem {
        id: mem
        anchors.centerIn: parent
      }
    }

    Border {
      foreground: Colors.md3.surface_container_highest
      background: Colors.md3.surface_container
      reversed: true
      implicitHeight: Theme.barHeight
    }


    Rectangle {
      color: Colors.md3.surface_container_highest
      Layout.fillHeight: true
      implicitWidth: cpu.width + Theme.horizMargin
      Cpu {
        id: cpu
        anchors.centerIn: parent
      }
    }
  }

  RowLayout {
    id: centerLayout

    implicitHeight: Theme.barHeight
    spacing: 0

    anchors {
      top: parent.top
      topMargin: Theme.vertMargin
      horizontalCenter: root.horizontalCenter
    }

    Border {
      background: Colors.md3.surface_container_highest
      foreground: "transparent"
      reversed: true
    }

    Border {
      background: "transparent"
      foreground: Theme.cyclingColor
      reversed: true
    }

    MultiButton {
      id: multiButton
    }

    Border {
      foreground: Theme.cyclingColor
      background: "transparent"
    }

    Border {
      foreground: "transparent"
      background: Colors.md3.surface_container_highest
    }
  }

  RowLayout {
    id: rightLayout
    spacing: 0

    anchors {
      top: parent.top
      topMargin: Theme.vertMargin
      bottom: parent.bottom
      left: centerLayout.right
    }

    Rectangle {
      id: clockWidget
      color: Colors.md3.surface_container_highest
      Layout.fillHeight: true
      implicitWidth: clock.implicitWidth

      Clock {
        id: clock
        anchors.centerIn: parent
      }
    }

    Border {
      foreground: Colors.md3.surface_container_highest
      background: Colors.md3.surface_container
      implicitHeight: Theme.barHeight
    }

    Rectangle {
      id: dateWidget
      color: Colors.md3.surface_container
      Layout.fillHeight: true
      implicitWidth: date.implicitWidth

      Clock {
        id: date
        anchors.centerIn: parent
        timeStr: "MM-dd"
        altTimeStr: "dddd d MMMM, yyyy"
        interval: 1000 * 60
      }
    }

    Border {
      foreground: Colors.md3.surface_container
      background: "transparent"
      implicitHeight: Theme.barHeight
    }
  }
}
