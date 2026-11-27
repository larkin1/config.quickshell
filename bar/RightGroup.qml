import QtQuick
import Quickshell
import QtQuick.Layouts
import ".."

RowLayout {
  id: innerRow
  implicitHeight: Theme.barHeight
  spacing: 0

  Border {
    foreground: "transparent"
    background: Colors.md3.surface_container_highest
  }

  Rectangle {
    id: clockWidget
    color: Colors.md3.surface_container_highest
    Layout.fillHeight: true
    implicitWidth: clock.implicitWidth + Theme.margin

    Clock {
      id: clock
      anchors.centerIn: parent
    }
  }

  Border {
    foreground: Colors.md3.surface_container_highest
    background: Colors.md3.surface_container
  }

  Rectangle {
    id: dateWidget
    color: Colors.md3.surface_container
    Layout.fillHeight: true
    implicitWidth: date.implicitWidth + Theme.margin

    Clock {
      id: date
      anchors.centerIn: parent
      timeStr: "MM-dd"
      altTimeStr: "dddd d MMMM, yyyy"
      precision: SystemClock.Minutes
    }
  }

  Border {
    foreground: Colors.md3.surface_container
    background: "transparent"
  }

  Item {
    Layout.fillWidth: true
  }

  Border {
    background: "transparent"
    foreground: Colors.md3.surface_container_lowest
    reversed: true
    HoverHandler {
      id: audioHoverInit
      onHoveredChanged: {
        if (hovered) {
          audioCloseTimer.stop();
          audioOpen.start();
        } else {
          audioCloseTimer.restart();
        }
      }
    }
  }

  Rectangle {
    id: audioRect

    implicitWidth: 0
    implicitHeight: Theme.barHeight
    color: Colors.md3.surface_container_lowest
    clip: true

    HoverHandler {
      id: audioHover
      onHoveredChanged: {
        if (hovered) {
          audioCloseTimer.stop();
        } else {
          audioCloseTimer.restart();
        }
      }
    }

    Timer {
      id: audioCloseTimer
      interval: Theme.collapseTimeout
      onTriggered: {
        if (!audioHover.hovered) {
          audioClose.start();
        }
      }
    }

    RowLayout {
      id: audio
      anchors.centerIn: parent
      Mic {
        id: mic
        onChanged: {
          audioOpen.start();
          audioCloseTimer.restart();
        }
      }
      OutVol {
        id: outVol
        onChanged: {
          audioOpen.start();
          audioCloseTimer.restart();
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
    foreground: Colors.md3.surface_container
    background: Colors.md3.surface_container_lowest
    reversed: true
  }

  Rectangle {
    id: battRect
    color: Colors.md3.surface_container
    implicitHeight: Theme.barHeight
    implicitWidth: batt.implicitWidth
    Battery {
      id: batt
    }
  }

  Border {
    background: Colors.md3.surface_container
    foreground: Colors.md3.surface_container_highest
    reversed: true
    HoverHandler {
      id: trayHoverInit
      onHoveredChanged: {
        if (hovered) {
          trayCloseTimer.stop();
          trayOpen.start();
        } else {
          trayCloseTimer.restart();
        }
      }
    }
  }

  Rectangle {
    id: trayRect

    clip: true
    color: Colors.md3.surface_container_highest
    implicitHeight: Theme.barHeight
    implicitWidth: 0

    HoverHandler {
      id: trayHover
      onHoveredChanged: {
        if (hovered) {
          trayCloseTimer.stop();
        } else {
          trayCloseTimer.start();
        }
      }
    }

    Timer {
      id: trayCloseTimer
      interval: Theme.collapseTimeout
      onTriggered: {
        if (!trayHover.hovered) {
          trayClose.start();
        }
      }
    }

    Tray {
      id: tray
      onChanged: {
        trayOpen.start();
        trayCloseTimer.restart();
      }
    }

    SequentialAnimation {
      id: trayOpen
      PropertyAnimation {
        target: trayRect
        property: "implicitWidth"
        to: tray.implicitWidth + Theme.margin / 2
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
    background: Colors.md3.surface_container_highest
    foreground: "transparent"
    Layout.rightMargin: Theme.margin * 0.2
    reversed: true
    implicitHeight: Theme.barHeight
  }

  PowerButton {
    id: power
    Layout.rightMargin: (Theme.margin / 1.5)
    onClicked: {
      if (Record.recording) {
        Record.toggle();
      } else {
        ShellUI.openPower();
      }
    }
  }
}
