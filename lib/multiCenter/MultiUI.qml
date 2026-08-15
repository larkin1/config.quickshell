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

  BluetoothMenu {
    id: test
    visible: root.uiState == "bluetooth"
  }
}
