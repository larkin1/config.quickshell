import Quickshell
import QtQuick
import QtQuick.Layouts

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
    BorderL {
      background: "transparent"
      foreground: Theme.mantle
      itemHeight: root.barheight
    }

    Rectangle {
      id: text1
      color: Theme.mantle
      Layout.fillHeight: true
      width: text1InnerContent.implicitWidth

      RowLayout {
        id: text1InnerContent
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
      itemHeight: root.barheight
    }

    Rectangle {
      id: text2
      color: Theme.base
      Layout.fillHeight: true
      width: text2InnerContent.implicitWidth + (root.innerMarginLR * 1.5)

      Text {
        id: text2InnerContent
        anchors {
          verticalCenter: parent.verticalCenter
          left: parent.left
          leftMargin: root.innerMarginLR * 0.5
        }
        text: "beans"
        color: Theme.text
      }
    }

    BorderL {
      background: Theme.base
      foreground: Theme.surface0
      itemHeight: root.barheight
    }

    BorderL {
      background: Theme.surface0
      foreground: "transparent"
      Layout.rightMargin: root.innerMarginLR * 0.2
      itemHeight: root.barheight
    }

    Rectangle {
      id: powerButton
      width: root.barheight
      Layout.fillHeight: true
      radius: root.barheight / 2
      // color: powerHover.hovered ? Theme.surface1 : Theme.surface0
      color: Theme.surface0
      // Behavior on color {
      //   ColorAnimation { duration: 200 }
      // }

      Layout.rightMargin: root.innerMarginLR
      
      Text {
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
