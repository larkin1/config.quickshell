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

    Border {
      background: "transparent"
      foreground: Theme.base
      itemHeight: root.barheight
      reversed: true
    }

    Rectangle {
      color: Theme.base
      Layout.fillHeight: true
      implicitWidth: mem.width + root.innerMarginLR
      Mem {
        id: mem
        anchors.centerIn: parent
      }
    }

    Border {
      foreground: Theme.surface0
      background: Theme.base
      itemHeight: root.barheight
      reversed: true
    }


    Rectangle {
      color: Theme.surface0
      Layout.fillHeight: true
      implicitWidth: cpu.width + root.innerMarginLR
      Cpu {
        id: cpu
        anchors.centerIn: parent
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
      outerMargin: 4
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

    Rectangle {
      id: clockWidget
      color: Theme.surface0
      Layout.fillHeight: true
      implicitWidth: clock.implicitWidth + root.innerMarginLR

      Clock {
        id: clock
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
