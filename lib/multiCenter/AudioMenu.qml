import QtQuick
import "../.."

Item {
  id: root
  anchors.fill: parent

  property int currentZone: 0
  readonly property int defaultZone: 0

  property int menuState: 0
  readonly property int noState: 0

  onVisibleChanged: {
    if (visible) {
      currentZone = defaultZone
      root.forceActiveFocus()
    }
  }

  // -- Keyboard Shortcuts --
  
  // event handlers
  onCurrentZoneChanged: {
    menuState = noState
  }

  // shortcuts used between all focus zones
  function handleCommonKeys(event) {
    switch (event.key) {

      case Qt.Key_Escape:
        if (menuState !== noState) {
          menuState = noState
          event.accepted = true;
        }
        break;
    }
  }

  Keys.onPressed: event => {
    handleCommonKeys(event);
  }

  Rectangle {
    implicitWidth: parent.width - (Theme.horizMargin*2)
    implicitHeight: parent.height - (Theme.vertMargin*2)
    anchors.centerIn: parent
    color: "blue"
  }
}
