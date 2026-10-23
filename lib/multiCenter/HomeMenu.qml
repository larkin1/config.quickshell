import QtQuick
import QtQuick.Layouts
import "../.."

Item {
  id: root
  anchors.fill: parent

  onVisibleChanged: {
    root.opacity = 0.0
    if (visible) {
      root.forceActiveFocus()
      fadeIn.restart()
    }
  }

  SequentialAnimation {
    id: fadeIn
    PauseAnimation { duration: Theme.animationDuration*2 }
    PropertyAnimation {
      target: root
      property: "opacity"
      duration: Theme.animationDuration
      from: 0.0
      to: 1.0
    }
  }

  Keys.onPressed: event => {
    switch (event.key) {
      case Qt.Key_Space:
        Media.currentPlayer?.togglePlaying()
        event.accepted = true; break
      case Qt.Key_H:
      case Qt.Key_Left:
        powerButton.forceActiveFocus()
        event.accepted = true; break
      case Qt.Key_J:
      case Qt.Key_Down:
        powerButton.forceActiveFocus()
        event.accepted = true; break
      case Qt.Key_K:
      case Qt.Key_Up:
        powerButton.forceActiveFocus()
        event.accepted = true; break
      case Qt.Key_L:
      case Qt.Key_Right:
        powerButton.forceActiveFocus()
        event.accepted = true; break
      case Qt.Key_P:
        powerButton.clicked()
        event.accepted = true; break
      case Qt.Key_B:
        bluetoothButton.clicked()
        event.accepted = true; break
      case Qt.Key_A:
        audioButton.clicked()
        event.accepted = true; break
      case Qt.Key_S:
        screenRecButton.clicked()
        event.accepted = true; break
      case Qt.Key_R:
        launcherButton.clicked()
        event.accepted = true; break
    }
  }

  GridLayout {
    id: buttons

    readonly property int buttonHeight: root.width/5

    rowSpacing: Theme.margin
    columnSpacing: Theme.margin
    anchors.centerIn: parent

    rows: 3
    columns: 3

    IconButton {
      id: powerButton
      Layout.column: 0
      Layout.row: 0
      implicitHeight: parent.buttonHeight
      iconPath: "../../svg/power-button.svg"
      onClicked: {
        ShellUI.openPower()
      }
      focusRight: bluetoothButton
      focusDown: launcherButton
    }

    IconButton {
      id: bluetoothButton
      Layout.column: 1
      Layout.row: 0
      implicitHeight: parent.buttonHeight
      iconPath: "../../svg/bt.svg"
      onClicked: {
        ShellUI.multiMenu = "bluetooth"
      }
      focusLeft: powerButton
      focusRight: audioButton
      focusDown: screenRecButton
    }

    IconButton {
      id: audioButton
      Layout.column: 2
      Layout.row: 0
      implicitHeight: parent.buttonHeight
      iconPath: "../../svg/speaker.svg"
      onClicked: {
        ShellUI.multiMenu = "audio"
      }
      focusLeft: bluetoothButton
    }

    IconButton {
      id: screenRecButton
      Layout.column: 1
      Layout.row: 1
      implicitHeight: parent.buttonHeight
      iconPath: Record.recording ? "../../svg/video.svg" : "../../svg/novideo.svg"
      focusUp: bluetoothButton
      focusLeft: launcherButton
      onClicked: {
        Record.toggle()
      }
    }

    IconButton {
      id: launcherButton
      Layout.column: 0
      Layout.row: 1
      implicitHeight: parent.buttonHeight
      iconPath: "../../svg/apps.svg"
      onClicked: {
        ShellUI.multiMenu = "launcher"
      }
      focusRight: screenRecButton
      focusUp: powerButton
    }
  }
}
