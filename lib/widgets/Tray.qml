import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "../.."

Item {
  id: root
  property var window: QsWindow.window
  implicitWidth: tray.implicitWidth + Theme.horizMargin * 2
  implicitHeight: Theme.barHeight
  RowLayout {
    x: Theme.horizMargin/2
    id: tray
    spacing: 0
    Repeater {
      model: SystemTray.items
      delegate: Rectangle {
        implicitWidth: icon.implicitWidth + Theme.horizMargin / 2
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
          acceptedButtons: Qt.LeftButton | Qt.RightButton
          cursorShape: Qt.PointingHandCursor
          onClicked: (mouse) => {
            if (mouse.button == Qt.RightButton) {
              // trayMenu.visible = true;
              if (modelData.menu) {
                menu.menu = modelData.menu;
                menu.open();
              }
            } else {
              if (!modelData.onlyMenu) {
                modelData.activate()
              } else {
                // trayMenu.visible = true;
                if (modelData.menu) {
                  menu.menu = modelData.menu;
                  menu.open();
                }
              }
            }
            // qmllint enable
          }
        }
      }
    }
  }
  QsMenuAnchor {
    id: menu
    anchor.window: root.window
    anchor.rect.x: root.window?.width ?? 0
    anchor.rect.y: root.window?.height ?? 0
  }
}
