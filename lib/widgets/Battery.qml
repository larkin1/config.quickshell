import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import Quickshell.Widgets
import "../.."

Item {
  id: root

  anchors.centerIn: parent
  implicitHeight: Theme.barHeight
  implicitWidth: visible ? content.implicitWidth + Theme.horizMargin: 0
  visible: battery ?? false

  property var battery

  property int pollCount: 0
  Timer {
    id: timer
    interval: 1000
    running: true
    repeat: true
    onTriggered: {
      root.getBatt()
      root.updateBattIcon()

      if (root.pollCount > 60) stop() // poll for a battery for a minute
      root.pollCount++
    }
  }

  Connections {
    target: root.battery ?? null
    function onStateChanged() { root.updateBattIcon() }
  }

  function getBatt() {
    let devices = UPower.devices.values;

    for (let i = 0; i <= devices.length; i++) {
      if (devices[i]?.isLaptopBattery) {
        root.battery = devices[i]
        timer.stop() // stop polling when the system acquires a battery
        return;
      }
    }
    root.battery = null
  }

  function battIcon() {
    if (!root.battery) return "../../svg/battery-empty.svg";

    let state = root.battery?.state
    let perc = root.battery?.percentage

    if (state === UPowerDeviceState.Charging) {
      return "../../svg/battery-charging.svg"
    }

    if (perc >= 0.75) {
      return "../../svg/battery-full.svg"
    }
    if (perc >= 0.50) {
      return "../../svg/battery-mid.svg"
    }
    if (perc >= 0.25) {
      return "../../svg/battery-low.svg"
    }
    return "../../svg/battery-empty.svg"
  }

  function updateBattIcon() { icon.source = Qt.resolvedUrl(root.battIcon()) }

  RowLayout {
    id: content
    anchors.centerIn: parent

    IconImage {
      id: icon
      implicitSize: Theme.iconSize
      mipmap: true
      source: Qt.resolvedUrl(root.battIcon())
    }

    StyledText {
      text:
        hover.hovered
        ? Math.round((root.battery?.state === UPowerDeviceState.Charging)? root.battery?.timeToFull / 60 : root.battery?.timeToEmpty / 60) + "m"
        : Math.round(root.battery?.percentage * 100) + "%"

      onTextChanged: {
        root.updateBattIcon()
      }
    }
  }

  HoverHandler {
    id: hover
  }

  Behavior on implicitWidth {
    NumberAnimation {
      duration: Theme.animationDuration
      easing: Theme.animationEasing
    }
  }
}
