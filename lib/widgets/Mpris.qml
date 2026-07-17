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

  property MprisPlayer activePlayer: {
    let players = Mpris.players;
    for (let i = 0; i < players.count; i++) {
      let p = players.objectAt(i);
      if (p.playbackState == MprisPlaybackState.Playing) {
        return p;
      }
    }
    return null;
  }



  Rectangle {
    anchors.fill: parent
    color: root.bgColor
  }

  Row {
    id: mediaWidget
    height: root.barheight

    // Repeater {
    //   model: Mpris.players

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
          text: modelData.trackTitle
        }

        // Text {
        //   id: mediaText
        //   anchors.verticalCenter: parent.verticalCenter
        //   font.family: Theme.font
        //   font.weight: Theme.fontWeight
        //   font.pixelSize: Theme.fontSize
        //   color: root.textColor
        //   text: {
        //     let players = Mpris.players;
        //     let s = "Count: " + players.count + " | ";
        //     for (let i = 0; i < players.count; i++) {
        //       let p = players.objectAt(i);
        //       s += "[" + p.identity + "st=" + p.playbackState + "title=" + p.trackTitle + "] ";
        //     }
        //     if (players.count === 0) s += "(none)";
        //     return s;
        //   }
        // }

        // Text {
        //   id: mediaText
        //   anchors.verticalCenter: parent.verticalCenter
        //   font.family: Theme.font
        //   font.weight: Theme.fontWeight
        //   font.pixelSize: Theme.fontSize
        //   color: root.textColor
        //   text: root.activePlayer.identity || "Unknow Title"
        // }

        MouseArea {
          visible: root.activePlayer.canTogglePlaying
          anchors.fill: parent
          onClicked: root.activePlayer.togglePlaying()
        }

        HoverHandler {
          id: workspaceHover
        }
      }
    // }
  }
}
