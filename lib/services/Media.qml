pragma Singleton

import QtQuick
import Quickshell.Services.Mpris
import "../.."

QtObject {
  readonly property bool isPlaying: currentPlayer?.playbackState === MprisPlaybackState.Playing
  readonly property var playerList: Mpris.players.values.filter(p => !p.dbusName.includes("playerctld"))
  readonly property var playingPlayers: playerList.filter(p => p.playbackState === MprisPlaybackState.Playing)
  property var currentPlayer
  property var prevPlayers: []
  property var playerIcon: {
    switch (currentPlayer?.identity) {
      case "Mozilla firefox":
        return { icon:"󰈹", color: Theme.peach };
      case "Helium":
        return { icon:"", color: Theme.sky };
      case "Spotify":
        return { icon:"", color: Theme.green };
      default:
        return { icon:"", color: Theme.sky };
    }
  }

  Component.onCompleted: selectPlayer(playingPlayers)
  onPlayingPlayersChanged: selectPlayer(playingPlayers)
  onPlayerListChanged: selectPlayer(playingPlayers)

  function selectPlayer(now) {
    const started = now.find(p => !prevPlayers.includes(p))
    prevPlayers = now
    if (started) { currentPlayer = started; return; }
    if (currentPlayer && playerList.includes(currentPlayer)) {
      if (currentPlayer.playbackState === MprisPlaybackState.Playing || now.length === 0) {
        return
      }
    }
    currentPlayer = now[0] ?? playerList[0] ?? null
  }
}
