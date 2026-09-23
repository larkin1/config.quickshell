import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../.."

Item {
  id: root

  implicitHeight: parent.height
  implicitWidth: root.height

  signal clicked()

  property string iconPath: ""
  property color iconColor: Theme.text
  property real iconRotation: 0
  property var command: null
  property color baseColor: "transparent"
  property color hoverColor: Qt.alpha("grey", "0.08")
  property Item focusLeft: null
  property Item focusRight: null
  property Item focusUp: null
  property Item focusDown: null
  property bool activeOverride: false

  readonly property bool active: btnHover.hovered || activeFocus || activeOverride

  onClicked: {
    if (root.command !== undefined && root.command !== null) {
      Quickshell.execDetached(root.command)
    }
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

  Rectangle {
    id: btn

    color: root.baseColor
    implicitHeight: root.height
    implicitWidth: root.width
    Layout.fillHeight: true

    HoverHandler {
      id: btnHover
    }

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: {
        root.clicked()
      }
    }

    Rectangle {
      color: (btnHover.hovered || root.activeFocus) ? root.hoverColor : root.baseColor
      implicitWidth: parent.width * 0.8
      implicitHeight: parent.height * 0.8
      radius: parent.height * 0.2
      anchors.centerIn: parent
      Behavior on color {
        ColorAnimation {
          duration: Theme.colorAnimationDuration
        }
      }
    }

    IconImage {
      id: icon
      anchors.centerIn: parent
      implicitSize: btn.height * 0.5
      mipmap: true
      source: Qt.resolvedUrl(root.iconPath)
      rotation: root.iconRotation
      layer.enabled: true
      layer.effect: MultiEffect {
        colorization: 1.00
        colorizationColor: root.iconColor // qmllint disable unqualified
        Behavior on colorizationColor {
          ColorAnimation {
            duration: Theme.colorAnimationDuration
          }
        }
      }
    }
  }
}
