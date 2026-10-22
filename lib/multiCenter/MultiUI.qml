import QtQuick
import "../.."

Item {
  id: root
  anchors.fill: parent

  function focusCurrent() {
    ({ home, bluetooth, audio, launcher })[ShellUI.multiMenu]?.forceActiveFocus()
  }

  BluetoothMenu {
    id: bluetooth
    visible: ShellUI.multiMenu == "bluetooth"
  }

  AudioMenu {
    id: audio
    visible: ShellUI.multiMenu == "audio"
  }
  
  LauncherMenu {
    id: launcher
    visible: ShellUI.multiMenu == "launcher"
  }

  HomeMenu {
    id: home
    visible: ShellUI.multiMenu == "home"
  }
}
