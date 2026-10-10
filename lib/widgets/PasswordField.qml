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
      foreground: Colors.md3.surface_container_lowest
      background: "transparent"
      reversed: true
    }

    Border {
      foreground: Colors.md3.surface_container
      background: Colors.md3.surface_container_lowest
      reversed: true
    }

    Border {
      foreground: Colors.md3.surface_container_highest
      background: Colors.md3.surface_container
      reversed: true
    }

    Rectangle {
      implicitHeight: root.height
      implicitWidth: root.width
      clip: true

      Rectangle {
        anchors.fill: parent
        color: Colors.md3.surface_container_highest

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
        color: Colors.md3.on_surface
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
        color: (input.text.length === 0 ? (root.error ? Colors.md3.error : Qt.alpha(Colors.md3.on_surface, 0.38)) : Colors.md3.on_surface)
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.IBeamCursor
        onClicked: input.forceActiveFocus()
      }
    }

    Border {
      foreground: Colors.md3.surface_container_highest
      background: Colors.md3.surface_container
    }

    Border {
      foreground: Colors.md3.surface_container
      background: Colors.md3.surface_container_lowest
    }

    Border {
      foreground: Colors.md3.surface_container_lowest
      background: "transparent"
    }
  }
}
