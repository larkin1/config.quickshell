import QtQuick
import QtQuick.Layouts
import "../.."

Item {
  id: root
  property bool activated: false
  // anchors.centerIn: parent

  property string onText: ""
  property string offText: ""

  property Item focusLeft: null
  property Item focusRight: null
  property Item focusUp: null
  property Item focusDown: null

  property color color1: (root.focus || hover.hovered) ? Theme.surface0 : Theme.mantle
  property color color2: (root.focus || hover.hovered) ? Theme.surface1 : Theme.surface0
  property color color3: (root.focus || hover.hovered) ? Theme.overlay0 : Theme.surface1

  HoverHandler {
    id: hover
  }

  Keys.onPressed: event => {
    switch (event.key) {
      case Qt.Key_H:
      case Qt.Key_Left:
        if (root.focusLeft) root.focusLeft.forceActiveFocus();
        event.accepted = true;
        break;
      case Qt.Key_L:
      case Qt.Key_Right:
        if (root.focusRight) root.focusRight.forceActiveFocus();
        event.accepted = true;
        break;
      case Qt.Key_J:
      case Qt.Key_Down:
        if (root.focusDown) root.focusDown.forceActiveFocus();
        event.accepted = true;
        break;
      case Qt.Key_K:
      case Qt.Key_Up:
        if (root.focusUp) root.focusUp.forceActiveFocus();
        event.accepted = true;
        break;
      case Qt.Key_Return:
      case Qt.Key_Enter:
      case Qt.Key_Space:
        clicked();
        event.accepted = true;
        break;
    }
  }

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
      foreground: root.color1
      background: "transparent"
      reversed: true
    }
    Rectangle {
      id: left
      color: root.color1
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
      foreground: root.color2
      background: root.color1
      reversed: true
    }
    Rectangle {
      id: middle
      color: root.color2
      implicitWidth: root.middleW
      implicitHeight: root.height
    }
    Border {
      foreground: root.color3
      background: root.color2
      reversed: true
    }
    Rectangle {
      id: right
      color: root.color3
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
      foreground: root.color3
      background: "transparent"
      reversed: false
    }
  }
}
