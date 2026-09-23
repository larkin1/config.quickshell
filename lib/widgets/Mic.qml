import QtQuick
import QtQuick.Effects
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import "../.."

Item {
  id: root
  implicitWidth: micIcon.implicitWidth + Theme.horizMargin
  implicitHeight: Theme.barHeight

  signal changed()

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
    layer.enabled: true
    layer.effect: MultiEffect {
      colorization: 1.00
      colorizationColor: root.source?.audio.muted ? Theme.overlay0 : Theme.text // qmllint disable unqualified
    }
    onSourceChanged: { root.changed() }
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
