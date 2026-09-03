import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import "../.."

Item {
  id: root
  anchors.fill: parent

  property var outputDevices: Pipewire.nodes.values.filter(item => item.isSink && !item.isStream);

  PwObjectTracker { // required to allow all objects to have audio data
    objects: root.outputDevices ? root.outputDevices : []
  }

  property int currentZone: 0
  readonly property int defaultZone: 0

  property int menuState: 0
  readonly property int noState: 0

  onVisibleChanged: {
    if (visible) {
      currentZone = defaultZone
      root.forceActiveFocus()
    }
  }

  // -- Keyboard Shortcuts --
  
  // event handlers
  onCurrentZoneChanged: {
    menuState = noState
  }

  // shortcuts used between all focus zones
  function handleCommonKeys(event) {
    switch (event.key) {

      case Qt.Key_Escape:
        if (menuState !== noState) {
          menuState = noState
          event.accepted = true;
        }
        break;
    }
  }

  Keys.onPressed: event => {
    handleCommonKeys(event);
  }

  Rectangle {
    id: content
    implicitWidth: parent.width - (Theme.horizMargin*2)
    implicitHeight: parent.height - (Theme.vertMargin*2)
    anchors.centerIn: parent
    color: Theme.base
    ColumnLayout {
      width: parent.width
      Item {
        implicitHeight: Theme.vertMargin
      }
      Repeater {
        model: root.outputDevices
        implicitWidth: parent.width
        Rectangle {
          id: listItem

          required property int index
          required property var modelData

          Layout.leftMargin: Theme.horizMargin

          implicitWidth: parent.width - Theme.horizMargin*2
          implicitHeight: text.implicitHeight + Theme.vertMargin*2
          color: Theme.surface0
          radius: Theme.vertMargin
          clip: true

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
            color: Theme.surface1
            implicitWidth: parent.implicitWidth * listItem.modelData.audio.volume
            radius: parent.radius
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
