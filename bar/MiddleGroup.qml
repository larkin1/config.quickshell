import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
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
      itemHeight: Theme.barHeight
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
      itemHeight: Theme.barHeight
      reversed: true
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

    height: Theme.barHeight
    spacing: 0

    anchors {
      top: parent.top
      topMargin: Theme.vertMargin
      horizontalCenter: root.horizontalCenter
    }

    Border {
      background: Theme.surface0
      foreground: "transparent"
      itemHeight: Theme.barHeight
      reversed: true
    }

    Border {
      background: "transparent"
      foreground: Theme.mauve
      itemHeight: Theme.barHeight
      reversed: true
    }

    Rectangle {
      id: text2
      color: Theme.mauve
      Layout.fillHeight: true
      implicitWidth: nixIcon.implicitWidth + Theme.horizMargin

      IconImage {
        id: nixIcon
        anchors.centerIn: parent
        implicitSize: Theme.iconSize
        mipmap: true
        source: Qt.resolvedUrl("../svg/nix.svg")
      }
    }

    Border {
      foreground: Theme.mauve
      background: "transparent"
      itemHeight: Theme.barHeight
    }

    Border {
      foreground: "transparent"
      background: Theme.surface0
      itemHeight: Theme.barHeight
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
      itemHeight: Theme.barHeight
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
      itemHeight: Theme.barHeight
    }
  }
}
