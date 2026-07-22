import QtQuick
import Quickshell
import QtQuick.Layouts
import "../.."

Item {
  id: root
  readonly property real widthRatio: 1
  readonly property real heightRatio: 0.2

  component PowerButton: Rectangle {
    id: btn

    property string btnText
    property color baseColor
    property color hoverColor
    property int openDelay: 0
    property bool expanded: false

    color: baseColor
    implicitWidth: expanded ? lbl.implicitWidth + 200 : 0
    Layout.fillHeight: true

    HoverHandler {
      id: btnHover
    }

    Rectangle {
      color: btnHover.hovered ? btn.hoverColor : btn.baseColor
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
      id: lbl
      text: btn.btnText
      anchors.centerIn: parent
      font.pixelSize: 40
      font.weight: 800
    }

    Behavior on implicitWidth {
      enabled: !btn.expanded
      SequentialAnimation {
        PauseAnimation { duration: btn.openDelay }
        NumberAnimation {
          duration: Theme.animationDuration
          easing.type: Easing.InQuart
        }
      }
    }
  }

  PanelWindow { //qmllint disable uncreatable-type
    id: windowRoot

    visible: root.visible

    color: "transparent"

    property string screenwidth: QsWindow.window?.screen.width ?? "" // qmllint disable missing-property
    property string screenheight: QsWindow.window?.screen.height ?? "" // qmllint disable missing-property

    implicitWidth: screenwidth * root.widthRatio
    implicitHeight: screenheight * root.heightRatio

    margins.bottom: (screenheight - height) / 2 //qmllint disable

    anchors {
      bottom: true
      left: true
    }

    onScreenChanged: {
      windowRoot.implicitWidth = windowRoot.screenwidth * root.widthRatio
      windowRoot.implicitHeight = windowRoot.screenheight * root.heightRatio
      windowRoot.margins.bottom = (windowRoot.screenheight - windowRoot.implicitHeight) / 2 //qmllint disable
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

      PowerButton {
        btnText: "reboot"
        baseColor: Theme.surface0
        hoverColor: Theme.surface1
        openDelay: 0
        expanded: windowRoot.visible
      }

      Border {
        foreground: Theme.surface0
        background: Theme.base
        itemHeight: windowRoot.implicitHeight
        reversed: false
      }

      PowerButton {
        btnText: "poweroff"
        baseColor: Theme.base
        hoverColor: Theme.surface0
        openDelay: 250
        expanded: windowRoot.visible
      }

      Border {
        foreground: Theme.base
        background: Theme.mantle
        itemHeight: windowRoot.implicitHeight
        reversed: false
      }

      PowerButton {
        btnText: "sleep"
        baseColor: Theme.mantle
        hoverColor: Theme.base
        openDelay: 500
        expanded: windowRoot.visible
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
