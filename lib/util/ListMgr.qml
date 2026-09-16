import QtQuick

QtObject {
  required property var list
  property var currentItem: null
  readonly property int currentIdx: list ? list.findIndex(d => d === currentItem) : -1
  property int lastKnownIdx: 0

  signal moved

  onCurrentIdxChanged: if (currentIdx !== -1) lastKnownIdx = currentIdx
  onListChanged: if (currentIdx === -1 && list?.length > 0) currentItem = list[Math.min(lastKnownIdx, list.length - 1)]
  onCurrentItemChanged: moved()

  function moveUp() {
    if (!list?.length) return;
    if (currentIdx === -1) { jumpFirst(); return; }
    if (currentIdx === 0) { jumpLast(); return }
    currentItem = list[currentIdx - 1]
  }

  function moveDn() {
    if (!list?.length) return;
    if (currentIdx === list.length - 1 || currentIdx === -1) { jumpFirst(); return }
    currentItem = list[currentIdx + 1]
  }

  function jumpFirst() {
    if (list?.length > 0) {
      currentItem = list[0]
      return
    }
    currentItem = null
  }

  function jumpLast() {
    if (list?.length > 0) {
      currentItem = list[list.length - 1]
      return
    }
    currentItem = null
  }

}
