import QtQuick
import Quickshell.Io
import "../.."

Item {
  id: root
  implicitWidth: cpuText.implicitWidth

  property int interval: 1000

  property int memUsage: 0

  Process {
    id: proc
    command: ["sh", "-c", "free | grep Mem"]
    stdout: SplitParser {
      onRead: data => {
        if (!data) return
        var parts = data.trim().split(/\s+/)
        var total = parseInt(parts[1]) || 1
        var used = parseInt(parts[2]) || 0
        root.memUsage = Math.round(100 * used / total)
      }
    }
  }

  Timer {
    id: timer
    interval: root.interval
    running: true
    repeat: true
    onTriggered: proc.running = true
  }

  StyledText {
    id: cpuText
    text: "󰘚 " + root.memUsage + "%"
    anchors.centerIn: parent
    // color: Theme.text
    color: (root.memUsage > 90)? Theme.red : (
           (root.memUsage > 75)? Theme.peach : (
           (root.memUsage > 50)? Theme.yellow : Theme.text
    ))
  }
}
