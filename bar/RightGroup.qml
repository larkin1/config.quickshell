import Quickshell
import QtQuick
import QtQuick.Layouts
import ".."

Item {
  id: root

  required property int outerMarginU
  required property int innerMarginLR
  required property int barheight
  required property PanelWindow mainWindow

  // height: barheight
  implicitHeight: barheight

  anchors {
    right: parent.right
  }

  RowLayout {
    id: innerLayout
    spacing: 0

    anchors {
      top: parent.top
      topMargin: root.outerMarginU
      bottom: parent.bottom
      right: parent.left
    }

    // Content
    Border {
      background: "transparent"
      foreground: Theme.mantle
      itemHeight: root.barheight
      reversed: true
    }

    Rectangle {
      id: text1
      color: Theme.mantle
      Layout.fillHeight: true
      implicitWidth: text1InnerContent.implicitWidth

      RowLayout {
        id: text1InnerContent
        anchors.verticalCenter: parent.verticalCenter
        Text {
          text: "beansbeans"
          color: Theme.text
          font.family: Theme.font
          font.weight: Theme.fontWeight
          font.pixelSize: Theme.fontSize
        }
      }
    }

    Border {
      foreground: Theme.base
      background: Theme.mantle
      itemHeight: root.barheight
      reversed: true
    }

    Rectangle {
      id: text2
      color: Theme.base
      Layout.fillHeight: true
      implicitWidth: text2InnerContent.implicitWidth + (root.innerMarginLR * 1.5)

      Text {
        id: text2InnerContent
        anchors {
          verticalCenter: parent.verticalCenter
          left: parent.left
          leftMargin: root.innerMarginLR * 0.5
        }
        text: "beans"
        color: Theme.text
        font.family: Theme.font
        font.weight: Theme.fontWeight
        font.pixelSize: Theme.fontSize
      }
    }

    Border {
      background: Theme.base
      foreground: Theme.surface0
      itemHeight: root.barheight
      reversed: true
    }

    Border {
      background: Theme.surface0
      foreground: "transparent"
      Layout.rightMargin: root.innerMarginLR * 0.2
      itemHeight: root.barheight
      reversed: true
    }

    Rectangle {
      id: powerButton
      implicitWidth: root.barheight
      Layout.fillHeight: true
      radius: root.barheight / 2
      // color: powerHover.hovered ? Theme.surface1 : Theme.surface0
      color: Theme.surface0
      // Behavior on color {
      //   ColorAnimation { duration: 200 }
      // }

      Layout.rightMargin: root.innerMarginLR
      
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
}
