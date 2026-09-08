import Quickshell.Bluetooth
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../.."

Item {
  id: root
  anchors.fill: parent

  onVisibleChanged: {
    if (visible) {
      focusedDev = devices?.length ? devices[0] : null
      root.forceActiveFocus()
    }
  }

  property var devices: Bluetooth.defaultAdapter?.devices.values; // qmllint disable unresolved-type

  Process {
    running: true
    command: ["bluetoothctl", "--agent", "NoInputNoOutput"]
  }

  // -- Focus Management --
  property var focusedDev: null
  readonly property int selectedIdx: devices ? devices.findIndex(d => d === focusedDev) : -1
  property int lastKnownIdx: 0

  onSelectedIdxChanged: {
    menuState = noState
    if (selectedIdx !== -1) lastKnownIdx = selectedIdx
  }

  onDevicesChanged: if (selectedIdx === -1 && devices?.length > 1) focusedDev = devices[Math.min(lastKnownIdx, devices.length - 1)]

  function moveUp() {
    if (selectedIdx === -1) {
      root.focusedDev = devices[0]; return
    }
    if (selectedIdx === 0) {
      root.focusedDev = devices[devices.length -1]; return
    }
    root.focusedDev = devices[selectedIdx - 1]
  }

  function moveDn() {
    if (selectedIdx === devices.length - 1 || selectedIdx === -1) {
      root.focusedDev = devices[0]; return
    }
    root.focusedDev = devices[selectedIdx + 1]
  }

  // -- State management --
  // state selection. changes states such as whether the user is being prompted to remove an item.
  readonly property int noState: 0
  readonly property int removeState: 1
  property int menuState: 0

  // -- Keyboard Shortcuts --
  Keys.onPressed: event => {
    if (event.modifiers === Qt.ShiftModifier) {
      handleShiftKeys(event)
    } else {
      handleKeys(event);
    }
  }

  function handleKeys(event) {
    switch (event.key) {
      case Qt.Key_Escape:
      case Qt.Key_Q:
        if (menuState !== noState) {
          menuState = noState
          event.accepted = true;
        }
        break;
      case Qt.Key_P:
        Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled // qmllint disable unresolved-type
        event.accepted = true; break;
      case Qt.Key_S:
        Bluetooth.defaultAdapter.discovering = true // qmllint disable unresolved-type
        scanTimeout.restart()
        event.accepted = true; break;

      case Qt.Key_J:
      case Qt.Key_Down:
        root.moveDn()
        event.accepted = true; break;
      case Qt.Key_K:
      case Qt.Key_Up:
        root.moveUp()
        event.accepted = true; break;
      case Qt.Key_D:
      case Qt.Key_X:
      case Qt.Key_Delete:
        menuState = removeState
        event.accepted = true; break;
      case Qt.Key_Return:
      case Qt.Key_Space:
        toggle(focusedDev)
        event.accepted = true; break;
      case Qt.Key_Y:
        if (menuState === removeState) focusedDev.forget()
        menuState = noState
        event.accepted = true; break;
      case Qt.Key_N:
        menuState = noState
        event.accepted = true; break;
      case Qt.Key_T:
        focusedDev.trusted = !focusedDev.trusted
        event.accepted = true; break;
    }
  }

  function handleShiftKeys(event) {
    switch (event.key) {
      case Qt.Key_J:
        root.focusedDev = devices[devices.length -1]
        event.accepted = true; break;
      case Qt.Key_K:
        root.focusedDev = devices[0]
        event.accepted = true; break;
      case Qt.Key_D:
      case Qt.Key_X:
        Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled // qmllint disable unresolved-type
        event.accepted = true; break;
    }
  }

  function toggle(d) {
    if (d.state === BluetoothDeviceState.Connecting
      || d.state === BluetoothDeviceState.Disconnecting
      || d.pairing)
      return

    if (d.connected) d.disconnect()
    else if (d.paired) d.connect()
    else d.pair()
  }

  Timer {
    id: scanTimeout
    interval: 30*1000
    running: false
    onTriggered: {
      Bluetooth.defaultAdapter.discovering = false // qmllint disable unresolved-type
    }
  }

  ColumnLayout {
    implicitWidth: parent.width - (Theme.horizMargin*2)
    implicitHeight: parent.height - (Theme.vertMargin*2)
    anchors.centerIn: parent
    spacing: Theme.vertMargin

    Rectangle {
      id: actionsBar
      implicitHeight: (root.height - (Theme.vertMargin*2)) / 13
      implicitWidth: parent.width
      color: Theme.mantle
      radius: Theme.vertMargin

      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.horizMargin
        anchors.rightMargin: Theme.horizMargin

        IconButton {
          Layout.alignment: Qt.AlignRight
          implicitHeight: actionsBar.height
          activeBtnPath: Bluetooth.defaultAdapter?.enabled ? "../../svg/bt-active.svg" : "../../svg/bt-off-active.svg" // qmllint disable unresolved-type
          inactiveBtnPath: Bluetooth.defaultAdapter?.enabled ? "../../svg/bt-inactive.svg" : "../../svg/bt-off.svg" // qmllint disable unresolved-type
          openAnimation: false

          onClicked: {
            Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled // qmllint disable unresolved-type
          }
        }

        Item { Layout.fillWidth: true }

        IconButton {
          id: scan
          implicitHeight: actionsBar.height
          activeBtnPath: "../../svg/reboot-active.svg"
          inactiveBtnPath: "../../svg/reboot-inactive.svg"
          openAnimation: false

          PropertyAnimation {
            target: scan
            property: "iconRotation"
            running: Bluetooth.defaultAdapter?.discovering // qmllint disable unresolved-type
            loops: Animation.Infinite
            duration: 2500
            from: 0
            to: 360
          }

          onClicked: {
            Bluetooth.defaultAdapter.discovering = true // qmllint disable unresolved-type
            scanTimeout.restart()
          }
        }
      }
    }

    Rectangle {
      implicitHeight: (root.height - (Theme.vertMargin*2)) - actionsBar.implicitHeight - parent.spacing
      implicitWidth: parent.width
      color: Theme.mantle
      radius: Theme.vertMargin

      ScrollView {
        anchors.topMargin: Theme.vertMargin
        anchors.leftMargin: Theme.horizMargin
        anchors.rightMargin: Theme.horizMargin
        anchors.bottomMargin: Theme.horizMargin
        anchors.fill: parent
        clip: true

        ColumnLayout {
          id: devicesLayout
          implicitWidth: parent.width

          Repeater {
            id: deviceRepeater
            implicitWidth: parent.width
            model: root.devices

            Rectangle {
              id: deviceRow
              radius: Theme.vertMargin

              color: removalMode ? Theme.red : focused || deviceRowHover.hovered ? Theme.surface1 : Theme.surface0

              implicitWidth: parent.width
              implicitHeight: deviceText.implicitHeight*2

              required property int index
              required property var modelData

              property bool focused: (root.focusedDev === modelData) // qmllint disable unqualified
              property bool removalMode: (root.menuState === root.removeState && focused) // qmllint disable unqualified

              HoverHandler { id: deviceRowHover }
              MouseArea {
                anchors.fill: parent
                onClicked: root.toggle(deviceRow.modelData) //qmllint disable unqualified
                cursorShape: Qt.PointingHandCursor
              }

              RowLayout {
                anchors.leftMargin: Theme.horizMargin
                anchors.rightMargin: Theme.horizMargin
                anchors.fill: parent
                spacing: 0

                StyledText {
                  id: deviceText
                  text: deviceRow.removalMode ? "Remove device?" : deviceRow.modelData.name
                  elide: Qt.ElideRight
                  Layout.preferredWidth: deviceRow.width - deviceRow.height*4
                  color: {
                    if (deviceRow.removalMode) return Theme.surface0
                    else if (deviceRow.modelData.connected) return Theme.cyclingColor
                    else if (deviceRow.modelData.paired) return Theme.text
                    else return Theme.overlay0
                  }
                }

                Item { Layout.fillWidth: true }

                IconButton {
                  Layout.alignment: Qt.AlignRight
                  implicitHeight: deviceRow.height
                  activeBtnPath: deviceRow.removalMode ? "../../svg/check-active.svg" : deviceRow.modelData.trusted ? "../../svg/shield-check-active.svg" : "../../svg/shield-cross-active.svg"
                  inactiveBtnPath: deviceRow.removalMode ? "../../svg/check-inactive.svg" : deviceRow.modelData.trusted ? "../../svg/shield-check-inactive.svg" : "../../svg/shield-cross-inactive.svg"
                  openAnimation: false

                  onClicked: {
                    if (deviceRow.removalMode) {
                      deviceRow.modelData.forget() // qmllint disable missing-property
                      root.menuState = noState // qmllint disable unqualified
                    } else {
                      deviceRow.modelData.trusted = !deviceRow.modelData.trusted
                    }
                  }
                }

                IconButton {
                  implicitHeight: deviceRow.height
                  activeBtnPath: deviceRow.removalMode ? "../../svg/cross-active.svg" : "../../svg/trash-active.svg"
                  inactiveBtnPath: deviceRow.removalMode ? "../../svg/cross-inactive.svg" : "../../svg/trash-inactive.svg"
                  openAnimation: false

                  onClicked: {
                    if (deviceRow.removalMode) {
                      root.menuState = noState // qmllint disable unqualified
                    } else {
                      root.focusedDev = deviceRow.modelData // qmllint disable unqualified
                      root.menuState = removeState // qmllint disable unqualified
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
