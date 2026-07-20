import QtQuick
import QtQuick.Layouts
import "../.."

Item {
  id: root

  Rectangle {
    id: powerButton
    implicitWidth: Theme.barHeight
    Layout.fillHeight: true
    radius: Theme.barHeight / 2
    // color: powerHover.hovered ? Theme.surface1 : Theme.surface0
    color: Theme.surface0
    // Behavior on color {
    //   ColorAnimation { duration: 200 }
    // }

    Layout.rightMargin: Theme.horizMargin

    Text {
      font.family: Theme.font
      font.weight: Theme.fontWeight
      font.pixelSize: Theme.fontSize
      anchors.centerIn: parent
      text: ""

      color: powerHover.hovered ? Theme.red : Theme.text
      Behavior on color {
        ColorAnimation { duration: 200 }
      }
    }

    HoverHandler {
      id: powerHover
      cursorShape: Qt.PointingHandCursor
    }
  }
}
