import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../.."

Item {
  id: root
  anchors.fill: parent

  onVisibleChanged: {
    if (visible) {
      root.forceActiveFocus();
      deviceList.currentItem = Bt.devices?.length ? Bt.devices[0] : null;
    }
  }

  // -- Focus Management --
  ListMgr {
    id: deviceList
    list: Bt.devices
    searchKey: items => items.name ?? ""
    search: searchField.text
    onCurrentIdxChanged: {
      root.menuState = root.noState;
      listView.positionViewAtIndex(deviceList.currentIdx, ListView.Contain);
    }
  }

  // -- State management --
  readonly property int noState: 0
  readonly property int removeState: 1
  property int menuState: 0

  Keys.onPressed: event => {
    if (event.modifiers === Qt.ShiftModifier) {
      handleShiftKeys(event);
    } else {
      handleKeys(event);
    }
  }

  function handleKeys(event) {
    switch (event.key) {
    case Qt.Key_Escape:
    case Qt.Key_Q:
      if (menuState !== noState) {
        menuState = noState;
        event.accepted = true;
      }
      break;
    case Qt.Key_P:
      Bt.toggle_power();
      event.accepted = true;
      break;
    case Qt.Key_S:
      Bt.discover();
      event.accepted = true;
      break;
    case Qt.Key_Slash:
      searchField.forceActiveFocus();
      event.accepted = true;
      break;
    case Qt.Key_J:
    case Qt.Key_Down:
      deviceList.moveDn();
      event.accepted = true;
      break;
    case Qt.Key_K:
    case Qt.Key_Up:
      deviceList.moveUp();
      event.accepted = true;
      break;
    case Qt.Key_D:
    case Qt.Key_X:
    case Qt.Key_Delete:
      menuState = removeState;
      event.accepted = true;
      break;
    case Qt.Key_Return:
    case Qt.Key_Space:
      if (menuState === removeState)
        break;
      Bt.toggle_connection(deviceList.currentItem);
      event.accepted = true;
      break;
    case Qt.Key_Y:
      if (menuState === removeState)
        Bt.unpair(deviceList.currentItem);
      menuState = noState;
      event.accepted = true;
      break;
    case Qt.Key_N:
      menuState = noState;
      event.accepted = true;
      break;
    case Qt.Key_T:
      Bt.toggle_trust(deviceList.currentItem);
      event.accepted = true;
      break;
    }
  }

  function handleShiftKeys(event) {
    switch (event.key) {
    case Qt.Key_J:
      deviceList.jumpLast();
      event.accepted = true;
      break;
    case Qt.Key_K:
      deviceList.jumpFirst();
      event.accepted = true;
      break;
    case Qt.Key_D:
    case Qt.Key_X:
      Bt.toggle_power();
      event.accepted = true;
      break;
    }
  }

  ColumnLayout {
    implicitWidth: parent.width - (Theme.margin * 2)
    implicitHeight: parent.height - (Theme.margin * 2)
    anchors.centerIn: parent
    spacing: Theme.margin

    Rectangle {
      id: header
      implicitHeight: (root.height - (Theme.margin * 2)) / 13
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
          iconPath: Bt.powered ? "../../svg/bt.svg" : "../../svg/bt-off.svg" // qmllint disable unresolved-type
          iconColor: active ? Colors.md3.primary : Colors.md3.on_surface

          onClicked: {
            Bt.toggle_power();
          }
        }

        TextField {
          id: searchField

          Layout.fillWidth: true
          horizontalAlignment: TextInput.AlignHCenter

          renderType: Text.NativeRendering
          color: Colors.md3.on_surface
          placeholderTextColor: Qt.alpha(Colors.md3.on_surface_variant, 0.50)

          placeholderText: "Search for a device..."

          font.family: Theme.font
          font.pixelSize: Theme.fontSize
          font.weight: Theme.fontWeight

          Keys.onPressed: event => {
            switch (event.key) {
            case Qt.Key_Escape:
            case Qt.Key_Tab:
              searchField.text = "";
              root.forceActiveFocus();
              event.accepted = true;
              break;
            case Qt.Key_Return:
              Bt.toggle_connection(deviceList.currentItem);
              searchField.text = "";
              root.forceActiveFocus();
              event.accepted = true;
              break;
            }
          }

          background: Rectangle {
            radius: header.radius
            implicitHeight: searchField.height
            implicitWidth: searchField.width
            color: Colors.md3.surface_container_high
          }
        }

        IconButton {
          id: scan
          implicitHeight: header.height
          iconPath: "../../svg/reboot.svg"
          iconColor: active ? Colors.md3.primary : Colors.md3.on_surface

          RotationAnimation {
            target: scan
            property: "iconRotation"
            running: Bt.discovering
            loops: Animation.Infinite
            duration: 2500
            from: 0
            to: 360
            easing.type: Easing.Linear
            direction: RotationAnimation.Clockwise
          }

          onClicked: {
            Bt.discover();
          }
        }
      }
    }

    Rectangle {
      implicitHeight: (root.height - (Theme.margin * 2)) - header.implicitHeight - parent.spacing
      implicitWidth: parent.width
      color: Colors.md3.surface_container
      radius: Theme.margin

      ListView {
        id: listView
        anchors.margins: Theme.margin
        spacing: Theme.margin / 2
        anchors.fill: parent
        clip: true
        model: deviceList.model

        delegate: ClippingRectangle {
          id: listItem
          radius: Theme.radius

          color: removalMode ? Colors.md3.error_container : focused ? Colors.md3.surface_container_highest : Colors.md3.surface_container_high

          Rectangle {
            anchors.fill: parent
            radius: Theme.radius
            color: Colors.md3.on_surface
            opacity: listItemHover.hovered ? 0.08 : 0
            Behavior on opacity {
              NumberAnimation {
                duration: Theme.animationDuration
              }
            }
          }

          Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            implicitHeight: deviceText.implicitHeight
            implicitWidth: Theme.margin * 0.4
            radius: implicitWidth / 2
            color: Colors.md3.primary
            visible: listItem.modelData.connected && !listItem.removalMode
          }

          width: ListView.view.width
          height: deviceText.implicitHeight * 2

          required property int index
          required property var modelData

          property bool focused: (deviceList.currentItem === modelData) // qmllint disable unqualified
          property bool removalMode: (root.menuState === root.removeState && focused) // qmllint disable unqualified

          HoverHandler {
            id: listItemHover
          }
          MouseArea {
            anchors.fill: parent
            onClicked: Bt.toggle_connection(listItem.modelData)
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
              Layout.preferredWidth: listItem.width - listItem.height * 4
              color: {
                if (listItem.removalMode)
                  return Colors.md3.on_error_container;
                else if (listItem.modelData.connected)
                  return Colors.md3.primary;
                else if (listItem.modelData.paired)
                  return Colors.md3.on_surface;
                else
                  return Qt.alpha(Colors.md3.on_surface_variant, 0.50);
              }
            }

            Item {
              Layout.fillWidth: true
            }

            IconButton {
              Layout.alignment: Qt.AlignRight
              implicitHeight: listItem.height
              iconPath: listItem.removalMode ? "../../svg/check.svg" : listItem.modelData.trusted ? "../../svg/shield-check.svg" : "../../svg/shield-cross.svg"
              iconColor: active ? Colors.md3.primary : Colors.md3.on_surface

              onClicked: {
                if (listItem.removalMode) {
                  Bt.unpair(listItem.modelData);
                  root.menuState = root.noState; // qmllint disable unqualified
                } else {
                  Bt.toggle_trust(listItem.modelData);
                }
              }
            }

            IconButton {
              implicitHeight: listItem.height
              iconPath: listItem.removalMode ? "../../svg/cross.svg" : "../../svg/trash.svg"
              iconColor: active ? Colors.md3.primary : Colors.md3.on_surface

              onClicked: {
                if (listItem.removalMode) {
                  root.menuState = noState; // qmllint disable unqualified
                } else {
                  deviceList.currentItem = listItem.modelData; // qmllint disable unqualified
                  root.menuState = removeState; // qmllint disable unqualified
                }
              }
            }
          }
        }
      }
    }
  }
}
