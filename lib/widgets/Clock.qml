import QtQuick
import "../.."

Item {
  id: root

  property int interval: 1000

  implicitWidth: clockText.implicitWidth

  Text {
    id: clockText
    text: Qt.formatDateTime(new Date(), "HH:mm")
    anchors.centerIn: parent
    color: Theme.text
    font.family: Theme.font
    font.pixelSize: Theme.fontSize
    font.weight: Theme.fontWeight
  }

  Timer {
    interval: root.interval
    running: true
    repeat: true
    onTriggered: {
      clockText.text = Qt.formatDateTime(new Date(), "HH:mm")
    }
  }
}
