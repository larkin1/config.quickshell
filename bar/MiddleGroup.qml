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
      foreground: Theme.base
      implicitHeight: Theme.barHeight
      reversed: true
    }

    Rectangle {
      color: Theme.base
      Layout.fillHeight: true
      implicitWidth: mem.width + Theme.horizMargin
      Mem {
        id: mem
        anchors.centerIn: parent
      }
    }

    Border {
      foreground: Theme.surface0
      background: Theme.base
      reversed: true
      implicitHeight: Theme.barHeight
    }


    Rectangle {
      color: Theme.surface0
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
      background: Theme.surface0
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
      background: Theme.surface0
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
      color: Theme.surface0
      Layout.fillHeight: true
      implicitWidth: clock.implicitWidth + Theme.horizMargin

      Clock {
        id: clock
        anchors.centerIn: parent
      }
    }

    Border {
      foreground: Theme.surface0
      background: Theme.base
      implicitHeight: Theme.barHeight
    }

    Rectangle {
      id: dateWidget
      color: Theme.base
      Layout.fillHeight: true
      implicitWidth: clock.implicitWidth + Theme.horizMargin

      Clock {
        id: date
        anchors.centerIn: parent
        timeStr: "MM-dd"
        interval: 1000 * 60
      }
    }

    Border {
      foreground: Theme.base
      background: "transparent"
      implicitHeight: Theme.barHeight
    }
  }
}
