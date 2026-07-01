import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Item {
  id: root

  required property int outerMarginU
  required property int innerMarginLR
  required property int barheight
  required property PanelWindow bar

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
        Repeater {
         model: Hyprland.workspaces

          Text {
            property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
            readonly property HyprlandMonitor monitor: Hyprland.monitorFor(root.bar.screen);

            text: modelData.id
            color: isActive ? Theme.text : Theme.surface0

            font.family: Theme.font
            font.weight: Theme.fontWeight
            font.pixelSize: Theme.fontSize

            MouseArea {
              anchors.fill: parent
              onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = \"" + (index + 1) + "\"})")
            }
          }
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
          font.family: Theme.font
          font.weight: Theme.fontWeight
          font.pixelSize: Theme.fontSize
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
