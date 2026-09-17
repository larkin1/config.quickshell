pragma Singleton

import QtQuick
import Quickshell.Io
import "../.."

Item {
  id: root
  property bool recording: false

  function toggle() {
    rec.running = true
  }

  Process {
    id: rec
    command: ["sh", "-c", "$HOME/.config/quickshell/lib/multiCenter/screenRec.sh"]
    onRunningChanged: {
      poll.running = true
      ShellUI.close()
    }
  }

  Timer {
    id: pollLoop
    interval: 1000
    onTriggered: poll.running = true
    running: true
    repeat: true
  }

  Process {
    id: poll
    command: ["pgrep", "-x", "wf-recorder"]
    onExited: code => root.recording = (code === 0) //qmllint disable signal-handler-parameters
  }

  IpcHandler {
    target: "record"
    function toggle(): void { root.toggle() }
  }
}
