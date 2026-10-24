import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Widgets
import "../.."

Item {
  id: root
  implicitWidth: memRow.implicitWidth

  property int interval: 1000

  property double memUsage: 0

  FileView {
    id: proc
    path: "/proc/meminfo"
    watchChanges: false
    onLoaded: parse()

    function parse() {
      const lines = text().split("\n")
      let total = 0, avail = 0
      for (const line of lines) {
        if (line.startsWith("MemTotal:")) total = parseInt(line.replace(/\D+/g, "")) || 0
        if (line.startsWith("MemAvailable:")) avail = parseInt(line.replace(/\D+/g, "")) || 0
      }
      root.memUsage = total ? Math.round(((total-avail)/total * 100)) : 0
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
    id: memRow
    height: Theme.barHeight
    anchors.centerIn: parent

    IconImage {
      id: memIcon
      implicitSize: Theme.iconSize
      mipmap: true
      source: Qt.resolvedUrl("../../svg/memory.svg")
      layer.enabled: true
      layer.effect: MultiEffect {
        colorization: 1.00
        colorizationColor: Qt.tint(Colors.md3.on_surface, Qt.alpha(Colors.md3.error, root.memUsage/100)) // qmllint disable unqualified
      }
    }

    StyledText {
      id: memText
      text: root.memUsage + "%"
      color: Qt.tint(Colors.md3.on_surface, Qt.alpha(Colors.md3.error, root.memUsage/100))
    }
  }
}
