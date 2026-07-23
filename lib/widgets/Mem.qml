import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Widgets
import "../.."

Item {
  id: root
  implicitWidth: memRow.implicitWidth

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

  RowLayout {
    id: memRow
    height: Theme.barHeight
    anchors.centerIn: parent

    IconImage {
      id: memIcon
      implicitSize: Theme.iconSize
      mipmap: true
      source: Qt.resolvedUrl("../../svg/memory.svg")
    }

    StyledText {
      id: memText
      text: root.memUsage + "%"
      color: (root.memUsage > 90)? Theme.red : (
             (root.memUsage > 75)? Theme.peach : (
             (root.memUsage > 50)? Theme.yellow : Theme.text
      ))
    }
  }
}
