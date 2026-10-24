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

  FileView {
    id: proc
    path: "/proc/stat"
    watchChanges: false
    onLoaded: parse()

    function parse() {
      const p0 = text().slice(0, text().indexOf("\n"));
      const p = p0.trim().split(/\s+/)
      var idle = parseInt(p[4]) + parseInt(p[5])
      var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)
      if (root.lastCpuTotal > 0) {
          root.cpuUsage = Math.round(100 * (1 - (idle - root.lastCpuIdle) / (total - root.lastCpuTotal)))
      }
      root.lastCpuTotal = total
      root.lastCpuIdle = idle
    }
  }

  Timer {
    id: timer
    interval: root.interval
    running: true
    repeat: true
    onTriggered: proc.reload()
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
        colorizationColor: Qt.tint(Colors.md3.on_surface, Qt.alpha(Colors.md3.error, root.cpuUsage/100)) // qmllint disable unqualified
      }
    }

    StyledText {
      id: cpuText
      text: root.cpuUsage + "%"
      color: Qt.tint(Colors.md3.on_surface, Qt.alpha(Colors.md3.error, root.cpuUsage/100))
    }
  }
}
