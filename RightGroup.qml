import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
  id: root

  required property int outerMarginU
  required property int innerMarginLR
  required property int barheight
  required property PanelWindow mainWindow

  height: barheight

  anchors {
    right: parent.right
  }

  RowLayout {
    id: innerLayout

    height: parent.height
    spacing: 0

    anchors {
      top: parent.top
      topMargin: root.outerMarginU
      right: parent.right
    }

    // Content
    BorderL {
      background: "transparent"
      foreground: Theme.mantle
      height: parent.height
    }

    Rectangle {
      id: text1
      color: Theme.mantle
      height: parent.height
      width: childrenRect.width
      Layout.alignment: Qt.AlignVCenter

      RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        Text {
          text: "beansbeans"
          color: Theme.text
        }
      }
    }

    BorderL {
      foreground: Theme.base
      background: Theme.mantle
      height: parent.height
      // outerMargin: root.innerMarginLR
    }

    Rectangle {
      id: text2
      color: Theme.base
      height: parent.height
      width: childrenRect.width + (root.innerMarginLR * 1.5)
      Layout.alignment: Qt.AlignVCenter

      RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        x: root.innerMarginLR * 0.5
        Text {
          text: "beans"
          color: Theme.text
        }
      }
    }

    BorderL {
      background: Theme.base
      foreground: Theme.surface0
      height: parent.height
    }

    BorderL {
      background: Theme.surface0
      foreground: "transparent"
      height: parent.height
      Layout.rightMargin: root.innerMarginLR * 0.2
    }

    Rectangle {
      id: powerButton
      width: parent.height
      height: parent.height
      radius: parent.height / 2
      color: powerHover.hovered ? Theme.surface1 : Theme.surface0

      Layout.rightMargin: root.innerMarginLR

      Behavior on color {
        ColorAnimation { duration: 100 }
      }

      HoverHandler {
        id: powerHover
        cursorShape: Qt.PointingHandCursor
      }
    }
  }
}
