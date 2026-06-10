import QtQuick
import QtQuick.Shapes

Item {
  id: root
  required property color foreground
  required property color background
  property int outerMargin: 0

  width: (root.height / 2) + outerMargin
  height: parent.height

  Rectangle {
    color: root.background
    width: root.outerMargin
    height: parent.height
  }

  Shape {
    anchors.fill: parent
    ShapePath {
      strokeWidth: 0
      fillColor: root.foreground
      startX: root.width
      startY: root.outerMargin
      PathLine { x: root.width; y: 0 }
      PathLine { x: root.outerMargin; y: root.height/2 }
      PathLine { x: root.width; y: root.height }
    }
  }

  Shape {
    anchors.fill: parent
    ShapePath {
      strokeWidth: 0
      fillColor: root.background
      startX: root.width
      startY: 0
      PathLine { x: root.outerMargin; y: root.height / 2 }
      PathLine { x: root.outerMargin; y: 0 }
    }
  }

  Shape {
    anchors.fill: parent
    ShapePath {
      strokeWidth: 0
      fillColor: root.background
      startX: root.width
      startY: root.height
      PathLine { x: root.outerMargin; y: root.height / 2 }
      PathLine { x: root.outerMargin; y: root.height }
    }
  }
}
