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
      list.currentItem = outputDevices?.length ? Pipewire.defaultAudioSink : null
      root.forceActiveFocus()
    }
  }

  property var outputDevices: Pipewire.nodes.values.filter(item => item.isSink && !item.isStream)

  PwObjectTracker { // required to allow all objects to have audio data
    objects: root.outputDevices ? root.outputDevices : []
  }

  property bool allMuted: outputDevices.length > 0 && outputDevices.every(n => n.audio?.muted ?? false)

  // -- Focus Handling --
  ListMgr {
    id: list
    list: root.outputDevices
  }

  function handleKeys(event) {
    switch (event.key) {
      case Qt.Key_J:
        list.moveDn()
        event.accepted = true; break
      case Qt.Key_K:
        list.moveUp()
        event.accepted = true; break
      case Qt.Key_G:
        list.currentItem = outputDevices[0]
        event.accepted = true; break
      case Qt.Key_H:
        list.currentItem.audio.volume -= 0.05
        event.accepted = true; break
      case Qt.Key_L:
        list.currentItem.audio.volume += 0.05
        event.accepted = true; break
      case Qt.Key_X:
      case Qt.Key_D:
      case Qt.Key_M:
        list.currentItem.audio.muted = !list.currentItem.audio.muted
        event.accepted = true; break
      case Qt.Key_Return:
      case Qt.Key_Space:
        Pipewire.preferredDefaultAudioSink = list.currentItem
        event.accepted = true; break
    }
  }

  function handleShiftKeys(event) {
    switch (event.key) {
      case Qt.Key_J:
      case Qt.Key_G:
        list.currentItem = outputDevices[outputDevices.length -1]
        event.accepted = true; break
      case Qt.Key_K:
        list.currentItem = outputDevices[0]
        event.accepted = true; break
      case Qt.Key_X:
      case Qt.Key_D:
      case Qt.Key_M:
        const mute = !root.allMuted
        for (const i of root.outputDevices) i.audio.muted = mute
        event.accepted = true; break
      case Qt.Key_H:
        list.currentItem.audio.volume = 0
        event.accepted = true; break
      case Qt.Key_L:
        list.currentItem.audio.volume = 1
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

  Rectangle {
    id: content
    implicitWidth: parent.width - (Theme.horizMargin*2)
    implicitHeight: parent.height - (Theme.vertMargin*2)
    anchors.centerIn: parent
    color: Theme.mantle
    radius: Theme.vertMargin

    ColumnLayout {
      width: parent.width

      Item {
        implicitHeight: Theme.vertMargin
      }

      Rectangle {
        id: header
        radius: Theme.vertMargin
        color: Theme.base
        Layout.leftMargin: Theme.horizMargin
        implicitWidth: parent.width - Theme.horizMargin*2
        implicitHeight: 40

        RowLayout {
          IconButton {
            implicitHeight: header.height
            activeBtnPath: root.allMuted ? "../../svg/vol-off-active" : "../../svg/vol-max-active.svg"
            inactiveBtnPath: root.allMuted ? "../../svg/vol-off-inactive.svg" : "../../svg/vol-max.svg"
            openAnimation: false
            Layout.alignment: Qt.AlignRight

            onClicked: {
              const mute = !root.allMuted
              for (const i of root.outputDevices) i.audio.muted = mute
            }
          }
        }
      }

      Repeater {
        model: root.outputDevices
        implicitWidth: parent.width
        ClippingRectangle {
          id: listItem

          required property int index
          required property var modelData

          Layout.leftMargin: Theme.horizMargin

          implicitWidth: parent.width - Theme.horizMargin*2
          implicitHeight: text.implicitHeight + Theme.vertMargin*2
          color: itemFocus ? Theme.surface1 : Theme.surface0
          radius: Theme.vertMargin

          HoverHandler { id: hover }
          readonly property bool itemFocus: {
            if (hover.hovered) return true;
            if (list.currentItem == modelData) return true; //qmllint disable unqualified
            return false
          }

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
            color: listItem.itemFocus ? Theme.surface2 : Theme.surface1
            implicitWidth: parent.width * listItem.modelData.audio.volume
            radius: Theme.vertMargin
            Behavior on implicitWidth {
              NumberAnimation {
                duration: 100
                easing: Theme.animationEasing
              }
            }
          }

          RowLayout {
            anchors.leftMargin: Theme.horizMargin
            anchors.rightMargin: Theme.horizMargin
            anchors.fill: parent
            spacing: 0

            StyledText {
              id: text
              elide: Qt.ElideRight
              color: Pipewire.defaultAudioSink === listItem.modelData ? Theme.cyclingColor : Theme.text
              Layout.preferredWidth: listItem.width - listItem.height*4
              text: listItem.modelData.description
            }

            Item {
              Layout.fillWidth: true
            }

            IconButton {
              implicitHeight: listItem.height
              activeBtnPath: listItem.modelData.audio.muted ? "../../svg/vol-off-active" : "../../svg/vol-max-active.svg"
              inactiveBtnPath: listItem.modelData.audio.muted ? "../../svg/vol-off-inactive.svg" : "../../svg/vol-max.svg"
              openAnimation: false
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
