// pragma Singleton
import QtQuick
// import Quickshell.Io
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

  BluetoothMenu {
    id: bluetooth
    visible: root.uiState == "bluetooth"
  }

  AudioMenu {
    id: audio
    visible: root.uiState == "audio"
  }
}
