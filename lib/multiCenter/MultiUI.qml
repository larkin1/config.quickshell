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

  function openTest() {
    uiState = "test"
  }

  TestMenu {
    id: test
    visible: root.uiState == "test"
  }
}
