pragma Singleton

import QtQuick
import Quickshell.Bluetooth
import Quickshell.Io
import Quickshell

import "../.."

Singleton {
  readonly property var devices: Bluetooth.defaultAdapter?.devices.values // qmllint disable unresolved-type
  readonly property bool discovering: Bluetooth.defaultAdapter?.discovering ?? false // qmllint disable unresolved-type
  readonly property bool powered: Bluetooth.defaultAdapter?.enabled ?? false // qmllint disable unresolved-type

  function toggle_connection(d) {
    if (d.state === BluetoothDeviceState.Connecting || d.state === BluetoothDeviceState.Disconnecting || d.pairing)
      return;
    if (d.connected)
      d.disconnect();
    else if (d.paired)
      d.connect();
    else
      d.pair();
  }

  function toggle_trust(d) {
    // deviceList.currentItem.trusted = !deviceList.currentItem.trusted;
    d.trusted = !d.trusted;
  }

  function unpair(d) {
    d.forget();
  }

  function toggle_power() {
    if (!Bluetooth.defaultAdapter) // qmllint disable unresolved-type
      return;
    Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled; // qmllint disable unresolved-type
  }

  function discover(t = 30 * 1000) {
    if (!Bluetooth.defaultAdapter) // qmllint disable unresolved-type
      return;
    Bluetooth.defaultAdapter.discovering = true; // qmllint disable unresolved-type
    scanTimeout.interval = t;
    scanTimeout.restart();
  }

  Timer {
    id: scanTimeout
    interval: 30 * 1000
    running: false
    onTriggered: {
      Bluetooth.defaultAdapter.discovering = false; // qmllint disable unresolved-type
    }
  }

  Process {
    running: true
    command: ["bluetoothctl", "--agent", "NoInputNoOutput"]
    stdout: SplitParser {
      onRead: data => {}
    }
    stderr: SplitParser {
      onRead: data => {}
    }
  }
}
