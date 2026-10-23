import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import "../.."

Item {
  id: root
  anchors.fill: parent

  onVisibleChanged: {
    if (visible) {
      sinkList.currentItem = outputDevices?.length ? Pipewire.defaultAudioSink : null
      root.forceActiveFocus()
    }
  }

  property var outputDevices: Pipewire.nodes.values.filter(item => item.isSink && !item.isStream) //qmllint disable missing-property

  PwObjectTracker { // required to allow all objects to have audio data
    objects: root.outputDevices ? root.outputDevices : []
  }

  property bool allMuted: outputDevices.length > 0 && outputDevices.every(n => n.audio?.muted ?? false)

  // -- Focus Handling --
  ListMgr {
    id: sinkList
    list: root.outputDevices
    onCurrentIdxChanged: {
      listView.positionViewAtIndex(sinkList.currentIdx, ListView.Contain)
    }
  }

  function handleKeys(event) {
    switch (event.key) {
      case Qt.Key_J:
        sinkList.moveDn()
        event.accepted = true; break
      case Qt.Key_K:
        sinkList.moveUp()
        event.accepted = true; break
      case Qt.Key_G:
        sinkList.jumpFirst()
        event.accepted = true; break
      case Qt.Key_H:
        sinkList.currentItem.audio.volume -= 0.05
        event.accepted = true; break
      case Qt.Key_L:
        sinkList.currentItem.audio.volume += 0.05
        event.accepted = true; break
      case Qt.Key_X:
      case Qt.Key_D:
      case Qt.Key_M:
        sinkList.currentItem.audio.muted = !sinkList.currentItem.audio.muted
        event.accepted = true; break
      case Qt.Key_Return:
      case Qt.Key_Space:
        Pipewire.preferredDefaultAudioSink = sinkList.currentItem
        event.accepted = true; break
    }
  }

  function handleShiftKeys(event) {
    switch (event.key) {
      case Qt.Key_J:
      case Qt.Key_G:
        sinkList.jumpLast()
        event.accepted = true; break
      case Qt.Key_K:
        sinkList.jumpFirst()
        event.accepted = true; break
      case Qt.Key_X:
      case Qt.Key_D:
      case Qt.Key_M:
        const mute = !root.allMuted
        for (const i of root.outputDevices) i.audio.muted = mute
        event.accepted = true; break
      case Qt.Key_H:
        sinkList.currentItem.audio.volume = 0
        event.accepted = true; break
      case Qt.Key_L:
        sinkList.currentItem.audio.volume = 1
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
    implicitWidth: parent.width - (Theme.margin*2)
    implicitHeight: parent.height - (Theme.margin*2)
    anchors.centerIn: parent
    spacing: Theme.margin

    Rectangle {
      id: header
      implicitWidth: parent.width
      implicitHeight: (root.height - (Theme.margin*2)) / 13
      radius: Theme.radius
      color: Colors.md3.surface_container

      RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.margin
        anchors.rightMargin: Theme.margin

        IconButton {
          implicitHeight: header.height
          iconPath: root.allMuted ? "../../svg/vol-off.svg" : "../../svg/vol-max.svg"
          iconColor: active ? Colors.md3.primary : Colors.md3.on_surface

          onClicked: {
            const mute = !root.allMuted
            for (const i of root.outputDevices) i.audio.muted = mute
          }
        }
      }
    }

    Rectangle {
      implicitWidth: parent.width
      implicitHeight: (root.height - (Theme.margin*2)) - header.implicitHeight - parent.spacing
      color: Colors.md3.surface_container
      radius: Theme.radius

      ListView {
        id: listView
        anchors.margins: Theme.margin
        spacing: Theme.margin/2
        anchors.fill: parent
        clip: true
        model: root.outputDevices

        delegate: ClippingRectangle {
          id: listItem

          required property int index
          required property var modelData

          Layout.leftMargin: Theme.margin

          implicitWidth: parent.width
          implicitHeight: text.implicitHeight * 2
          radius: Theme.radius
          color: sinkList.currentItem == modelData ? Colors.md3.surface_container_highest : Colors.md3.surface_container_high //qmllint disable unqualified

          Rectangle {
            anchors.fill: parent
            radius: Theme.radius
            color: Colors.md3.on_surface
            opacity: hover.hovered ? 0.08 : 0
            Behavior on opacity { NumberAnimation { duration: Theme.animationDuration } }
          }

          Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            implicitHeight: text.implicitHeight
            implicitWidth: Theme.margin * 0.4
            radius: implicitWidth/2
            color: Colors.md3.primary
            visible: Pipewire.defaultAudioSink === listItem.modelData
          }

          HoverHandler { id: hover }

          MouseArea {
            anchors.fill: parent
            onPressed: {
              Pipewire.preferredDefaultAudioSink = listItem.modelData
            }
            onWheel: (wheel) => {
              if (wheel.angleDelta.y < 0) {
                listItem.modelData.audio.volume -= 0.01
              }
              if (wheel.angleDelta.y > 0) {
                listItem.modelData.audio.volume += 0.01
              }
              wheel.accepted = true;
            }
          }

          Rectangle {
            implicitHeight: parent.height
            anchors.left: parent.left
            color: Colors.md3.on_surface
            opacity: 0.1
            implicitWidth: parent.width * listItem.modelData.audio.volume
            radius: Theme.radius
            Behavior on implicitWidth {
              NumberAnimation {
                duration: 100
                easing: Theme.animationEasing
              }
            }
          }

          RowLayout {
            anchors.leftMargin: Theme.margin
            anchors.rightMargin: Theme.margin
            anchors.fill: parent
            spacing: 0

            StyledText {
              id: text
              elide: Qt.ElideRight
              color: Pipewire.defaultAudioSink === listItem.modelData ? Colors.md3.primary : Colors.md3.on_surface
              Layout.preferredWidth: listItem.width - listItem.height*4
              text: listItem.modelData.description
            }

            Item {
              Layout.fillWidth: true
            }

            IconButton {
              implicitHeight: listItem.height
              iconPath: listItem.modelData.audio.muted ? "../../svg/vol-off.svg" : "../../svg/vol-max.svg"
              iconColor: active ? Colors.md3.primary : Colors.md3.on_surface
              Layout.alignment: Qt.AlignRight

              onClicked: {
                listItem.modelData.audio.muted = !listItem.modelData.audio.muted
              }
            }
          }
        }
      }
    }
  }
}
