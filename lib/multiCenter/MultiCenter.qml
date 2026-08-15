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
        screens.close()
      }
    } else {
      openAnim.stop()
      window.visible = false
      background.implicitHeight = 1
      grab.active = false
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

      color: Theme.backgroundBlur
      bottomLeftRadius: Theme.vertMargin
      bottomRightRadius: Theme.vertMargin

      // Keys.onEscapePressed: {
      //   ShellUI.close()
      // }
      Keys.onPressed: event => {
        switch (event.key) {
          case Qt.Key_Escape:
            ShellUI.close();
            event.accepted = true;
            console.log("closed menu via keybind")
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

        Keys.onPressed: event => {
          switch (event.key) {
            case Qt.Key_H:
            case Qt.Key_Left:
              powerButton.forceActiveFocus(); break
            case Qt.Key_J:
            case Qt.Key_Down:
              powerButton.forceActiveFocus(); break
            case Qt.Key_K:
            case Qt.Key_Up:
              powerButton.forceActiveFocus(); break
            case Qt.Key_L:
            case Qt.Key_Left:
              powerButton.forceActiveFocus(); break
            case Qt.Key_P:
              powerButton.clicked(); break
            case Qt.Key_B:
              bluetoothButton.clicked(); break
          }
        }

        IconButton {
          id: powerButton
          Layout.column: 0
          Layout.row: 0
          implicitHeight: 100
          activeBtnPath: "../../svg/power-button-active.svg"
          inactiveBtnPath: "../../svg/power-button-inactive.svg"
          openAnimation: false
          visible: screens.uiState == ""
          onClicked: {
            ShellUI.openPower()
          }

          focusRight: bluetoothButton
        }

        IconButton {
          id: bluetoothButton
          Layout.column: 1
          Layout.row: 0
          implicitHeight: 100
          activeBtnPath: "../../svg/bt-active.svg"
          inactiveBtnPath: "../../svg/bt-inactive.svg"
          openAnimation: false
          visible: screens.uiState == ""
          onClicked: {
            screens.openTest()
          }

          focusLeft: powerButton
        }
      }
    }
  }

  SequentialAnimation {
    id: openAnim
    PauseAnimation { duration: Theme.animationDuration }
    PropertyAction {
      target: window
      property: "visible"
      value: true
    }
    PropertyAction {
      target: buttons
      property: "opacity"
      value: 0
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
