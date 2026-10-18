import QtQuick
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

  function openMenu(name) {
    switch (name) {
      case "bluetooth": openBluetooth(); break
      case "audio": openAudio(); break
      case "launcher": openLauncher(); break
      default: close()
    }
  }
}
