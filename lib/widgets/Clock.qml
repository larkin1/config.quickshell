import QtQuick
import Quickshell
import "../.."

Item {
  id: root

  property string timeStr: "HH:mm"
  property string altTimeStr: "HH:mm:ss"
  property var precision: SystemClock.Seconds

  implicitWidth: clockText.implicitWidth
  implicitHeight: Theme.barHeight

  clip: true

  HoverHandler {
    id: hover
  }

  SystemClock {
    id: clock
    precision: root.precision
  }

  StyledText {
    id: clockText
    text: Qt.formatDateTime(clock.date, (hover.hovered ? root.altTimeStr : root.timeStr))
    anchors.centerIn: parent
  }

  Behavior on implicitWidth {
    NumberAnimation {
      duration: Theme.animationDuration
      easing: Theme.animationEasing
    }
  }
}
