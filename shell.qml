import Quickshell
import QtQuick
import QtQuick.Layouts

PanelWindow {
  id: root

  property int innerMarginLR: 10
  property int outerMarginU: 10
  property int barheight: 26
  
  anchors {
    top: true
    left: true
    right: true
  }

  color: "transparent"
  
  implicitHeight: barheight + outerMarginU

  LeftGroup {
    id: leftGroup
    innerMarginLR: root.innerMarginLR
    outerMarginU: root.outerMarginU
    barheight: root.barheight
    bar: root
  }

  Item { Layout.fillWidth: true }

  MiddleGroup {
    id: middleGroup
    innerMarginLR: root.innerMarginLR
    outerMarginU: root.outerMarginU
    barheight: root.barheight
  }

  Item { Layout.fillWidth: true }

  RightGroup {
    id: rightGroup
    innerMarginLR: root.innerMarginLR
    outerMarginU: root.outerMarginU
    barheight: root.barheight
    mainWindow: root
  }

}
