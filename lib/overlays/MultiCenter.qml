import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../.."

Item {
  id: root

  implicitWidth: parent.width
  x: parent.x
  visible: open

  signal closed()

  onClosed: {
    content.opacity = 0
  }

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
      if (visible) {
        content.forceActiveFocus()
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

        onFocusChanged: {
          if (focus) {
            var target = findDelegate(curRow, curCol)
            target.forceActiveFocus()
          }
        }

        property int curRow: 0
        property int curCol: 0

        property var buttons: [
          {row: 0, col: 0, activeIcon: "", inactiveIcon: "", action: () => {console.log("test0")}},
          {row: 0, col: 1, activeIcon: "", inactiveIcon: "", action: () => {console.log("test1")}},
          {row: 1, col: 0, activeIcon: "", inactiveIcon: "", action: () => {console.log("test2")}},
          {row: 1, col: 1, activeIcon: "", inactiveIcon: "", action: () => {console.log("test3")}},
        ]

        function findDelegate(row, col) {
          var maxRow = 0, maxCol = 0
          for (var i = 0; i < buttons.length; i++) {
            if (buttons[i].row > maxRow) maxRow = buttons[i].row
            if (buttons[i].col > maxCol) maxCol = buttons[i].col
          }

          var tr = Math.max(0, Math.min(row, maxRow))
          var tc = Math.max(0, Math.min(col, maxCol))

          // qmllint disable missing-property
          for (var j = 0; j < buttonRepeater.count; j++) {
            var d = buttonRepeater.itemAt(j)
            if (!d) continue
            if (d.cellRow === tr && d.cellCol == tc) {
              return d
            }
          }

          for (var k = 0; k < buttonRepeater.count; k++) {
            var dd = buttonRepeater.itemAt(k)
            if (!dd) continue
            if (dd.cellRow === tr && dd.cellCol >= tc) return dd
          }
          // qmllint enable missing-property

          return null
        }

        function moveFocus(dr, dc) {
          var target = findDelegate(curRow + dr, curCol + dc)
          if (target) {
            curRow = target.cellRow
            curCol = target.cellCol
            target.forceActiveFocus()
          }
        }

        GridLayout {
          id: buttonGrid
          columns: 2
          rowSpacing: Theme.vertMargin
          columnSpacing: Theme.horizMargin
          implicitWidth: childrenRect.width
          anchors.centerIn: parent


          Repeater {
            id: buttonRepeater
            model: content.buttons

            Rectangle {
              id: button
              required property var modelData
              property int cellRow: modelData.row
              property int cellCol: modelData.col

              Layout.row: modelData.row
              Layout.column: modelData.col

              // qmllint disable unqualified
              onFocusChanged: {
                if (focus) {
                  content.curRow = cellRow
                  content.curCol = cellCol
                }
              }

              Keys.onPressed: function(event) {
                switch (event.key) {
                  // navigation
                  case Qt.Key_H:
                  case Qt.Key_Left:
                    content.moveFocus(0, -1); break
                  case Qt.Key_J:
                  case Qt.Key_Down:
                    content.moveFocus(1,  0); break
                  case Qt.Key_K:
                  case Qt.Key_Up:
                    content.moveFocus(-1, 0); break
                  case Qt.Key_L:
                  case Qt.Key_Right:
                    content.moveFocus(0,  1); break

                  // actions
                  case Qt.Key_Escape:
                  case Qt.Key_Q:
                    root.closed(); break

                  case Qt.Key_Space:
                  case Qt.Key_Return:
                  case Qt.Key_Enter:
                    modelData.action(); break
                }
                if (["h", "j", "k", "l"].includes(event.text)) event.accepted = true
              }

              // qmllint enable unqualified

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
                reversed: true
              }
              Border {
                x: borderL.width
                foreground: Theme.surface1
                background: Theme.surface0
                reversed: true
              }
              Rectangle {
                x: borderL.width * 2
                color: Theme.surface1
                implicitWidth: parent.width - borderL.width*4
                implicitHeight: parent.height
                Rectangle {
                  color: button.focus ? Theme.surface2 : "transparent"
                  implicitHeight: parent.height * 0.85
                  implicitWidth: parent.width * 0.85
                  radius: height * 0.2
                  anchors.centerIn: parent
                  IconImage {
                  }
                }
              }
              Border {
                anchors.right: parent.right
                anchors.rightMargin: borderL.width
                foreground: Theme.surface1
                background: Theme.surface0
              }
              Border {
                anchors.right: parent.right
                foreground: Theme.surface0
                background: "transparent"
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
