import QtQuick
import "../.."

Item {
  id: root

  property int interval: 1000
  property string timeStr: "HH:mm"
  property string altTimeStr: "HH:mm:ss"

  implicitWidth: clockText.implicitWidth + Theme.horizMargin
  implicitHeight: Theme.barHeight
  
  clip: true

  HoverHandler {
    id: hover
    onHoveredChanged: {
      clockText.text = Qt.formatDateTime(new Date(), (hovered ? root.altTimeStr : root.timeStr))
    }
  }

  StyledText {
    id: clockText
    text: Qt.formatDateTime(new Date(), (hover.hovered ? root.altTimeStr : root.timeStr))
    anchors.centerIn: parent
  }

  Timer {
    interval: root.interval
    running: true
    repeat: true
    onTriggered: {
      clockText.text = Qt.formatDateTime(new Date(), (hover.hovered ? root.altTimeStr : root.timeStr))
    }
  }

  Behavior on implicitWidth {
    NumberAnimation {
      duration: Theme.animationDuration
      easing: Theme.animationEasing
    }
  }
}
