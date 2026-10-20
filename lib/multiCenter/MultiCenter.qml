import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../.."

Item {
  id: root

  implicitWidth: parent.width
  visible: open

  required property int expandedWidth
  readonly property bool onFocusedScreen:
    Hyprland.focusedMonitor?.name ===
    QsWindow.window?.screen.name // qmllint disable missing-property
  readonly property bool open: ShellUI.multiOpen && onFocusedScreen

  onOpenChanged: {
    if (open) {
      if (Hyprland.focusedMonitor) {
        window.visible = false
        openAnim.start()
        grab.active = true;
        buttons.forceActiveFocus()
        screens.openMenu(ShellUI.multiMenu)
      }
    } else {
      openAnim.stop()
      window.visible = false
      background.implicitHeight = 1
      grab.active = false
    }
  }

  Connections {
    target: ShellUI
    function onMultiMenuChanged() {
      if (root.open) screens.openMenu(ShellUI.multiMenu)
    }
  }

  PopupWindow {
    id: window

    visible: false
    color: "transparent"
    implicitWidth: root.expandedWidth
    implicitHeight: 500
    anchor.item: root
    anchor.rect.x: 0
    anchor.rect.y: root.height

    Rectangle {
      id: background
      implicitWidth: parent.width
      anchors.top: parent.top

      color: Colors.md3.surface
      bottomLeftRadius: Theme.radius
      bottomRightRadius: Theme.radius

      Keys.onPressed: event => {
        switch (event.key) {
          case Qt.Key_Escape:
          case Qt.Key_Q:
            ShellUI.close();
            event.accepted = true;
        }
      }

      MultiUI {
        id: screens
      }

      GridLayout {
        id: buttons

        anchors.centerIn: parent
        rowSpacing: 10
        columnSpacing: 10

        rows: 3
        columns: 3
        readonly property int buttonHeight: 100

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

        IconButton {
          id: powerButton
          Layout.column: 0
          Layout.row: 0
          implicitHeight: parent.buttonHeight
          iconPath: "../../svg/power-button.svg"
          visible: screens.uiState == ""
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
          visible: screens.uiState == ""
          onClicked: {
            screens.openBluetooth()
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
          visible: screens.uiState == ""
          onClicked: {
            screens.openAudio()
          }
          focusLeft: bluetoothButton
        }

        IconButton {
          id: screenRecButton
          Layout.column: 1
          Layout.row: 1
          implicitHeight: parent.buttonHeight
          iconPath: Record.recording ? "../../svg/video.svg" : "../../svg/novideo.svg"
          visible: screens.uiState == ""
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
          visible: screens.uiState == ""
          onClicked: {
            screens.openLauncher()
          }
          focusRight: screenRecButton
          focusUp: powerButton
        }
      }
    }
  }

  SequentialAnimation {
    id: openAnim
    PropertyAction {
      target: window
      property: "visible"
      value: true
    }
    PropertyAction {
      targets: [ buttons, background ]
      property: "opacity"
      value: 0
    }
    PauseAnimation { duration: Theme.animationDuration }
    ScriptAction { script: window.anchor.updateAnchor() }
    PropertyAction {
      target: background
      property: "opacity"
      value: 1
    }
    PropertyAnimation {
      target: background
      property: "implicitHeight"
      duration: Theme.animationDuration
      from: root.height
      to: 500
    }
    PropertyAnimation {
      target: buttons
      property: "opacity"
      duration: Theme.animationDuration
      to: 1
    }
  }

  HyprlandFocusGrab {
    id: grab
    windows: [window]
  }
  Connections {
    target: grab
    function onCleared() { ShellUI.close() }
  }
}
