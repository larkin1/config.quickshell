import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "../.."

Item {
  id: root
  property var window: QsWindow.window
  implicitWidth: tray.implicitWidth + Theme.horizMargin
  implicitHeight: Theme.barHeight
  clip: true
  Behavior on implicitWidth {
    NumberAnimation {
      duration: Theme.animationDuration
      easing: Theme.animationEasing
    }
  }
  RowLayout {
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
              if (modelData.menu) {
                menu.menu = modelData.menu;
                menu.open();
              }
            } else {
              if (!modelData.onlyMenu) {
                modelData.activate()
              } else {
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
