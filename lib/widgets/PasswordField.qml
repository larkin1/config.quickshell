import QtQuick
import QtQuick.Layouts
import "../.."

Item {
  id: root

  property alias text: input.text
  property alias inputFocus: input.activeFocus
  property bool error: false
  property string placeholder: error ? "Please try again." : "Password"
  property bool authenticating: false

  signal accepted(string text)
  signal textEdited(string text)

  implicitWidth: 500
  implicitHeight: 150

  activeFocusOnTab: true

  function forceActiveFocus() { input.forceActiveFocus() }
  function clear() { input.text = "" }

  RowLayout {
    spacing: 0
    anchors.centerIn: parent
    clip: true

    Border {
      foreground: Theme.mantle
      background: "transparent"
      itemHeight: root.height
      reversed: true
    }

    Border {
      foreground: Theme.base
      background: Theme.mantle
      itemHeight: root.height
      reversed: true
    }

    Border {
      foreground: Theme.surface0
      background: Theme.base
      itemHeight: root.height
      reversed: true
    }

    Rectangle {
      implicitHeight: root.height
      implicitWidth: root.width
      clip: true

      Rectangle {
        anchors.fill: parent
        // radius: height * 0.25
        color: Theme.surface0
        // border.width: 1
        // border.color: root.error ? Theme.red : (input.activeFocus ? Theme.lavender : Theme.surface1) 

        Behavior on border.color {
          ColorAnimation {
            duration: Theme.colorAnimationDuration
          }
        }
      }

      TextInput {
        id: input
        anchors.fill: parent
        anchors.margins: Theme.horizMargin
        opacity: 0
        focus: true
        color: Theme.text
        font.family: Theme.font
        font.pixelSize: Theme.fontSize
        font.weight: Theme.fontWeight
        echoMode: TextInput.Password
        passwordCharacter: "*"
        clip: true
        selectByMouse: false

        onTextEdited: root.textEdited(text)

        onAccepted: {
          root.accepted(text)
        }
      }

      StyledText {
        anchors.centerIn: parent
        text: root.authenticating ? "Authenticating..." : (input.text.length === 0 ? root.placeholder : "*".repeat(input.text.length))
        font.pixelSize: root.height * 0.3
        // color: input.text.length === 0 ? Theme.overlay0 : Theme.text
        color: (input.text.length === 0 ? (root.error ? Theme.red : Theme.overlay0) : Theme.text)
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.IBeamCursor
        onClicked: input.forceActiveFocus()
      }
    }

    Border {
      foreground: Theme.surface0
      background: Theme.base
      itemHeight: root.height
    }

    Border {
      foreground: Theme.base
      background: Theme.mantle
      itemHeight: root.height
    }

    Border {
      foreground: Theme.mantle
      background: "transparent"
      itemHeight: root.height
    }
  }
}
