pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pam
import Quickshell.Wayland
import Quickshell.Io
import "../.."

Scope {
  id: root

  function lock() {
    pam.start()
    lock.locked = true
    password = ""
  }
  function unlock() {
    lock.locked = false
  }
  function submit(pw) {
    if (!pam.active) {
      pam.start()
    }
    authFailed = false
    pam.respond(pw)
  }

  property string password: ""
  property bool authFailed: false
  property bool authenticating: false

  WlSessionLock {
    id: lock
    locked: false

    WlSessionLockSurface {
      color: Theme.crust

      Rectangle {
        id: inputs

        color: "transparent"
        implicitHeight: 100
        implicitWidth: 200

        anchors.centerIn: parent

        PasswordField {
          anchors.centerIn: parent
          id: passwordField
          text: LockScreen.password
          onTextEdited: {LockScreen.password = text}
          error: LockScreen.authFailed
          authenticating: LockScreen.authenticating

          onAccepted: {
            LockScreen.authenticating = true
            LockScreen.submit(text)
          }

          Timer {
            interval: 50
            running: true
            onTriggered: passwordField.forceActiveFocus()
          }
        }
      }
    }
  }

  PamContext {
    id: pam
    config: "login"
    onCompleted: result => {
      if (result === PamResult.Success) {
        root.unlock()
        root.authenticating = false
      } else {
        pam.start()
        root.password = ""
        root.authFailed = true
        root.authenticating = false
      }
    }
  }

  IpcHandler {
    target: "lockScreen"
    function lock(): void {
      root.lock()
    }
  }
}
