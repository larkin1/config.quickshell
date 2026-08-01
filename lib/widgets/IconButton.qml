import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../.."

Item {
  id: root

  implicitHeight: parent.height
  implicitWidth: root.height

  signal clicked()

  property string activeBtnPath: ""
  property string inactiveBtnPath: ""
  property var command: null
  property color baseColor: "transparent"
  property color hoverColor: Qt.alpha("grey", "0.08")
  property int openDelay: 0
  property bool expanded: true
  property Item focusLeft: null
  property Item focusRight: null
  property Item focusUp: null
  property Item focusDown: null
  property bool openAnimation: true
  property var openAnimationEasing: Easing.InQuart

  onClicked: {
    if (root.command !== undefined && root.command !== null) {
      Quickshell.execDetached(root.command)
    }
  }

  onExpandedChanged: {
    if (expanded) {
      if (openAnimation) {
        open.start()
      } else {
        root.implicitWidth = root.height
        iconInactive.opacity = 1
      }
    } else {
      root.implicitWidth = 0
      iconInactive.opacity = 0
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
          duration: 200
        }
      }
    }

    IconImage {
      id: iconInactive
      anchors.centerIn: parent
      implicitSize: btn.height * 0.5
      mipmap: true
      source: Qt.resolvedUrl(root.inactiveBtnPath)
      opacity: (btnHover.hovered || root.activeFocus) ? 0 : 1
      Behavior on opacity {
        NumberAnimation {
          duration: Theme.colorAnimationDuration
        }
      }
    }

    IconImage {
      id: iconActive
      anchors.centerIn: parent
      implicitSize: btn.height * 0.5
      mipmap: true
      source: Qt.resolvedUrl(root.activeBtnPath)
      opacity: (btnHover.hovered || root.activeFocus) ? 1 : 0
      Behavior on opacity {
        NumberAnimation {
          duration: Theme.colorAnimationDuration
        }
      }
    }
  }

  SequentialAnimation {
    id: open
    PropertyAction {
      target: iconInactive
      property: "opacity"
      value: 0
    }
    PauseAnimation { duration: root.openDelay }
    PropertyAnimation {
      target: root
      property: "implicitWidth"
      easing: root.openAnimationEasing
      from: 0
      to: root.height
    }
    PropertyAnimation {
      target: iconInactive
      property: "opacity"
      duration: 400
      from: 0
      to: 1
    }
  }
}
