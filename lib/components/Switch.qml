import QtQuick
import QtQuick.Layouts
import "../.."

Item {
  id: root
  required property bool activated
  anchors.centerIn: parent

  property real p: activated ? 1 : 0

  Behavior on p {
    NumberAnimation { duration: Theme.animationDuration; easing: Easing.OutQuad }
  }

  implicitHeight: 20

  readonly property real leftW:   p <= 0.5 ? p * 10 : 5 + (p - 0.5) * 30
  readonly property real middleW: p <= 0.5 ? p * 20 : (1 - p) * 20
  readonly property real rightW:  p <= 0.5 ? 20 - p * 30 : (1 - p) * 10

  RowLayout {
    spacing: 0
    anchors.centerIn: parent

    Border {
      itemHeight: root.height
      foreground: Theme.mantle
      background: "transparent"
      reversed: true
    }
    Rectangle {
      id: left
      color: Theme.mantle
      implicitWidth: root.leftW
      implicitHeight: root.height
    }
    Border {
      itemHeight: root.height
      foreground: Theme.surface0
      background: Theme.mantle
      reversed: true
    }
    Rectangle {
      id: middle
      color: Theme.surface0
      implicitWidth: root.middleW
      implicitHeight: root.height
    }
    Border {
      itemHeight: root.height
      foreground: Theme.surface1
      background: Theme.surface0
      reversed: true
    }
    Rectangle {
      id: right
      color: Theme.surface1
      implicitWidth: root.rightW
      implicitHeight: root.height
    }
    Border {
      itemHeight: root.height
      foreground: Theme.surface1
      background: "transparent"
      reversed: false
    }
  }
}
