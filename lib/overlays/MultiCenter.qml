import QtQuick
import QtQuick.Layouts
import Quickshell
import "../.."

Item {
  id: root

  implicitWidth: parent.width
  x: parent.x
  visible: open

  signal closed()

  property var window: QsWindow.window
  property bool hovered: windowHover.hovered
  property bool open: false

  required property int expandedWidth

  onOpenChanged: {
    if (open) {
      openAnim.start()
    } else {
      window.implicitHeight = root.height
    }
  }

  PopupWindow {
    id: window

    visible: root.visible
    grabFocus: true
    color: "transparent"
    anchor {
      item: root
      rect.x: root.x
      rect.y: 0
    }
    implicitWidth: root.width
    implicitHeight: root.height

    onVisibleChanged: {
      if (!visible && root.open) {
        root.closed()
      }
    }

    Rectangle {
      id: background
      anchors.topMargin: root.height
      anchors.fill: parent
      color: Theme.backgroundBlur
      bottomLeftRadius: Theme.vertMargin
      bottomRightRadius: Theme.vertMargin

      Rectangle {
        id: content
        color: "transparent"
        anchors.fill: parent

        GridLayout {
          id: buttonGrid
          columns: 2
          rowSpacing: Theme.vertMargin
          columnSpacing: Theme.horizMargin
          implicitWidth: childrenRect.width
          anchors.centerIn: parent

          property var buttons: [
            {activeIcon: "", inactiveIcon: "", action: () => {console.log("sdflkjsdl")}},
            {activeIcon: "", inactiveIcon: "", action: () => {console.log("sdflkjsdl")}},
            {activeIcon: "", inactiveIcon: "", action: () => {console.log("sdflkjsdl")}},
            {activeIcon: "", inactiveIcon: "", action: () => {console.log("sdflkjsdl")}},
          ]

          Repeater {
            model: buttonGrid.buttons

            Rectangle {
              id: button
              required property var modelData

              Layout.alignment: Qt.AlignHCenter
              implicitHeight: implicitWidth / 3 // each border is 1/2 height, so 3 means the middle rect will be square
              implicitWidth: (root.expandedWidth / 2) - Theme.horizMargin*2 // qmllint disable unqualified
              color: "transparent"
              HoverHandler { id: buttonHover }

              MouseArea {
                anchors.fill: parent
                onClicked: {
                  button.modelData.action()
                }
              }

              Border {
                id: borderL
                foreground: Theme.surface0
                background: "transparent"
                itemHeight: parent.height
                reversed: true
              }
              Border {
                x: borderL.width
                foreground: Theme.surface1
                background: Theme.surface0
                itemHeight: parent.height
                reversed: true
              }
              Rectangle {
                x: borderL.width * 2
                color: Theme.surface1
                implicitWidth: parent.width - borderL.width*4
                implicitHeight: parent.height
              }
              Border {
                anchors.right: parent.right
                anchors.rightMargin: borderL.width
                foreground: Theme.surface1
                background: Theme.surface0
                itemHeight: parent.height
              }
              Border {
                anchors.right: parent.right
                foreground: Theme.surface0
                background: "transparent"
                itemHeight: parent.height
              }
            }
          }
        }
      }
    }

    HoverHandler { id: windowHover }

    SequentialAnimation {
      id: openAnim
      PropertyAction {
        target: content
        property: "opacity"
        value: 0
      }
      PauseAnimation { duration: Theme.animationDuration }
      PropertyAnimation {
        target: window
        property: "implicitHeight"
        duration: Theme.animationDuration
        from: root.height
        to: root.height + buttonGrid.implicitHeight + (Theme.vertMargin * 3)
      }
      PropertyAnimation {
        target: content
        property: "opacity"
        duration: Theme.animationDuration
        from: 0
        to: 1
      }
    }
  }
}
