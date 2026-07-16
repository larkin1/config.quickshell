import QtQuick
import QtQuick.Shapes

Item {
  id: root
  required property color foreground
  required property color background
  required property int itemHeight
  property int outerMargin: 0
  property int arrowWidth: (root.height / 2)

  implicitHeight: itemHeight
  implicitWidth: (itemHeight / 2) + outerMargin


  Shape {
    anchors.fill: parent
    ShapePath {
      strokeWidth: 0
      fillColor: root.foreground
      startX: 0
      startY: 0
      PathLine { x: 0; y: 0 }
      PathLine { x: root.arrowWidth; y: root.height/2 }
      PathLine { x: 0; y: root.height }
    }
  }

  Shape {
    anchors.fill: parent
    ShapePath {
      strokeWidth: 0
      fillColor: root.background
      startX: 0
      startY: 0
      PathLine { x: root.arrowWidth; y: root.height / 2 }
      PathLine { x: root.arrowWidth; y: 0 }
    }
  }

  Shape {
    anchors.fill: parent
    ShapePath {
      strokeWidth: 0
      fillColor: root.background
      startX: 0
      startY: root.height
      PathLine { x: root.arrowWidth; y: root.height / 2 }
      PathLine { x: root.arrowWidth; y: root.height }
    }
  }

  Rectangle {
    x: root.arrowWidth
    color: root.background
    width: root.outerMargin
    height: parent.height
  }
}
