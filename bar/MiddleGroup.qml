import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import ".."

Item {
  id: root

  required property int outerMarginU
  required property int innerMarginLR
  required property int barheight

  // height: barheight
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
    BorderL {
      background: "transparent"
      foreground: Theme.surface0
      itemHeight: root.barheight
      Layout.leftMargin: root.innerMarginLR
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

    BorderL {
      background: Theme.surface0
      foreground: "transparent"
      itemHeight: root.barheight
    }

    BorderL {
      background: "transparent"
      foreground: Theme.mauve
      itemHeight: root.barheight
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

    BorderR {
      foreground: Theme.mauve
      background: "transparent"
      itemHeight: root.barheight
    }

    BorderR {
      foreground: "transparent"
      background: Theme.surface0
      itemHeight: root.barheight
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
      id: text3
      color: Theme.surface0
      implicitWidth: clock.implicitWidth + root.innerMarginLR
      Layout.fillHeight: true

      Text {
        id: clock
        text: "ERROR" // same length as 00:00 for spacing; displays ERROR if the command doesn't run correctly
        anchors.centerIn: parent
        color: Theme.text
        font.family: Theme.font
        font.weight: Theme.fontWeight
        font.pixelSize: Theme.fontSize
        Process {
          command: ["date", "+%H:%M"]
          running: true
          stdout: StdioCollector { 
            onStreamFinished: clock.text = this.text.trim()
          }
        }
      }
    }

    BorderR {
      foreground: Theme.surface0
      background: "transparent"
      itemHeight: root.barheight
    }
  }
}
