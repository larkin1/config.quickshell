import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../.."

Row {
  required property int barheight
  required property color bgColor
  required property color activeBGColor
  required property color inactiveTextColor
  required property color activeTextColor

  id: root
  anchors.verticalCenter: parent.verticalCenter
  height: barheight

  Repeater {
    id: workspacesRepeater
    model: Hyprland.workspaces

    // the weird ?s are to prevent some warnings from values being null at startup
    property string windowMonitor: QsWindow.window?.screen.name ?? "" // qmllint disable missing-property

    Rectangle {
      property var workspace: modelData // qmllint disable unqualified

      property string workspaceMonitor: workspace.monitor?.name ?? "" // ditto ^
      property bool onCurrentMonitor: workspaceMonitor == workspacesRepeater.windowMonitor // qmllint disable unqualified
      property bool isActive: workspace.focused

      visible: onCurrentMonitor
      width: isActive ? 50 : 30
      height: parent.height
      color: "transparent"

      Behavior on width {
        SpringAnimation {
          spring: 2
          damping: 0.2
        }
      }

      HoverHandler {
        id: workspaceHover
      }

      MouseArea {
        anchors.fill: parent
        onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + parent.workspace.id + " })")
        cursorShape: Qt.PointingHandCursor
      }

      Rectangle {
        width: parent.width - 3
        height: parent.height - 6
        color: workspaceHover.hovered ? root.activeBGColor : root.bgColor // qmllint disable unqualified
        radius: height/2
        anchors.centerIn: parent
        Behavior on color {
          ColorAnimation { duration: 200 }
        }
      }

      Text {
        rightPadding: 2
        text: parent.isActive ? "-" + parent.workspace.id + "-" : parent.workspace.id
        font.family: Theme.font
        font.weight: Theme.fontWeight
        font.pixelSize: Theme.fontSize
        color: parent.isActive ? root.activeTextColor : root.inactiveTextColor // qmllint disable unqualified
        anchors.centerIn: parent
      }
    }
  }
}
