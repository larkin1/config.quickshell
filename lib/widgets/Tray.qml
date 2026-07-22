import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "../.."

Item {
  id: root
  implicitWidth: tray.implicitWidth + Theme.horizMargin * 2
  implicitHeight: Theme.barHeight
  RowLayout {
    x: Theme.horizMargin/2
    id: tray
    spacing: Theme.horizMargin / 2
    Repeater {
      model: SystemTray.items
      delegate: Rectangle {
        id: trangle
        implicitWidth: icon.implicitWidth
        implicitHeight: Theme.barHeight
        color: "transparent"
        IconImage {
          id: icon
          anchors.centerIn: parent
          implicitSize: 20
          mipmap: true
          // qmllint disable unqualified
          source: modelData.icon
        }
        MouseArea {
          anchors.fill: parent
          onClicked: {
            trayMenu.visible = true;
            if (modelData.menu) {
              menu.menu = modelData.menu;
              console.log(eee.menu)
              menu.open();
              // qmllint enable
            }
          }
        }
      }
    }
  }
  PopupWindow {
    id: trayMenu
    visible: false
    anchor.window: QsWindow.window
    anchor.rect.x: root.x
    anchor.rect.y: root.y + Theme.barHeight + Theme.vertMargin
    color: "transparent"
    QsMenuAnchor {
      id: menu
      anchor.window: QsWindow.window
    }
    anchor.rect.width: 0
    anchor.rect.height: 0
  }
}
