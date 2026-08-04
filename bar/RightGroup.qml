import QtQuick
import QtQuick.Layouts
import ".."

Item {
  id: root

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
      reversed: true
      implicitHeight: Theme.barHeight
      HoverHandler {
        id: audioHoverInit
        onHoveredChanged: {
          if (hovered) {
            audioCloseTimer.stop()
            audioOpen.start()
          }
        }
      }
    }

    Rectangle {
      id: audioRect

      implicitWidth: 0
      implicitHeight: Theme.barHeight
      color: Theme.mantle
      clip: true

      HoverHandler {
        id: audioHover
        onHoveredChanged: {
          if (hovered) {
            audioCloseTimer.stop()
          } else {
            audioCloseTimer.restart()
          }
        }
      }

      Timer {
        id: audioCloseTimer
        interval: Theme.collapseTimeout
        onTriggered: {
          audioClose.start()
        }
      }

      RowLayout {
        id: audio
        anchors.centerIn: parent
        Mic {
          id: mic
          onChanged: {
            audioOpen.start()
            audioCloseTimer.restart()
          }
        }
        OutVol {
          id: outVol
          onChanged: {
            audioOpen.start()
            audioCloseTimer.restart()
          }
        }
      }

      SequentialAnimation {
        id: audioOpen
        PropertyAnimation {
          target: audioRect
          property: "implicitWidth"
          to: audio.implicitWidth
          duration: Theme.animationDuration
          easing: Theme.animationEasing
        }
        PropertyAnimation {
          target: audio
          property: "opacity"
          to: 1
          duration: Theme.animationDuration
          easing: Theme.animationEasing
        }
      }
      SequentialAnimation {
        id: audioClose
        PropertyAnimation {
          target: audio
          property: "opacity"
          to: 0
          duration: Theme.animationDuration
          easing: Theme.animationEasing
        }
        PropertyAnimation {
          target: audioRect
          property: "implicitWidth"
          to: 0
          duration: Theme.animationDuration
          easing: Theme.animationEasing
        }
      }
    }

    Border {
      foreground: Theme.base
      background: Theme.mantle
      reversed: true
      implicitHeight: Theme.barHeight
    }

    Rectangle {
      id: battRect
      color: Theme.base
      implicitHeight: Theme.barHeight
      implicitWidth: batt.implicitWidth
      Battery {
        id: batt
      }
    }

    Border {
      background: Theme.base
      foreground: Theme.surface0
      reversed: true
      implicitHeight: Theme.barHeight
      HoverHandler {
        id: trayHoverInit
        onHoveredChanged: {
          if (hovered) {
            trayChangeWaiter.stop()
            trayOpen.start()
          }
        }
      }
    }

    Rectangle {
      id: trayRect

      clip: true
      color: Theme.surface0
      implicitHeight: Theme.barHeight
      implicitWidth: 0

      HoverHandler {
        id: trayHover
        onHoveredChanged: {
          if (hovered) {
            trayChangeWaiter.stop()
          } else {
            trayChangeWaiter.start()
          }
        }
      }

      Timer {
        id: trayChangeWaiter
        interval: Theme.collapseTimeout
        onTriggered: {
          trayClose.start()
        }
      }

      Tray {
        id: tray
        onChanged: {
          trayOpen.start()
          trayChangeWaiter.restart()
        }
      }

      SequentialAnimation {
        id: trayOpen
        PropertyAnimation {
          target: trayRect
          property: "implicitWidth"
          to: tray.implicitWidth
          duration: Theme.animationDuration
          easing: Theme.animationEasing
        }
        PropertyAnimation {
          target: tray
          property: "opacity"
          to: 1
          duration: Theme.animationDuration
          easing: Theme.animationEasing
        }
      }
      SequentialAnimation {
        id: trayClose
        PropertyAnimation {
          target: tray
          property: "opacity"
          to: 0
          duration: Theme.animationDuration
          easing: Theme.animationEasing
        }
        PropertyAnimation {
          target: trayRect
          property: "implicitWidth"
          to: 0
          duration: Theme.animationDuration
          easing: Theme.animationEasing
        }
      }
    }

    Border {
      background: Theme.surface0
      foreground: "transparent"
      Layout.rightMargin: Theme.horizMargin * 0.2
      reversed: true
      implicitHeight: Theme.barHeight
    }

    PowerButton {
      id: power
      Layout.rightMargin: (Theme.horizMargin/1.5)
      onClicked: {
        // PowerMenu.visible = true
        ShellUI.openPower()
      }
    }
  }
}
