import QtQuick
import QtQuick.Layouts
import ".."

Item {
  id: root

  required property int outerMarginU
  required property int innerMarginLR
  required property int barheight

  implicitHeight: barheight

  anchors {
    horizontalCenter: parent.horizontalCenter
  }

  RowLayout {
    id: leftLayout
    spacing: 0

    anchors {
      top: parent.top
      topMargin: root.outerMarginU
      bottom: parent.bottom
      right: centerLayout.left
    }

    // Content
    Border {
      background: "transparent"
      foreground: Theme.surface0
      itemHeight: root.barheight
      Layout.leftMargin: root.innerMarginLR
      reversed: true
    }

    Rectangle {
      id: text1
      color: Theme.surface0
      Layout.fillHeight: true
      implicitWidth: text1InnerContent.implicitWidth + root.innerMarginLR

      Text {
        id: text1InnerContent
        anchors.centerIn: parent
        // text: "ERRR"
        // text: cpuTracker.cpuUsage + "%"
        color: Theme.text
        font.family: Theme.font
        font.weight: Theme.fontWeight
        font.pixelSize: Theme.fontSize
      }
    }
  }

  RowLayout {
    id: centerLayout

    height: root.barheight
    spacing: 0

    anchors {
      top: parent.top
      topMargin: root.outerMarginU
      horizontalCenter: root.horizontalCenter
    }

    Border {
      background: Theme.surface0
      foreground: "transparent"
      itemHeight: root.barheight
      reversed: true
    }

    Border {
      background: "transparent"
      foreground: Theme.mauve
      itemHeight: root.barheight
      reversed: true
    }

    Rectangle {
      id: text2
      color: Theme.mauve
      Layout.fillHeight: true
      implicitWidth: text2InnerContent.implicitWidth + root.innerMarginLR

      RowLayout {
        id: text2InnerContent
        anchors.centerIn: parent
        Text {
          font.family: Theme.font
          font.weight: Theme.fontWeight
          font.pixelSize: Theme.fontSize
          text: ""
          color: Theme.crust
          Layout.topMargin: 1.5
          scale: 1.1
        }
      }
    }

    Border {
      foreground: Theme.mauve
      background: "transparent"
      itemHeight: root.barheight
      reversed: false
    }

    Border {
      foreground: "transparent"
      background: Theme.surface0
      itemHeight: root.barheight
      reversed: false
    }
  }

  RowLayout {
    id: rightLayout
    spacing: 0

    anchors {
      top: parent.top
      topMargin: root.outerMarginU
      bottom: parent.bottom
      left: centerLayout.right
    }

    // Content
    Rectangle {
      id: clockWidget
      color: Theme.surface0
      implicitWidth: clock.implicitWidth + root.innerMarginLR
      Layout.fillHeight: true

      Clock {
        id: clock
        fontSize: Theme.fontSize
        fontWeight: Theme.fontWeight
        fontFamily: Theme.font
        fontColor: Theme.text
        anchors.centerIn: parent
      }
    }

    Border {
      foreground: Theme.surface0
      background: "transparent"
      itemHeight: root.barheight
      reversed: false
    }
  }
}
