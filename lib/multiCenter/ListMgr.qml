import QtQuick

QtObject {
  required property var list
  property var currentItem: null
  readonly property int currentIdx: list ? list.findIndex(d => d === currentItem) : -1
  property int lastKnownIdx: 0

  signal moved

  onCurrentIdxChanged: if (currentIdx !== -1) lastKnownIdx = currentIdx
  onListChanged: if (currentIdx === -1 && list?.length > 1) currentItem = list[Math.min(lastKnownIdx, list.length - 1)]

  function moveUp() {
    if (currentIdx === -1) {
      currentItem = list[0]; return
    }
    if (currentIdx === 0) {
      currentItem = list[list.length -1]; return
    }
    currentItem = list[currentIdx - 1]
    moved()
  }

  function moveDn() {
    if (currentIdx === list.length - 1 || currentIdx === -1) {
      currentItem = list[0]; return
    }
    currentItem = list[currentIdx + 1]
    moved()
  }
}
