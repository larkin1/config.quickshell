import QtQuick
import QtQuick.Layouts

Item {
  id: root

  required property int outerMarginU
  required property int innerMarginLR
  required property int barheight

  implicitHeight: barheight

  RowLayout {
    id: innerLayout
    spacing: 0

    anchors {
      top: parent.top
      topMargin: root.outerMarginU
      bottom: parent.bottom
    }

    // Content
    BorderL {
      background: "transparent"
      foreground: Theme.base
      Layout.leftMargin: root.innerMarginLR
      itemHeight: root.barheight
    }

    Rectangle {
      id: text1
      color: Theme.base
      Layout.fillHeight: true
      width: text1InnerContent.implicitWidth

      RowLayout {
        id: text1InnerContent
        anchors.verticalCenter: parent.verticalCenter
        Text {
          text: "beans"
          color: Theme.text
        }
      }
    }

    BorderR {
      foreground: Theme.base
      background: Theme.mantle
      itemHeight: root.barheight
      outerMargin: root.innerMarginLR
    }

    Rectangle {
      id: text2
      color: Theme.mantle
      width: text2InnerContent.implicitWidth
      Layout.fillHeight: true

      RowLayout {
        id: text2InnerContent
        anchors.verticalCenter: parent.verticalCenter
        Text {
          text: "beans"
          color: Theme.text
        }
      }
    }

    BorderR {
      foreground: Theme.mantle
      background: "transparent"
      itemHeight: root.barheight
    }
  }
}
