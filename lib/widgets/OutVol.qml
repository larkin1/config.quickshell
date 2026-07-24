import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import "../.."

Item {
  id: root
  implicitWidth: vollayout.implicitWidth + Theme.horizMargin
  implicitHeight: Theme.barHeight

  readonly property var sink: Pipewire.defaultAudioSink

  function sinkIconType(node) {
      if (!node) return "../../svg/vol-max.svg";
      const p = node.properties || {};
      const name = (node.name || "").toLowerCase();
      const factory = (p["factory.name"] || "").toLowerCase();

      if (factory.includes("bluez5") || name.startsWith("bluez_output.")) {
        if ( node.audio.muted ) {
          return "../../svg/bt-inactive.svg";
        } else {
          return "../../svg/bt-active.svg";
        }
      }

      if (node.audio) {
        const volume = node.audio.volume
        if ( node.audio.muted ) {
          return "../../svg/vol-off.svg";
        }
        if ( volume > 0.75 ) {
          return "../../svg/vol-max.svg";
        } else if ( volume > 0.25 ) {
          return "../../svg/vol-med.svg";
        } else {
          return "../../svg/vol-min.svg"
        }
      }

      return "../../svg/vol-max.svg";
  }

  PwObjectTracker {
    id: obj
    objects: root.sink ? [ root.sink ] : []
  }

  RowLayout {
    id: vollayout
    anchors.centerIn: parent
    implicitHeight: Theme.barHeight
    IconImage {
      id: volicon
      implicitSize: Theme.fontSize
      mipmap: true
      source: Qt.resolvedUrl(root.sinkIconType(root.sink))
    }
    StyledText {
      id: vol
      text: (root.sink && root.sink.audio) ? Math.round(root.sink.audio.volume * 100) + "%" : "-%"
      color: root.sink?.audio.muted ? Theme.surface2 : Theme.text
    }
  }

  MouseArea {
    visible: true
    anchors.fill: parent
    onClicked: {
      root.sink.audio.muted = !root.sink.audio.muted
    }
    cursorShape: Qt.PointingHandCursor
    onWheel: (wheel) => {
      if (wheel.angleDelta.y < 0) {
        root.sink.audio.volume -= 0.01
      }
      if (wheel.angleDelta.y > 0) {
        root.sink.audio.volume += 0.01
      }
      wheel.accepted = true;
    }
  }
}
