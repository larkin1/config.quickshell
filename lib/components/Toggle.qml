import QtQuick
import QtQuick.Layouts
import "../.."

Item {
  id: root
  required property bool activated
  anchors.centerIn: parent

  property int segmentWidth: 25
  implicitHeight: 20

  property real p: activated ? 1 : 0

  Behavior on p {
    NumberAnimation { duration: Theme.animationDuration; easing: Easing.OutQuad }
  }

  readonly property real leftW:   p <= 0.5 ? p * (segmentWidth/2) : (segmentWidth/4) + (p - 0.5) * (segmentWidth*1.5)
  readonly property real middleW: p <= 0.5 ? p * segmentWidth : (1 - p) * segmentWidth
  readonly property real rightW:  p <= 0.5 ? segmentWidth - p * (segmentWidth*1.5) : (1 - p) * (segmentWidth/2)

  RowLayout {
    spacing: 0
    anchors.centerIn: parent

    Border {
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
      foreground: Theme.surface1
      background: "transparent"
      reversed: false
    }
  }
}
