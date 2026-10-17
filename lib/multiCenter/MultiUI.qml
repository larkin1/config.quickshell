import QtQuick
import Quickshell.Io
import "../.."

Item {
  id: root

  anchors.fill: parent

  property string uiState: ""

  function close() {
    uiState = ""
  }

  function openBluetooth() {
    uiState = "bluetooth"
  }

  function openAudio() {
    uiState = "audio"
  }

  function openLauncher() {
    uiState = "launcher"
  }

  BluetoothMenu {
    id: bluetooth
    visible: root.uiState == "bluetooth"
  }

  AudioMenu {
    id: audio
    visible: root.uiState == "audio"
  }
  
  LauncherMenu {
    id: launcher
    visible: root.uiState == "launcher"
  }

  IpcHandler {
    target: "MultiCenter"
    function close():        void { ShellUI.close() }
    function launcher():     void { ShellUI.openMulti(); root.openLauncher() }
    function audio():        void { ShellUI.openMulti(); root.openAudio() }
    function bluetooth():    void { ShellUI.openMulti(); root.openBluetooth() }
  }
}
