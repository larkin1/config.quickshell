import QtQuick
import Quickshell
import QtQuick.Layouts
import "../.."

Item {
  id: root
  readonly property real widthRatio: 1
  readonly property real heightRatio: 0.2

  PanelWindow {
    id: windowRoot

    visible: root.visible

    color: "transparent"

    property string screenwidth: QsWindow.window?.screen.width ?? "" // qmllint disable missing-property
    property string screenheight: QsWindow.window?.screen.height ?? "" // qmllint disable missing-property

    implicitWidth: screenwidth * root.widthRatio
    implicitHeight: screenheight * root.heightRatio

    margins.bottom: (screenheight - height) / 2
    // margins.left: (screenwidth - width) / 2

    anchors {
      bottom: true
      left: true
    }

    onScreenChanged: {
      windowRoot.implicitWidth = windowRoot.screenwidth * root.widthRatio
      windowRoot.implicitHeight = windowRoot.screenheight * root.heightRatio
      // windowRoot.margins.left = (windowRoot.screenwidth - windowRoot.implicitWidth) / 2
      windowRoot.margins.bottom = (windowRoot.screenheight - windowRoot.implicitHeight) / 2
    }

    RowLayout {
      spacing: 0
      anchors.centerIn: parent

      Border {
        background: "transparent"
        foreground: Theme.surface0
        itemHeight: windowRoot.implicitHeight
        reversed: true
      }

      Rectangle {
        color: Theme.surface0
        implicitWidth: windowRoot.visible ? reboot.implicitWidth + 200 : 0
        Layout.fillHeight: true

        HoverHandler {
          id: rebootHover
        }

        Rectangle {
          color: rebootHover.hovered ? Theme.surface1 : Theme.surface0
          implicitWidth: parent.width * 0.8
          implicitHeight: parent.height * 0.8
          radius: parent.height * 0.5
          anchors.centerIn: parent
          Behavior on color {
            ColorAnimation {
              duration: 200
            }
          }
        }

        StyledText {
          id: reboot
          text: "Reboot"
          anchors.centerIn: parent
          font.pixelSize: 40
          font.weight: 800
        }

        Behavior on implicitWidth {
          enabled: !windowRoot.visible
          SequentialAnimation {
            PauseAnimation { duration: 0 }
            NumberAnimation {
              duration: 200
              easing.type: Easing.InQuart
            }
          }
        }
      }

      Border {
        foreground: Theme.surface0
        background: Theme.base
        itemHeight: windowRoot.implicitHeight
        reversed: false
      }

      Rectangle {
        color: Theme.base
        implicitWidth: windowRoot.visible ? poweroff.implicitWidth + 200 : 0
        Layout.fillHeight: true

        HoverHandler {
          id: poweroffHover
        }

        Rectangle {
          color: poweroffHover.hovered ? Theme.surface0 : Theme.base
          implicitWidth: parent.width * 0.8
          implicitHeight: parent.height * 0.8
          radius: parent.height * 0.5
          anchors.centerIn: parent
          Behavior on color {
            ColorAnimation {
              duration: 200
            }
          }
        }

        StyledText {
          id: poweroff
          text: "Poweroff"
          anchors.centerIn: parent
          font.pixelSize: 40
          font.weight: 800
        }

        Behavior on implicitWidth {
          enabled: !windowRoot.visible
          SequentialAnimation {
            PauseAnimation { duration: 200 }
            NumberAnimation {
              duration: 200
              easing.type: Easing.InQuart
            }
          }
        }
      }

      Border {
        foreground: Theme.base
        background: Theme.mantle
        itemHeight: windowRoot.implicitHeight
        reversed: false
      }

      Rectangle {
        color: Theme.mantle
        implicitWidth: windowRoot.visible ? sleep.implicitWidth + 200 : 0
        Layout.fillHeight: true

        HoverHandler {
          id: sleepHover
        }

        Rectangle {
          color: sleepHover.hovered ? Theme.base : Theme.mantle
          implicitWidth: parent.width * 0.8
          implicitHeight: parent.height * 0.8
          radius: parent.height * 0.5
          anchors.centerIn: parent
          Behavior on color {
            ColorAnimation {
              duration: 200
            }
          }
        }

        StyledText {
          id: sleep
          text: "Sleep"
          anchors.centerIn: parent
          font.pixelSize: 40
          font.weight: 800
        }

        Behavior on implicitWidth {
          enabled: !windowRoot.visible
          SequentialAnimation {
            PauseAnimation { duration: 400 }
            NumberAnimation {
              duration: 200
              easing.type: Easing.InQuart
            }
          }
        }
      }

      Border {
        foreground: Theme.mantle
        background: "transparent"
        itemHeight: windowRoot.implicitHeight
        reversed: false
      }
    }
  }
}
