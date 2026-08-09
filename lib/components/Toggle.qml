import QtQuick
import QtQuick.Layouts
import "../.."

Item {
  id: root
  property bool activated: false
  anchors.centerIn: parent

  property string onText: ""
  property string offText: ""

  property int segmentSize: 0

  signal clicked()

  onClicked: activated = !activated

  property int segmentWidth: {
    if (segmentSize > 0) {
      return segmentSize
    } else {
      return Math.max(onTextItem.implicitWidth, offTextItem.implicitWidth)
    }
  }

  implicitHeight: 20
  implicitWidth: content.implicitWidth

  property real p: activated ? 1 : 0

  Behavior on p {
    NumberAnimation { duration: Theme.animationDuration; easing: Easing.OutQuad }
  }

  readonly property real leftW:   p <= 0.5 ? p * (segmentWidth/2) : (segmentWidth/4) + (p - 0.5) * (segmentWidth*1.5)
  readonly property real middleW: p <= 0.5 ? p * segmentWidth : (1 - p) * segmentWidth
  readonly property real rightW:  p <= 0.5 ? segmentWidth - p * (segmentWidth*1.5) : (1 - p) * (segmentWidth/2)

  MouseArea {
    onClicked: root.clicked()
    anchors.fill: parent
  }

  RowLayout {
    id: content
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
      clip: true
      StyledText {
        id: onTextItem
        visible: parent.width
        text: root.onText
      }
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
      clip: true
      StyledText {
        id: offTextItem
        visible: parent.width
        text: root.offText
      }
    }
    Border {
      foreground: Theme.surface1
      background: "transparent"
      reversed: false
    }
  }
}
