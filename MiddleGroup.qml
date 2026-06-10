import QtQuick
import QtQuick.Layouts

Item {
  id: root

  required property int outerMarginU
  required property int innerMarginLR
  required property int barheight

  height: barheight

  anchors {
    horizontalCenter: parent.horizontalCenter
  }


  RowLayout {
    id: leftLayout

    height: parent.height
    spacing: 0

    anchors {
      top: parent.top
      topMargin: root.outerMarginU
      right: centerLayout.left
    }

    // Content
    BorderL {
      background: "transparent"
      foreground: Theme.surface0
      height: parent.height
      Layout.leftMargin: root.innerMarginLR
    }

    Rectangle {
      id: text1
      color: Theme.surface0
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
  }

  RowLayout {
    id: centerLayout

    height: parent.height
    spacing: 0

    anchors {
      top: parent.top
      topMargin: root.outerMarginU
      horizontalCenter: root.horizontalCenter
    }

    BorderL {
      background: Theme.surface0
      foreground: "transparent"
      height: parent.height
    }

    BorderL {
      background: "transparent"
      foreground: Theme.mauve
      height: parent.height
    }


    Rectangle {
      id: text2
      color: Theme.mauve
      height: parent.height
      width: childrenRect.width
      Layout.alignment: Qt.AlignVCenter

      RowLayout {
        Text {
          Layout.topMargin: 2
          Layout.leftMargin: root.innerMarginLR * 0.4
          Layout.rightMargin: root.innerMarginLR * 0.3
          text: "󰣇"
          color: Theme.crust
          scale: 1.2
        }
      }
    }

    BorderR {
      foreground: Theme.mauve
      background: "transparent"
      height: parent.height
    }

    BorderR {
      foreground: "transparent"
      background: Theme.surface0
      height: parent.height
    }
  }

  RowLayout {
    id: rightLayout

    height: parent.height
    spacing: 0

    anchors {
      top: parent.top
      topMargin: root.outerMarginU
      left: centerLayout.right
    }

    // Content
    Rectangle {
      id: text3
      color: Theme.surface0
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
  }
  
}
