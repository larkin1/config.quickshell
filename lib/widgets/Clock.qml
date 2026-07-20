import QtQuick
import "../.."

Item {
  id: root

  property int interval: 1000
  property string timeStr: "HH:mm"

  implicitWidth: clockText.implicitWidth

  StyledText {
    id: clockText
    text: Qt.formatDateTime(new Date(), root.timeStr)
    anchors.centerIn: parent
  }

  Timer {
    interval: root.interval
    running: true
    repeat: true
    onTriggered: {
      clockText.text = Qt.formatDateTime(new Date(), root.timeStr)
    }
  }
}
