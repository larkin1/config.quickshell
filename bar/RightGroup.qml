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
      foreground: Theme.crust
      itemHeight: Theme.barHeight
      reversed: true
      HoverHandler {
        id: audioHoverInit
      }
    }

    Rectangle {
      implicitWidth: (audioHoverInit.hovered || audioHover.hovered) ? audio.implicitWidth : 0
      implicitHeight: Theme.barHeight
      color: Theme.crust
      clip: true

      RowLayout {
        id: audio
        anchors.centerIn: parent
        opacity: (audioHoverInit.hovered || audioHover.hovered) ? 1 : 0
        Mic {
          id: mic
        }
        OutVol {
          id: outVol
        }
        Behavior on opacity {
          NumberAnimation {
            duration: Theme.animationDuration
          }
        }
      }

      HoverHandler {
        id: audioHover
      }

      Behavior on implicitWidth {
        NumberAnimation {
          duration: Theme.animationDuration
          easing: Theme.animationEasing
        }
      }
    }

    Border {
      foreground: Theme.base
      background: Theme.crust
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
      implicitWidth: (trayHoverInit.hovered || trayHover.hovered ) ? tray.implicitWidth : 0
      implicitHeight: Theme.barHeight

      Tray {
        id: tray
        anchors.centerIn: parent
        opacity: (trayHoverInit.hovered || trayHover.hovered ) ? 1 : 0
        Behavior on opacity {
          NumberAnimation {
            duration: Theme.animationDuration
          }
        }
      }

      HoverHandler {
        id: trayHover
      }

      Behavior on implicitWidth {
        NumberAnimation {
          duration: Theme.animationDuration
          easing: Theme.animationEasing
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
