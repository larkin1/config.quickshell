pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root
  // Fonts
  readonly property string font: "JetBrainsMonoNL Nerd Font"
  readonly property int fontSize: 14
  readonly property int fontWeight: 650

  // Dimensions
  readonly property int horizMargin: 10
  readonly property int vertMargin: 10
  readonly property int barHeight: 26
  readonly property int iconSize: 18

  // Animations
  readonly property int animationDuration: 200
  readonly property int collapseTimeout: 2500
  readonly property int colorAnimationDuration: 200
  readonly property var animationEasing: Easing.OutQuad
}
