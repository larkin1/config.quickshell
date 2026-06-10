import QtQuick
import QtQuick.Layouts

Item {
  id: root

  required property int outerMarginU
  required property int innerMarginLR
  required property int barheight

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
      outerMargin: root.innerMarginLR
    }

    Rectangle {
      id: text2
      color: Theme.mantle
      height: parent.height
      width: childrenRect.width
      Layout.alignment: Qt.AlignVCenter

      RowLayout {
        Text {
          text: "beans"
          color: Theme.text
        }
      }
    }

    BorderL {
      background: Theme.mantle
      foreground: "transparent"
      height: parent.height
      Layout.rightMargin: root.innerMarginLR
      outerMargin: root.innerMarginLR
    }
  }
}
