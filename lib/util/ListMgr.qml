import QtQuick
import Quickshell

QtObject {
  id: root
  required property var list
  property string search: ""
  property var searchKey: null

  readonly property var filtered: (!search || !searchKey || !list) ? list : list.map(d => ({
        d,
        score: fuzzyScore(search, searchKey(d) ?? "")
      })).filter(x => x.score >= 0).sort((a, b) => b.score - a.score).map(x => x.d)

  readonly property ScriptModel model: ScriptModel {
    values: root.filtered ?? []
  }

  property var currentItem: null
  readonly property int currentIdx: filtered ? filtered.findIndex(d => d === currentItem) : -1
  property int lastKnownIdx: 0

  signal moved

  onCurrentIdxChanged: if (currentIdx !== -1)
    lastKnownIdx = currentIdx
  onListChanged: Qt.callLater(rescue)
  onSearchChanged: Qt.callLater(rescue)
  onCurrentItemChanged: moved()

  function rescue() {
    if (currentIdx === -1 && filtered?.length > 0)
      currentItem = filtered[Math.min(lastKnownIdx, filtered.length - 1)];
  }

  function fuzzyScore(needle, hay) {
    const n = needle.toLowerCase(), h = (hay ?? "").toLowerCase();
    if (!n)
      return 0;
    let hi = 0, streak = 0, score = 0;
    for (let i = 0; i < n.length; i++) {
      const idx = h.indexOf(n[i], hi);
      if (idx === -1)
        return -1;
      if (idx === hi && i > 0) {
        streak++;
        score += 10 + 4 * streak;
      } else {
        streak = 0;
        if (i > 0)
          score -= Math.min(idx - hi, 8);
        score += idx === 0 ? 14 : (h[idx - 1] === " " || h[idx - 1] === "-" ? 10 : 1);
      }
      hi = idx + 1;
    }
    return score - (h.length - n.length) * 0.05;
  }

  function moveUp() {
    if (!filtered?.length)
      return;
    if (currentIdx === -1) {
      jumpFirst();
      return;
    }
    if (currentIdx === 0) {
      jumpLast();
      return;
    }
    currentItem = filtered[currentIdx - 1];
  }

  function moveDn() {
    if (!filtered?.length)
      return;
    if (currentIdx === filtered.length - 1 || currentIdx === -1) {
      jumpFirst();
      return;
    }
    currentItem = filtered[currentIdx + 1];
  }

  function jumpFirst() {
    if (filtered?.length > 0) {
      currentItem = filtered[0];
      return;
    }
    currentItem = null;
  }

  function jumpLast() {
    if (filtered?.length > 0) {
      currentItem = filtered[filtered.length - 1];
      return;
    }
    currentItem = null;
  }
}
