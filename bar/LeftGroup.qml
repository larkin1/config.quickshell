import QtQuick
import QtQuick.Layouts
import ".."

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
    Border {
      background: "transparent"
      foreground: Theme.base
      Layout.leftMargin: root.innerMarginLR
      itemHeight: root.barheight
      reversed: true
    }

    Rectangle { // Workspaces
      id: text1
      color: Theme.base
      Layout.fillHeight: true
      implicitWidth: workspaces.implicitWidth

      Behavior on implicitWidth {
        SpringAnimation {
          spring: 3
          damping: 0.2
        }
      }

      Workspaces {
        id: workspaces
        barheight: root.barheight
        bGColor: Theme.base
        activeBGColor: Theme.surface0
        inactiveTextColor: Theme.surface2
        activeTextColor: Theme.text
      }
    }

    Border {
      foreground: Theme.base
      background: Theme.mantle
      itemHeight: root.barheight
      outerMargin: root.innerMarginLR
      reversed: false
    }

    Rectangle {
      id: mediaWidget
      color: Theme.mantle
      implicitWidth: media.implicitWidth
      Layout.fillHeight: true

      Media {
        id: media
        fontSize: Theme.fontSize
        fontWeight: Theme.fontWeight
        fontFamily: Theme.font
        fontColor: Theme.text
        anchors.centerIn: parent
      }
    }

    Border {
      foreground: Theme.mantle
      background: "transparent"
      itemHeight: root.barheight
      reversed: false
    }
  }
}
