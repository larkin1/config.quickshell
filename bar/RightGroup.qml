import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
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
      color: "orange"
      implicitWidth: ee.implicitWidth
      implicitHeight: Theme.barHeight
      RowLayout {
        id: ee
        spacing: Theme.horizMargin / 2
        Repeater {
          model: SystemTray.items
          delegate: Rectangle {
            implicitWidth: chil.implicitWidth
            implicitHeight: Theme.barHeight
            color: "transparent"
            IconImage {
              id: chil
              anchors.centerIn: parent
              implicitSize: 20
              mipmap: true
              source: modelData.icon // qmllint disable unqualified
            }
            MouseArea {
              onClicked: (button) => {
                menu.visible = true
                if (button.button === Qt.RightButton) {
                  menu.visible = true
                }
              }
            }

            PopupWindow {
              id: menu
              visible: false
              anchor.window: QsWindow.window
              anchor.rect.x: 100
              anchor.rect.y: 100
              anchor.rect.width: 100
              anchor.rect.height: 100
              Rectangle {
                anchors.fill: parent
                color: "green"
              }
            }
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
    }
  }
}
