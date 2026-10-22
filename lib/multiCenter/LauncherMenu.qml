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
    id: programList
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
    if (visible) {
      searchField.forceActiveFocus()
      programList.jumpFirst()
      searchField.text = ""
    }
  }

    function handleKeys(event) {
    switch (event.key) {
      case Qt.Key_J:
      case Qt.Key_Down:
        programList.moveDn()
        event.accepted = true; break
      case Qt.Key_K:
      case Qt.Key_Up:
        programList.moveUp()
        event.accepted = true; break
      case Qt.Key_G:
        programList.jumpFirst()
        event.accepted = true; break
      case Qt.Key_Return:
      case Qt.Key_Space:
        if (programList.visible.length > 0 && programList.currentItem)
          programList.currentItem.entry.execute()
        else
          if (searchField.text !== "") Quickshell.execDetached(["sh", "-c", searchField.text])
        ShellUI.close()
        event.accepted = true; break
      case Qt.Key_Slash:
      case Qt.Key_I:
      case Qt.Key_A:
        searchField.forceActiveFocus()
        event.accepted = true; break
    }
  }

  function handleShiftKeys(event) {
    switch (event.key) {
      case Qt.Key_J:
      case Qt.Key_G:
      case Qt.Key_Down:
        programList.jumpLast()
        event.accepted = true; break
      case Qt.Key_K:
      case Qt.Key_Up:
        programList.jumpFirst()
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
    width: parent.width - Theme.margin*2
    height: parent.height - Theme.margin*2
    anchors.centerIn: parent
    spacing: Theme.margin

    Rectangle {
      id: header
      implicitWidth: parent.width
      implicitHeight: (root.height - (Theme.margin*2)) / 13
      radius: Theme.radius
      color: Colors.md3.surface_container

      TextField {
        id: searchField

        anchors.centerIn: parent
        implicitWidth: parent.width - Theme.margin*2
        horizontalAlignment: TextInput.AlignHCenter

        renderType: Text.NativeRendering
        color: Colors.md3.on_surface
        placeholderTextColor: Qt.alpha(Colors.md3.on_surface_variant, 0.50)

        placeholderText: "Search for a program..."

        font.family: Theme.font
        font.pixelSize: Theme.fontSize
        font.weight: Theme.fontWeight

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
      radius: Theme.radius

      ListView {
        id: listView
        anchors.fill: parent
        anchors.margins: Theme.margin
        clip: true
        spacing: Theme.margin/2

        model: programList.visible
        delegate: Rectangle {
          id: listItem

          required property int index
          required property var modelData

          anchors.margins: Theme.margin

          radius: Theme.radius
          implicitWidth: listView?.width ?? 0 //qmllint disable unqualified
          implicitHeight: text.implicitHeight * 2

          color: programList.currentItem?.id == modelData.id ? Colors.md3.surface_container_highest : Colors.md3.surface_container_high //qmllint disable unqualified

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
