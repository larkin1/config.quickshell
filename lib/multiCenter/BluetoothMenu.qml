import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../.."

Item {
  id: root
  anchors.fill: parent


  // -- State management --

  // selected item in the devices list
  property int devicesSelectedIdx: 0

  // zone selection. chooses which element has "focus"
  readonly property int headerZone: 0
  readonly property int listZone: 1
  property int currentZone: 0

  // state selection. changes states such as whether the user is being prompted to remove an item.
  readonly property int noState: 0
  readonly property int removeState: 1
  property int menuState: 0

  onCurrentZoneChanged: { menuState = noState }
  onDevicesSelectedIdxChanged: { menuState = noState }

  onVisibleChanged: {
    if (visible) {
      devicesSelectedIdx = 0
      currentZone = listZone
      root.forceActiveFocus()
    }
  }


  // -- Bluetooth management --
  property var devices: Bluetooth.defaultAdapter?.devices; // qmllint disable unresolved-type

  // Keyboard Shortcuts

  function handleCommonKeys(event) {
    switch (event.key) {

      case Qt.Key_Escape:
        if (menuState !== noState) {
          menuState = noState
          event.accepted = true;
        }
        break;

      case Qt.Key_Slash:
        break;

      case Qt.Key_P:
        Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled // qmllint disable unresolved-type
        event.accepted = true; break;

      case Qt.Key_S:
        Bluetooth.defaultAdapter.discovering = true // qmllint disable unresolved-type
        scanTimeout.restart()
        event.accepted = true; break;
    }
  }

  function handleHeaderKeys(event) {
    switch (event.key) {

      case Qt.Key_H:
      case Qt.Key_Left:
        currentZone = listZone;
        event.accepted = true; break;
      case Qt.Key_L:
      case Qt.Key_Right:
        currentZone += 1
        event.accepted = true; break;
    }
  }

  function handleListKeys(event) {
    switch (event.key) {

      case Qt.Key_H:
      case Qt.Key_Left:
        currentZone -= 1
        event.accepted = true; break;
      case Qt.Key_L:
      case Qt.Key_Right:
        currentZone = headerZone;
        event.accepted = true; break;

      case Qt.Key_J:
      case Qt.Key_Down:
        if (devicesSelectedIdx < deviceRepeater.count - 1) devicesSelectedIdx += 1
        event.accepted = true; break;
      case Qt.Key_K:
      case Qt.Key_Up:
        if (devicesSelectedIdx !== 0) devicesSelectedIdx -= 1
        event.accepted = true; break;

      case Qt.Key_D:
      case Qt.Key_X:
      case Qt.Key_Delete:
        menuState = removeState
        event.accepted = true; break;

      case Qt.Key_Y:
        deviceRepeater.itemAt(devicesSelectedIdx).remove() // qmllint disable missing-property
        menuState = noState
        event.accepted = true; break;

      case Qt.Key_N:
        menuState = noState
        event.accepted = true; break;

      case Qt.Key_T:
        deviceRepeater.itemAt(devicesSelectedIdx).trustToggle() // qmllint disable missing-property
        event.accepted = true; break;
    }
  }

  Keys.onPressed: event => {
    handleCommonKeys(event);
    if (currentZone === headerZone) handleHeaderKeys(event);
    else if (currentZone === listZone) handleListKeys(event);
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
    id: content
    implicitWidth: parent.width - (Theme.horizMargin*2)
    implicitHeight: parent.height - (Theme.vertMargin*2)
    anchors.centerIn: parent
    spacing: Theme.vertMargin


    Rectangle {
      id: actionsBar
      implicitHeight: (root.height - (Theme.vertMargin*2)) / 13
      implicitWidth: parent.width
      color: Theme.backgroundBlur
      radius: Theme.vertMargin

      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.horizMargin
        anchors.rightMargin: Theme.horizMargin

        Toggle {
          id: power
          Layout.alignment: Qt.AlignRight
          activated: Bluetooth.defaultAdapter?.enabled // qmllint disable unresolved-type
          onText: "on"
          offText: "off"
          onActivatedChanged: {
            Bluetooth.defaultAdapter.enabled = activated // qmllint disable unresolved-type
          }
        }
        
        Item { Layout.fillWidth: true }

        IconButton {
          implicitHeight: actionsBar.height
          activeBtnPath: "../../svg/reboot-active.svg"
          inactiveBtnPath: "../../svg/reboot-inactive.svg"
          openAnimation: false

          onClicked: {
            Bluetooth.defaultAdapter.discovering = true // qmllint disable unresolved-type
            scanTimeout.restart()
          }
        }
      }
    }

    Rectangle {
      id: devices
      implicitHeight: (root.height - (Theme.vertMargin*2)) - actionsBar.implicitHeight - parent.spacing
      implicitWidth: parent.width
      color: Theme.base
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

              color: removalMode ? Theme.red : focused || deviceRowHover.hovered ? Theme.surface2 : Theme.surface0

              implicitWidth: parent.width
              implicitHeight: deviceText.implicitHeight*2

              required property int index
              required property var modelData

              property bool focused: (root.currentZone === root.listZone && root.devicesSelectedIdx === index) // qmllint disable unqualified
              property bool removalMode: (root.menuState === root.removeState && root.devicesSelectedIdx === index) // qmllint disable unqualified
              property bool connected: modelData.connected
              property string name: modelData.name

              function toggle() {
                if (!modelData.paired) {
                  deviceRow.modelData.pair()
                } else if (connected) {
                  modelData.disconnect()
                } else {
                  modelData.connect()
                }
              }

              function remove() {
                modelData.forget()
              }

              function trustToggle() {
                modelData.trusted = !modelData.trusted
              }

              MouseArea {
                anchors.fill: parent
                onClicked: deviceRow.toggle()
                cursorShape: Qt.PointingHandCursor
              }

              HoverHandler {
                id: deviceRowHover
              }

              RowLayout {
                anchors.leftMargin: Theme.horizMargin
                anchors.rightMargin: Theme.horizMargin
                anchors.fill: parent
                spacing: 0
                StyledText {
                  id: deviceText
                  text: deviceRow.removalMode ? "Really remove device?" : deviceRow.modelData.name
                  color: deviceRow.modelData.paired ? deviceRow.modelData.connected ? Theme.cyclingColor : Theme.text : Theme.overlay0
                }

                Rectangle { Layout.fillWidth: true }

                IconButton {
                  Layout.alignment: Qt.AlignRight
                  implicitHeight: deviceRow.height
                  activeBtnPath: deviceRow.removalMode ? "../../svg/check-active.svg" : deviceRow.modelData.trusted ? "../../svg/shield-check-active.svg" : "../../svg/shield-cross-active.svg"
                  inactiveBtnPath: deviceRow.removalMode ? "../../svg/check-inactive.svg" : deviceRow.modelData.trusted ? "../../svg/shield-check-inactive.svg" : "../../svg/shield-cross-inactive.svg"
                  openAnimation: false

                  onClicked: {
                    if (deviceRow.removalMode) {
                      deviceRow.remove() // qmllint disable missing-property
                      root.menuState = noState // qmllint disable unqualified
                    } else {
                      deviceRow.trustToggle()
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
                      root.devicesSelectedIdx = deviceRow.index // qmllint disable unqualified
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
