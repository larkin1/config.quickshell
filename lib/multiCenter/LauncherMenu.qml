import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../.."

Item {
  id: root
  anchors.fill: parent

  readonly property var items: DesktopEntries.applications.values
    .filter(e => !e.noDisplay)
    .sort((a, b) => a.name.localeCompare(b.name))
    .map(e => ({
        id: e.id,
        name: e.name || e.id,
        genericName: e.genericName,
        comment: e.comment,
        icon: e.icon,
        entry: e
    }))

  ListMgr {
    id: list
    list: root.items
    searchKey: items => items.name ?? ""
    search: searchField.text
    onListChanged: jumpFirst()
    onSearchChanged: jumpFirst()
    onCurrentIdxChanged: {
      listView.positionViewAtIndex(list.currentIdx, ListView.Contain)
    }
  }

  onVisibleChanged: {
    searchField.forceActiveFocus()
    list.jumpFirst()
    searchField.text = ""
  }

    function handleKeys(event) {
    switch (event.key) {
      case Qt.Key_J:
      case Qt.Key_Down:
        list.moveDn()
        event.accepted = true; break
      case Qt.Key_K:
      case Qt.Key_Up:
        list.moveUp()
        event.accepted = true; break
      case Qt.Key_G:
        list.jumpFirst()
        event.accepted = true; break
      case Qt.Key_Return:
      case Qt.Key_Space:
        list.currentItem?.entry.execute()
        ShellUI.close()
        event.accepted = true; break
      case Qt.Key_Slash:
      case Qt.Key_I:
      case Qt.Key_A:
        console.log("ee")
        searchField.forceActiveFocus()
        event.accepted = true; break
    }
  }

  function handleShiftKeys(event) {
    switch (event.key) {
      case Qt.Key_J:
      case Qt.Key_G:
      case Qt.Key_Down:
        list.jumpLast()
        event.accepted = true; break
      case Qt.Key_K:
      case Qt.Key_Up:
        list.jumpFirst()
        event.accepted = true; break
    }
  }

  Keys.onPressed: event => {
    if (event.modifiers === Qt.ShiftModifier) {
      handleShiftKeys(event)
    } else {
      handleKeys(event);
    }
  }


  ColumnLayout {
    id: content
    width: parent.width - Theme.horizMargin*2
    height: parent.height - Theme.vertMargin*2
    anchors.centerIn: parent
    spacing: Theme.vertMargin

    Rectangle {
      id: header
      implicitWidth: parent.width
      implicitHeight: (root.height - (Theme.vertMargin*2)) / 13
      radius: Theme.vertMargin
      color: Colors.md3.surface_container

      TextField {
        id: searchField

        anchors.centerIn: parent
        implicitWidth: parent.width - Theme.vertMargin*2
        horizontalAlignment: TextInput.AlignHCenter

        renderType: Text.NativeRendering
        color: Colors.md3.on_surface
        placeholderTextColor: Qt.alpha(Colors.md3.on_surface_variant, 0.50)

        placeholderText: "Search for a program..."

        font.family: Theme.font
        font.pixelSize: Theme.fontSize
        font.weight: Theme.fontWeight

        onAccepted: {
          root.items.currentItem?.entry.execute()
          ShellUI.close()
        }

        Keys.onPressed: event => {
          if (event.key == Qt.Key_Escape) {
            root.forceActiveFocus()
            event.accepted = true
          }
        }

        background: Rectangle {
          radius: header.radius
          implicitHeight: searchField.height
          implicitWidth: searchField.width
          color: Colors.md3.surface_container_high
        }
      }
    }

    Rectangle {
      id: listContainer
      implicitWidth: parent.width
      Layout.fillHeight: true
      color: Colors.md3.surface_container
      radius: Theme.vertMargin

      ListView {
        id: listView
        anchors.fill: parent
        anchors.margins: Theme.vertMargin
        clip: true
        spacing: Theme.vertMargin/2

        model: list.visible
        delegate: Rectangle {
          id: listItem

          required property int index
          required property var modelData

          anchors.margins: Theme.vertMargin

          radius: Theme.vertMargin
          implicitWidth: listView?.width ?? 0 //qmllint disable unqualified
          implicitHeight: text.implicitHeight * 2

          color: list.currentItem?.id == modelData.id ? Colors.md3.surface_container_highest : Colors.md3.surface_container_high //qmllint disable unqualified

          Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: Colors.md3.on_surface
            opacity: hover.hovered ? 0.08 : 0
            Behavior on opacity { NumberAnimation { duration: Theme.animationDuration } }
          }

          HoverHandler { id: hover }

          MouseArea {
            anchors.fill: parent
            onClicked: {
              listItem.modelData.entry.execute()
              ShellUI.close()
            }
          }

          StyledText {
            id: text
            text: listItem.modelData.name
            anchors.centerIn: parent
          }
        }
      }
    }
  }
}
