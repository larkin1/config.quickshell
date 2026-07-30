pragma Singleton
import QtQuick

QtObject {
  id: root
  // Base
  readonly property color crust:    "#11111b"
  readonly property color mantle:   "#181825"
  readonly property color base:     "#1e1e2e"
  readonly property color surface0: "#313244"
  readonly property color surface1: "#45475a"
  readonly property color surface2: "#585b70"
  readonly property color overlay0: "#6c7086"
  readonly property color overlay1: "#7f849c"
  readonly property color overlay2: "#9399b2"
  readonly property color subtext0: "#a6adc8"
  readonly property color subtext1: "#bac2de"
  readonly property color text:     "#cdd6f4"

  // Accent
  readonly property color rosewater: "#f5e0dc"
  readonly property color flamingo:  "#f2cdcd"
  readonly property color pink:      "#f5c2e7"
  readonly property color mauve:     "#cba6f7"
  readonly property color red:       "#f38ba8"
  readonly property color maroon:    "#eba0ac"
  readonly property color peach:     "#fab387"
  readonly property color yellow:    "#f9e2af"
  readonly property color green:     "#a6e3a1"
  readonly property color teal:      "#94e2d5"
  readonly property color sky:       "#89dceb"
  readonly property color sapphire:  "#74c7ec"
  readonly property color blue:      "#89b4fa"
  readonly property color lavender:  "#b4befe"

  readonly property color backgroundBlur: Qt.alpha(mantle, 0.7)

  property color cyclingColor: mauve
  SequentialAnimation on cyclingColor {
    id: colorCycleAnim
    loops: Animation.Infinite
    running: true

    property int dur: 4000

    ColorAnimation { from: root.mauve;     to: root.lavender;  duration: colorCycleAnim.dur }
    ColorAnimation { from: root.lavender;  to: root.blue;      duration: colorCycleAnim.dur }
    ColorAnimation { from: root.blue;      to: root.sapphire;  duration: colorCycleAnim.dur }
    ColorAnimation { from: root.sapphire;  to: root.teal;      duration: colorCycleAnim.dur }
    ColorAnimation { from: root.teal;      to: root.green;     duration: colorCycleAnim.dur }
    ColorAnimation { from: root.green;     to: root.yellow;    duration: colorCycleAnim.dur }
    ColorAnimation { from: root.yellow;    to: root.peach;     duration: colorCycleAnim.dur }
    ColorAnimation { from: root.peach;     to: root.red;       duration: colorCycleAnim.dur }
    ColorAnimation { from: root.red;       to: root.maroon;    duration: colorCycleAnim.dur }
    ColorAnimation { from: root.maroon;    to: root.pink;      duration: colorCycleAnim.dur }
    ColorAnimation { from: root.pink;      to: root.mauve;     duration: colorCycleAnim.dur }
  }

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
  readonly property var animationEasing: Easing.InOutQuad
}
