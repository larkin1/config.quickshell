import QtQuick
import Quickshell.Services.Mpris
import "../.."

Item {
  id: root

  required property int   barheight
  required property color textColor
  required property color bgColor
  required property color activeBGColor

  anchors.verticalCenter: parent.verticalCenter
  height: barheight
  implicitWidth: mediaWidget.implicitWidth

  property var currentPlayer: null
  property var playingList: null

  property var playerIcon: {
    switch (currentPlayer.identity) {
      case "Mozilla firefox":
        return "󰈹";
      case "Helium":
        return "";
      case "Spotify":
        return "";
      default:
        return "";
    }
  }

  Component.onCompleted: updateCurrentPlayer()

  Connections {
    target: Mpris.players // qmllint disable missing-property
    function onRowsInserted() { root.updateCurrentPlayer() }
    function onRowsRemoved()  { root.updateCurrentPlayer() }
    function onModelReset()   { root.updateCurrentPlayer() }
    function onDataChanged()  { root.updateCurrentPlayer() } // doesn't work for some reason, hence the timer below
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: root.updateCurrentPlayer()
  }

  function updateCurrentPlayer() {
    let players = Mpris.players.values; // qmllint disable missing-property

    // keep a list of any players that are active globally
    let newPlayingList = players.filter( u => u.playbackState == MprisPlaybackState.Playing );

    // if currentPlayer is null, and there is a player in the list, set that player as the current player.
    if ( !root.currentPlayer && players.length > 0 ) {
      root.currentPlayer = players[0];
    }

    // if the currentPlayer pauses, drop back to a player that is playing
    if (root.currentPlayer.playbackState != MprisPlaybackState.Playing && newPlayingList.length > 0) {
      root.currentPlayer = newPlayingList[0];
    }

    // if a player came active recently (wasn't on the global list and is now), set currentPlayer to that player
    if (newPlayingList.length > 0) {
      for ( let i = 0; i < newPlayingList.length; i++ ) {
        if ( !root.playingList.includes(newPlayingList[i]) ) {
          root.currentPlayer = newPlayingList[i];
        }
      }
    }

    root.playingList = newPlayingList;
  }

  visible: currentPlayer !== null

  Rectangle {
    anchors.fill: parent
    color: root.bgColor
  }

  Row {
    id: mediaWidget
    height: root.barheight

    Rectangle {
      color: "transparent"
      implicitWidth: mediaText.implicitWidth
      height: root.barheight

      Text {
        id: mediaText
        anchors.verticalCenter: parent.verticalCenter
        font.family: Theme.font
        font.weight: Theme.fontWeight
        font.pixelSize: Theme.fontSize
        color: root.textColor
        text: (
          root.playerIcon + " "
          + (root.currentPlayer.playbackState == MprisPlaybackState.Playing ? " " : " ")
          + root.currentPlayer.trackTitle
          + (root.currentPlayer.trackArtist == "" ? "" : " - " + root.currentPlayer.trackArtist)
        ) || "Unknown Title"
      }

      MouseArea {
        visible: root.currentPlayer.canTogglePlaying
        anchors.fill: parent
        onClicked: {
          root.currentPlayer.togglePlaying()
          root.updateCurrentPlayer()
        }
        cursorShape: root.currentPlayer.canTogglePlaying ? Qt.PointingHandCursor : Qt.ArrowCursor
        onWheel: (wheel) => {
          if (wheel.angleDelta.y < 0) {
            root.currentPlayer.next()
          }
          if (wheel.angleDelta.y > 0) {
            root.currentPlayer.previous()
          }
          wheel.accepted = true;
          root.updateCurrentPlayer()
        }
      }

      HoverHandler {
        id: workspaceHover
      }
    }
  }
}
