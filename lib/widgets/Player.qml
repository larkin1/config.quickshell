import QtQuick
import "../.."

Item {
  id: root

  required property color textColor
  required property color bgColor
  required property color activeBGColor
  required property color activeProgressbarColor
  required property color progressbarColor

  anchors.verticalCenter: parent.verticalCenter
  height: Theme.barHeight
  implicitWidth: mediaWidget.implicitWidth
  visible: Media.currentPlayer != null

  Rectangle {
    anchors.fill: parent
    color: root.bgColor
  }

  Rectangle {
    id: progress
    visible: Media.currentPlayer?.positionSupported ? true : false // the ? : avoids warnings about "unable to assign [undefined] to bool"
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    radius: implicitHeight/2
    implicitHeight: parent.height * 0.15
    implicitWidth: (parent.width-implicitHeight)*(Media.currentPlayer?.position/Media.currentPlayer?.length)+implicitHeight
    color: Media.isPlaying ? root.activeProgressbarColor : root.progressbarColor

    Behavior on implicitWidth {
      NumberAnimation {
        duration: Math.min(300, progSync.interval)
        easing.type: Theme.animationEasing
      }
    }

    Timer {
      id: progSync
      running: Media.isPlaying && Media.currentPlayer?.positionSupported
      interval: Math.max(30, (Media.currentPlayer?.length*1000)/root.width) // update the progress every pixel or at ~30fps
      repeat: true
      triggeredOnStart: true
      onTriggered: Media.currentPlayer?.positionChanged()
    }
  }

  Rectangle {
    id: mediaWidget
    color: "transparent"
    implicitWidth: mediaText.implicitWidth
    height: Theme.barHeight

    StyledText {
      id: mediaText
      anchors.verticalCenter: parent.verticalCenter
      width: parent.width
      elide: Text.ElideRight
      wrapMode: Text.NoWrap
      textFormat: Text.StyledText
      text: {
        const player = Media.currentPlayer;
        if (!player || !player.trackTitle) return "";

        let result = "";

        const icon = Media.playerIcon
        if (icon && icon.icon && icon.color) {
          result += "<font color='" + icon.color + "'>" + icon.icon + "</font> ";
        }

        result += (Media.isPlaying ? " " : " ")
        result += Media.currentPlayer.trackTitle;

        if (player.trackArtist) {
          result += " - " + player.trackArtist;
        }

        return result;
      }
    }

    MouseArea {
      visible: Media.currentPlayer?.canTogglePlaying ?? false
      anchors.fill: parent
      onClicked: {
        Media.currentPlayer.togglePlaying()
      }
      cursorShape: Media.currentPlayer?.canTogglePlaying ? Qt.PointingHandCursor : Qt.ArrowCursor
      onWheel: (wheel) => {
        if (wheel.angleDelta.y < 0) {
          Media.currentPlayer.next()
        }
        if (wheel.angleDelta.y > 0) {
          Media.currentPlayer.previous()
        }
        wheel.accepted = true;
      }
    }

    HoverHandler {
      id: workspaceHover
    }
  }
}
