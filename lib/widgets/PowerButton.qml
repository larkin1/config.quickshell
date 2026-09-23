import QtQuick
import QtQuick.Effects
import Quickshell.Widgets
import "../.."

Item {
  id: root
  signal clicked()

  implicitWidth: powerButton.width
  height: Theme.barHeight

  property var iconPath: Qt.resolvedUrl("../../svg/power-button.svg")
  property color iconColor: rec || powerHover.hovered ? Theme.red : Theme.text

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
      targets: iconInactive
      property: "rotation"
      from: 0
      to: -180
    }
    ScriptAction {
      script: {
        root.iconPath = Qt.resolvedUrl("../../svg/power-button.svg")
      }
    }
    NumberAnimation {
      duration: 100
      target: iconInactive
      property: "rotation"
      from: -180
      to: -360
    }
  }

  SequentialAnimation {
    id: recOn
    NumberAnimation {
      duration: 100
      target: iconInactive
      property: "rotation"
      from: 0
      to: 180
    }
    ScriptAction {
      script: {
        root.iconPath = Qt.resolvedUrl("../../svg/video.svg")
      }
    }
    NumberAnimation {
      duration: 100
      target: iconInactive
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
      source: root.iconPath
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

    HoverHandler {
      id: powerHover
    }

    MouseArea {
      id: mouse
      anchors.fill: parent
      onClicked: root.clicked()
      cursorShape: Qt.PointingHandCursor
    }
  }
}
