import QtQuick
import Quickshell.Io
import Quickshell.Services.Mpris

Text {
  required property string fontFamily
  required property int fontWeight
  required property int fontSize
  required property color fontColor
  property int interval: 1000

  id: root
  text: "No Media"
  color: fontColor
  font.family: fontFamily
  font.weight: fontWeight
  font.pixelSize: fontSize

  Process {
    id: songproc
    command: ["playerctl", "-a", "'{{markup_escape(title)}} - {{markup_escape(artist)}}'"]
    running: true
    stdout: SplitParser { 
      onRead: data => {
        if (!data) return
      }
    }
  }

  Timer {
    interval: interval
    running: true
    repeat: true
    onTriggered: {
      songproc.running = true
    }
  }
}
