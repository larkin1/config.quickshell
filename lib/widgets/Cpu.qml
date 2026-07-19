import QtQuick
import Quickshell.Io
import "../.."

Item {
  id: root
  implicitWidth: cpuText.implicitWidth

  property int cpuUsage: 0
  property var lastCpuIdle: 0
  property var lastCpuTotal: 0

  property int interval: 1000

  Process {
    id: proc
    command: ["sh", "-c", "head -1 /proc/stat"]
    stdout: SplitParser {
      onRead: data => {
      if (!data) return
      var p = data.trim().split(/\s+/)
      var idle = parseInt(p[4]) + parseInt(p[5])
      var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)
      if (root.lastCpuTotal > 0) {
          root.cpuUsage = Math.round(100 * (1 - (idle - root.lastCpuIdle) / (total - root.lastCpuTotal)))
      }
      root.lastCpuTotal = total
      root.lastCpuIdle = idle
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

  Text {
    id: cpuText
    text: "󰍛 " + root.cpuUsage + "%"
    anchors.centerIn: parent
    color: Theme.text
    font.family: Theme.font
    font.pixelSize: Theme.fontSize
    font.weight: Theme.fontWeight
  }
}
