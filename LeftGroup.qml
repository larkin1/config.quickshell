import QtQuick
import QtQuick.Layouts

Item {
  id: root

  required property int outerMarginU
  required property int innerMarginLR
  required property int barheight

  height: barheight

  RowLayout {
    id: innerLayout

    height: parent.height
    spacing: 0

    anchors {
      top: parent.top
      topMargin: root.outerMarginU
    }

    // Content

    BorderL {
      background: "transparent"
      foreground: Theme.base
      height: parent.height
      Layout.leftMargin: root.innerMarginLR
    }

    Rectangle {
      id: text1
      color: Theme.base
      height: parent.height
      width: childrenRect.width
      Layout.alignment: Qt.AlignVCenter

      RowLayout {
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
      height: parent.height
      outerMargin: root.innerMarginLR
    }

    Rectangle {
      id: text2
      color: Theme.mantle
      height: parent.height
      width: childrenRect.width
      Layout.alignment: Qt.AlignVCenter

      RowLayout {
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
      height: parent.height
    }
  }
}
