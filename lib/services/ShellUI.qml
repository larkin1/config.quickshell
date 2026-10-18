pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: ui

  property string mode: "none"
  property string multiMenu: "" // see ../multiCenter/MultiUI.qml for a list of options

  readonly property bool anyOverlay: mode !== "none"
  readonly property bool multiOpen: mode === "multi"
  readonly property bool powerOpen: mode === "power"

  function close() {
    mode = "none"
    multiMenu = ""
  }

  function openMulti(menu) {
    multiMenu = menu ?? ""
    mode = "multi"
  }
  function openPower() {
    mode = "power"
  }

  function toggleMulti(menu) {
    if (mode === "multi") close()
    else openMulti(menu)
  }
  function togglePower() {
    if (mode === "power") close()
    else openPower()
  }

  IpcHandler {
    target: "screens"
    function close(): void { ui.close() }
    function toggleMulti(): void { ui.toggleMulti("") }
    function openMulti(menu: string): void { ui.openMulti(menu) }
    function togglePower(): void { ui.togglePower() }
    function openPower(): void { ui.openPower() }
  }
}
