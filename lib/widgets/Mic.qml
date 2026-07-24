import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import "../.."

Item {
  id: root
  implicitWidth: micIcon.implicitWidth + Theme.horizMargin
  implicitHeight: Theme.barHeight

  readonly property var source: Pipewire.defaultAudioSource

  PwObjectTracker {
    id: obj
    objects: root.source ? [ root.source ] : []
  }

  IconImage {
    id: micIcon
    implicitSize: Theme.iconSize
    anchors.centerIn: parent
    mipmap: true
    source: root.source?.audio.muted ? Qt.resolvedUrl("../../svg/mic-inactive.svg") : Qt.resolvedUrl("../../svg/mic-active.svg")
  }

  MouseArea {
    visible: true
    anchors.fill: parent
    onClicked: {
      root.source.audio.muted = !root.source.audio.muted
    }
    cursorShape: Qt.PointingHandCursor
  }
}
