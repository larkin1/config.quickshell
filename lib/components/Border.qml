import QtQuick
import QtQuick.Shapes

Item {
  id: root
  required property color foreground
  required property color background
  required property int itemHeight
  property bool reversed: false
  property int outerMargin: 0
  property int arrowWidth: Math.round(root.height / 2)
  property int midY: Math.round(root.height / 2)

  implicitHeight: itemHeight
  implicitWidth: arrowWidth + outerMargin

  function mx(x) { return reversed ? root.implicitWidth - x : x }

  Shape {
    antialiasing: true
    layer.enabled: true
    layer.samples: 5
    anchors.fill: parent

    ShapePath {
      strokeWidth: 0
      fillColor: root.foreground
      startX: root.mx(0)
      startY: 0
      PathLine { x: root.mx(root.arrowWidth); y: root.midY }
      PathLine { x: root.mx(0); y: root.height }
    }

    ShapePath {
      strokeWidth: 0
      fillColor: root.background
      startX: root.mx(0)
      startY: 0
      PathLine { x: root.mx(root.arrowWidth); y: root.midY }
      PathLine { x: root.mx(root.arrowWidth); y: 0 }
    }

    ShapePath {
      strokeWidth: 0
      fillColor: root.background
      startX: root.mx(0)
      startY: root.height
      PathLine { x: root.mx(root.arrowWidth); y: root.midY }
      PathLine { x: root.mx(root.arrowWidth); y: root.height }
    }

    ShapePath {
      strokeWidth: 0
      fillColor: root.background
      startX: root.mx(root.arrowWidth)
      startY: 0
      PathLine { x: root.mx(root.arrowWidth + root.outerMargin); y: 0 }
      PathLine { x: root.mx(root.arrowWidth + root.outerMargin); y: root.height }
      PathLine { x: root.mx(root.arrowWidth); y: root.height }
    }
  }
}
