import Quickshell
import QtQuick
import QtQuick.Layouts
import ".."

Item {
  id: root

  required property PanelWindow mainWindow

  implicitHeight: Theme.barHeight

  anchors {
    right: parent.right
  }

  RowLayout { // Content flows left-right
    id: innerRow
    spacing: 0

    anchors {
      top: parent.top
      topMargin: Theme.vertMargin
      bottom: parent.bottom
      right: parent.left
    }

    Border {
      background: "transparent"
      foreground: Theme.mantle
      itemHeight: Theme.barHeight
      reversed: true
      HoverHandler {
        id: audioHoverInit
      }
    }

    Rectangle {
      id: audioRect

      property bool change: false

      Timer {
        id: audioChangeWaiter
        interval: Theme.collapseTimeout
        onTriggered: {
          audioRect.change = false
        }
      }

      implicitWidth:
        (audioHoverInit.hovered || audioHover.hovered || audioRect.change)
        ? audio.implicitWidth : 0
      implicitHeight: Theme.barHeight
      color: Theme.mantle
      clip: true

      RowLayout {
        id: audio
        anchors.centerIn: parent
        opacity:
          (audioHoverInit.hovered || audioHover.hovered || audioRect.change)
          ? 1 : 0
        Mic {
          id: mic
          onChanged: {
            audioRect.change = true
            audioChangeWaiter.restart()
          }
        }
        OutVol {
          id: outVol
          onChanged: {
            audioRect.change = true
            audioChangeWaiter.restart()
          }
        }
        Behavior on opacity {
          SequentialAnimation {
            PauseAnimation {
              duration:
                (audioHoverInit.hovered || audioHover.hovered)
                ? Theme.collapseTimeout : 0
            }
            NumberAnimation {
              duration: Theme.animationDuration
            }
          }
        }
      }

      HoverHandler {
        id: audioHover
      }

      Behavior on implicitWidth {
        SequentialAnimation {
          PauseAnimation {
            duration:
                (audioHoverInit.hovered || audioHover.hovered)
                ? Theme.collapseTimeout : 0
          }
          NumberAnimation {
            duration: Theme.animationDuration
            easing: Theme.animationEasing
          }
        }
      }
    }

    Border {
      foreground: Theme.base
      background: Theme.mantle
      itemHeight: Theme.barHeight
      reversed: true
    }

    Border {
      background: Theme.base
      foreground: Theme.surface0
      itemHeight: Theme.barHeight
      reversed: true
      HoverHandler { id: trayHoverInit }
    }

    Rectangle {
      id: trayRect

      clip: true
      color: Theme.surface0
      implicitHeight: Theme.barHeight
      implicitWidth:
        (trayHoverInit.hovered || trayHover.hovered || trayRect.change)
        ? tray.implicitWidth : 0

      HoverHandler {
        id: trayHover
      }

      property bool change: false

      Timer {
        id: trayChangeWaiter
        interval: Theme.collapseTimeout
        onTriggered: {
          trayRect.change = false
        }
      }

      Tray {
        id: tray
        opacity:
          (trayHoverInit.hovered || trayHover.hovered || trayRect.change)
          ? 1 : 0
        onChanged: {
          trayRect.change = true
          trayChangeWaiter.restart()
        }
        Behavior on opacity {
          SequentialAnimation {
            PauseAnimation {
              duration:
                (trayHoverInit.hovered || trayHover.hovered)
                ? Theme.collapseTimeout : 0
            }
            NumberAnimation {
              duration: Theme.animationDuration
            }
          }
        }
      }

      Behavior on implicitWidth {
        SequentialAnimation {
          PauseAnimation {
            duration:
              (trayHoverInit.hovered || trayHover.hovered)
              ? Theme.collapseTimeout : 0
          }
          NumberAnimation {
            duration: Theme.animationDuration
          }
        }
      }
    }

    Border {
      background: Theme.surface0
      foreground: "transparent"
      Layout.rightMargin: Theme.horizMargin * 0.2
      itemHeight: Theme.barHeight
      reversed: true
    }

    PowerButton {
      id: power
      Layout.rightMargin: (Theme.horizMargin/1.5)
      onClicked: {
        PowerMenu.visible = true
      }
    }
  }
}
