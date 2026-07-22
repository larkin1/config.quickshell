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
    }

    Rectangle {
      color: Theme.surface0
      implicitWidth: tray.implicitWidth
      implicitHeight: Theme.barHeight
      Tray {
        id: tray
        anchors.centerIn: parent
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
    }
  }
}
