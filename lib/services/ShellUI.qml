pragma Singleton
import QtQuick
import Quickshell.Io

Item {
  id: ui

  property string mode: "none"

  readonly property bool anyOverlay: mode !== "none"
  readonly property bool multiOpen: mode === "multi"
  readonly property bool powerOpen: mode === "power"

  function close() {
    mode = "none"
  }

  function openMulti() {
    mode = "multi"
  }
  function openPower() {
    mode = "power"
  }

  function toggleMulti() {
    if (mode === "multi") mode = "none"
    else mode = "multi"
  }
  function togglePower() {
    if (mode === "power") mode = "none"
    else mode = "power"
  }

  IpcHandler {
    target: "screens"
    function close():        void { ui.close() }
    function toggleMulti():  void { ui.toggleMulti() }
    function openMulti():    void { ui.openMulti() }
    function togglePower():  void { ui.togglePower() }
    function openPower():    void { ui.openPower() }
  }
}
