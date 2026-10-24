import Quickshell.Bluetooth
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../.."

Item {
  id: root
  anchors.fill: parent

  onVisibleChanged: {
    if (visible) {
      root.forceActiveFocus()
      deviceList.currentItem = devices?.length ? devices[0] : null
    }
  }

  property var devices: Bluetooth.defaultAdapter?.devices.values; // qmllint disable unresolved-type

  Process {
    running: true
    command: ["bluetoothctl", "--agent", "NoInputNoOutput"]
    stdout: SplitParser { onRead: data => {} }
    stderr: SplitParser { onRead: data => {} }
  }

  // -- Focus Management --
  ListMgr {
    id: deviceList
    list: root.devices
    onCurrentIdxChanged: {
      root.menuState = root.noState
      listView.positionViewAtIndex(deviceList.currentIdx, ListView.Contain)
    }
  }

  // -- State management --
  readonly property int noState: 0
  readonly property int removeState: 1
  property int menuState: 0

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
        deviceList.moveDn()
        event.accepted = true; break;
      case Qt.Key_K:
      case Qt.Key_Up:
        deviceList.moveUp()
        event.accepted = true; break;
      case Qt.Key_D:
      case Qt.Key_X:
      case Qt.Key_Delete:
        menuState = removeState
        event.accepted = true; break;
      case Qt.Key_Return:
      case Qt.Key_Space:
        if (menuState === removeState) break;
        toggle(deviceList.currentItem)
        event.accepted = true; break;
      case Qt.Key_Y:
        if (menuState === removeState) deviceList.currentItem.forget()
        menuState = noState
        event.accepted = true; break;
      case Qt.Key_N:
        menuState = noState
        event.accepted = true; break;
      case Qt.Key_T:
        deviceList.currentItem.trusted = !deviceList.currentItem.trusted
        event.accepted = true; break;
    }
  }

  function handleShiftKeys(event) {
    switch (event.key) {
      case Qt.Key_J:
        deviceList.jumpLast()
        event.accepted = true; break;
      case Qt.Key_K:
        deviceList.jumpFirst()
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
    implicitWidth: parent.width - (Theme.margin*2)
    implicitHeight: parent.height - (Theme.margin*2)
    anchors.centerIn: parent
    spacing: Theme.margin

    Rectangle {
      id: header
      implicitHeight: (root.height - (Theme.margin*2)) / 13
      implicitWidth: parent.width
      color: Colors.md3.surface_container
      radius: Theme.radius

      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.margin
        anchors.rightMargin: Theme.margin

        IconButton {
          Layout.alignment: Qt.AlignRight
          implicitHeight: header.height
          iconPath: Bluetooth.defaultAdapter?.enabled ? "../../svg/bt.svg" : "../../svg/bt-off.svg" // qmllint disable unresolved-type
          iconColor: active ? Colors.md3.primary : Colors.md3.on_surface

          onClicked: {
            Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled // qmllint disable unresolved-type
          }
        }

        Item { Layout.fillWidth: true }

        IconButton {
          id: scan
          implicitHeight: header.height
          iconPath: "../../svg/reboot.svg"
          iconColor: active ? Colors.md3.primary : Colors.md3.on_surface

          RotationAnimation {
            target: scan
            property: "iconRotation"
            running: Bluetooth.defaultAdapter?.discovering ?? false// qmllint disable unresolved-type
            loops: Animation.Infinite
            duration: 2500
            from: 0
            to: 360
            easing.type: Easing.Linear
            direction: RotationAnimation.Clockwise
          }

          onClicked: {
            Bluetooth.defaultAdapter.discovering = true // qmllint disable unresolved-type
            scanTimeout.restart()
          }
        }
      }
    }

    Rectangle {
      implicitHeight: (root.height - (Theme.margin*2)) - header.implicitHeight - parent.spacing
      implicitWidth: parent.width
      color: Colors.md3.surface_container
      radius: Theme.margin

      ListView {
        id: listView
        anchors.margins: Theme.margin
        spacing: Theme.margin/2
        anchors.fill: parent
        clip: true
        model: root.devices

        delegate: ClippingRectangle {
          id: listItem
          radius: Theme.radius

          color: removalMode ? Colors.md3.error_container
               : focused ? Colors.md3.surface_container_highest
               : Colors.md3.surface_container_high

          Rectangle {
            anchors.fill: parent
            radius: Theme.radius
            color: Colors.md3.on_surface
            opacity: listItemHover.hovered ? 0.08: 0
            Behavior on opacity { NumberAnimation { duration: Theme.animationDuration } }
          }

          Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            implicitHeight: deviceText.implicitHeight
            implicitWidth: Theme.margin * 0.4
            radius: implicitWidth/2
            color: Colors.md3.primary
            visible: listItem.modelData.connected && ! listItem.removalMode
          }

          width: ListView.view.width
          height: deviceText.implicitHeight*2

          required property int index
          required property var modelData

          property bool focused: (deviceList.currentItem === modelData) // qmllint disable unqualified
          property bool removalMode: (root.menuState === root.removeState && focused) // qmllint disable unqualified

          HoverHandler { id: listItemHover }
          MouseArea {
            anchors.fill: parent
            onClicked: root.toggle(listItem.modelData) //qmllint disable unqualified
            cursorShape: Qt.PointingHandCursor
          }

          RowLayout {
            anchors.leftMargin: Theme.margin
            anchors.rightMargin: Theme.margin
            anchors.fill: parent
            spacing: 0

            StyledText {
              id: deviceText
              text: listItem.removalMode ? "Remove device?" : listItem.modelData.name
              elide: Qt.ElideRight
              Layout.preferredWidth: listItem.width - listItem.height*4
              color: {
                if (listItem.removalMode) return Colors.md3.on_error_container
                else if (listItem.modelData.connected) return Colors.md3.primary
                else if (listItem.modelData.paired) return Colors.md3.on_surface
                else return Qt.alpha(Colors.md3.on_surface_variant, 0.50)
              }
            }

            Item { Layout.fillWidth: true }

            IconButton {
              Layout.alignment: Qt.AlignRight
              implicitHeight: listItem.height
              iconPath: listItem.removalMode ? "../../svg/check.svg" : listItem.modelData.trusted ? "../../svg/shield-check.svg" : "../../svg/shield-cross.svg"
              iconColor: active ? Colors.md3.primary : Colors.md3.on_surface

              onClicked: {
                if (listItem.removalMode) {
                  listItem.modelData.forget() // qmllint disable missing-property
                  root.menuState = noState // qmllint disable unqualified
                } else {
                  listItem.modelData.trusted = !listItem.modelData.trusted
                }
              }
            }

            IconButton {
              implicitHeight: listItem.height
              iconPath: listItem.removalMode ? "../../svg/cross.svg" : "../../svg/trash.svg"
              iconColor: active ? Colors.md3.primary : Colors.md3.on_surface

              onClicked: {
                if (listItem.removalMode) {
                  root.menuState = noState // qmllint disable unqualified
                } else {
                  deviceList.currentItem = listItem.modelData // qmllint disable unqualified
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
