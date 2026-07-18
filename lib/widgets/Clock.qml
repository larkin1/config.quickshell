import QtQuick
import Quickshell.Io

Text {
  required property string fontFamily
  required property int fontWeight
  required property int fontSize
  required property color fontColor
  property int interval: 1000

  id: root
  text: "ERROR" // same length as 00:00 for spacing; displays ERROR if the command doesn't run correctly
  color: fontColor
  font.family: fontFamily
  font.weight: fontWeight
  font.pixelSize: fontSize

  Process {
    id: dateproc
    command: ["date", "+%H:%M"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: root.text = this.text.trim()
    }
  }

  Timer {
    interval: interval
    running: true
    repeat: true
    onTriggered: {
      dateproc.running = true
    }
  }
}
