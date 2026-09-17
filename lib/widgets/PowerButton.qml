import QtQuick
import Quickshell.Widgets
import "../.."

Item {
  id: root
  signal clicked()

  implicitWidth: powerButton.width
  height: Theme.barHeight

  property var activeIcon: Qt.resolvedUrl("../../svg/power-button-active.svg")
  property var inactiveIcon: Qt.resolvedUrl("../../svg/power-button-inactive.svg")

  readonly property bool rec: Record.recording

  onRecChanged: {
    if (rec) {
      recOn.restart()
    } else {
      recOff.restart()
    }
  }

  SequentialAnimation {
    id: recOff
    NumberAnimation {
      duration: 100
      targets: [iconInactive, iconActive]
      property: "rotation"
      from: 0
      to: -180
    }
    ScriptAction {
      script: {
        root.activeIcon = Qt.resolvedUrl("../../svg/power-button-active.svg")
        root.inactiveIcon = Qt.resolvedUrl("../../svg/power-button-inactive.svg")
      }
    }
    NumberAnimation {
      duration: 100
      targets: [iconInactive, iconActive]
      property: "rotation"
      from: -180
      to: -360
    }
  }

  SequentialAnimation {
    id: recOn
    NumberAnimation {
      duration: 100
      targets: [iconInactive, iconActive]
      property: "rotation"
      from: 0
      to: 180
    }
    ScriptAction {
      script: {
        root.activeIcon = Qt.resolvedUrl("../../svg/video-active.svg")
        root.inactiveIcon = Qt.resolvedUrl("../../svg/video-active.svg")
      }
    }
    NumberAnimation {
      duration: 100
      targets: [iconInactive, iconActive]
      property: "rotation"
      from: 180
      to: 360
    }
  }

  Rectangle {
    id: powerButton
    width: Theme.barHeight
    height: Theme.barHeight
    radius: Theme.barHeight / 2
    color: Theme.surface2
    anchors.centerIn: parent

    IconImage {
      id: iconInactive
      anchors.centerIn: parent
      implicitSize: Theme.iconSize
      mipmap: true
      source: root.inactiveIcon
      opacity: powerHover.hovered ? 0 : 1
      Behavior on opacity {
        NumberAnimation {
          duration: Theme.colorAnimationDuration
        }
      }
    }

    IconImage {
      id: iconActive
      anchors.centerIn: parent
      implicitSize: Theme.iconSize
      mipmap: true
      source: root.activeIcon
      opacity: powerHover.hovered ? 1 : 0
      Behavior on opacity {
        NumberAnimation {
          duration: Theme.colorAnimationDuration
        }
      }
    }

    HoverHandler {
      id: powerHover
      cursorShape: Qt.PointingHandCursor
    }

    MouseArea {
      id: mouse
      anchors.fill: parent
      onClicked: root.clicked()
      cursorShape: Qt.PointingHandCursor
    }
  }
}
