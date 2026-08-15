import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../.."

Item {
  id: root
  anchors.fill: parent
  
  onVisibleChanged: {
    if (visible) {
      devicesSelectedIdx = 0
      currentZone = 1
      root.forceActiveFocus()
    }
  }

  property var devices: Bluetooth.defaultAdapter?.devices; // qmllint disable unresolved-type
  property int devicesSelectedIdx: 0
  property int currentZone: 0 // 0 = header/top bar; 1 = item list
  property int menuState: 0 // 0 = none; 1 = removal confirmation

  onCurrentZoneChanged: { menuState = 0 }
  onDevicesSelectedIdxChanged: { menuState = 0 }

  Keys.onPressed: event => {
    switch (event.key) {
      case Qt.Key_H:
      case Qt.Key_Left:
        if (currentZone === 0) {
          currentZone = 1;
          event.accepted = true;
        } else {
          currentZone -= 1;
          event.accepted = true;
        }
        break;
      case Qt.Key_L:
      case Qt.Key_Right:
        if (currentZone === 1) {
          currentZone = 0;
          event.accepted = true;
        } else {
          currentZone += 1;
          event.accepted = true;
        }
        break;
      case Qt.Key_J:
      case Qt.Key_Down:
        if (currentZone === 1) {
          if (devicesSelectedIdx < deviceRepeater.count - 1) {
            devicesSelectedIdx += 1
          }
          event.accepted = true;
        }
        break;
      case Qt.Key_K:
      case Qt.Key_Up:
        if (currentZone === 1) {
          if (devicesSelectedIdx !== 0) {
            devicesSelectedIdx -= 1
          }
          event.accepted = true;
        }
        break;

      case Qt.Key_D:
      case Qt.Key_X:
      case Qt.Key_Delete:
        if (currentZone === 1) {
          menuState = 1
          event.accepted = true;
        }
        break;

      case Qt.Key_Y:
        if (menuState === 1) {
          deviceRepeater.itemAt(devicesSelectedIdx).remove() // qmllint disable missing-property
          menuState = 0
          event.accepted = true;
        }
        break;

      case Qt.Key_N:
        if (menuState === 1) {
          menuState = 0
          event.accepted = true;
        }
        break;

      case Qt.Key_T:
        if (currentZone === 1) {
          deviceRepeater.itemAt(devicesSelectedIdx).trustToggle() // qmllint disable missing-property
          event.accepted = true;
        }
        break;

      case Qt.Key_P:
        Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled // qmllint disable unresolved-type
        event.accepted = true;
        break;

      case Qt.Key_S:
        Bluetooth.defaultAdapter.discovering = true // qmllint disable unresolved-type
        scanTimeout.restart()
        break;

      case Qt.Key_Return:
      case Qt.Key_Enter:
      case Qt.Key_Space:
        if (currentZone === 1) {
          deviceRepeater.itemAt(devicesSelectedIdx).toggle() // qmllint disable missing-property
          event.accepted = true;
        }
        break;

      case Qt.Key_Escape:
        if (menuState === 1) {
          menuState = 0
          event.accepted = true;
        }
        break;
    }
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

              property bool focused: (root.currentZone === 1 && root.devicesSelectedIdx === index) // qmllint disable unqualified
              property bool removalMode: (root.menuState === 1 && root.devicesSelectedIdx === index) // qmllint disable unqualified
              property bool connected: modelData.connected
              property string name: modelData.name

              function toggle() {
                if (!modelData.paired) {
                  modelData.pair()
                }

                if (connected) {
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
                  color: deviceRow.modelData.connected ? Theme.cyclingColor : Theme.text
                }

                Rectangle { Layout.fillWidth: true }

                IconButton {
                  Layout.alignment: Qt.AlignRight
                  implicitHeight: deviceRow.height
                  activeBtnPath: deviceRow.modelData.trusted ? "../../svg/shield-check-active.svg" : "../../svg/shield-cross-active.svg"
                  inactiveBtnPath: deviceRow.modelData.trusted ? "../../svg/shield-check-inactive.svg" : "../../svg/shield-cross-inactive.svg"
                  openAnimation: false
                  onClicked: {
                    deviceRow.trustToggle()
                  }
                }

                IconButton {
                  implicitHeight: deviceRow.height
                  activeBtnPath: "../../svg/trash-active.svg"
                  inactiveBtnPath: "../../svg/trash-inactive.svg"
                  openAnimation: false
                  onClicked: {
                    deviceRow.remove()
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
