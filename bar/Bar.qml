import QtQuick
import QtQuick.Layouts
import Quickshell
import ".."

Variants {
  model: Quickshell.screens

  PanelWindow { // qmllint disable uncreatable-type
    id: root

    screen: modelData
    color: "transparent"
    implicitHeight: Theme.barHeight + Theme.barVertSpacing

    anchors {
      top: true
      left: true
      right: true
    }

    required property ShellScreen modelData

    RowLayout {
      spacing: 0
      anchors {
        fill: parent
        topMargin: Theme.barVertSpacing
      }

      Item {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.preferredWidth: 0
        LeftGroup {
          anchors.fill: parent
        }
      }

      MultiButton {}

      Item {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.preferredWidth: 0
        RightGroup {
          anchors.fill: parent
        }
      }
    }
  }
}
