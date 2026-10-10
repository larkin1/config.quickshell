import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Widgets
import "../.."

Item {
  id: root
  implicitWidth: cpuRow.implicitWidth

  property int interval: 1000

  property int cpuUsage: 0
  property var lastCpuIdle: 0
  property var lastCpuTotal: 0

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

  RowLayout {
    id: cpuRow
    height: Theme.barHeight
    anchors.centerIn: parent

    IconImage {
      id: cpuIcon
      implicitSize: Theme.iconSize
      mipmap: true
      source: Qt.resolvedUrl("../../svg/cpu.svg")
      layer.enabled: true
      layer.effect: MultiEffect {
        colorization: 1.00
        colorizationColor: (root.cpuUsage > 90)? Colors.md3.on_error : (root.cpuUsage > 50)? Colors.md3.error : Colors.md3.on_surface // qmllint disable unqualified
      }
    }

    StyledText {
      id: cpuText
      text: root.cpuUsage + "%"
      color: (root.cpuUsage > 90)? Colors.md3.on_error :
             (root.cpuUsage > 50)? Colors.md3.error : Colors.md3.on_surface
    }
  }
}
