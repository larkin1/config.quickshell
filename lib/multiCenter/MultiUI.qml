import QtQuick
import "../.."

Item {
  id: root
  anchors.fill: parent

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
