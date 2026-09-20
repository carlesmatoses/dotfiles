import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

// Replaces `rofi -modi emoji -show emoji` (Super+,).
//
// The dataset is emoji.txt, vendored from rofi-emoji's
// /usr/share/rofi-emoji/all_emojis.txt so the dotfiles no longer depend on
// that package. Tab-separated: emoji, group, subgroup, name, keywords.
//
// Selecting an emoji copies it with wl-copy, which is what rofi-emoji does.
PanelWindow {
  id: root

  property string query: ""
  property int selected: 0
  property var entries: []

  screen: Monitors.focused

  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }

  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
  WlrLayershell.namespace: "quickshell-emoji"

  color: Qt.rgba(0, 0, 0, 0.5)
  visible: EmojiState.open

  FileView {
    path: Quickshell.shellDir + "/emoji.txt"
    onLoaded: root.parse(text())
  }

  function parse(raw) {
    const out = [];
    const lines = raw.split("\n");
    for (let i = 0; i < lines.length; i++) {
      const f = lines[i].split("\t");
      if (f.length < 5) continue;
      out.push({
        emoji: f[0],
        group: f[1],
        name: f[3],
        // Fuzzy.score() reads .name, .genericName, .keywords and .comment,
        // so shape the row to match and the existing scorer works unchanged.
        genericName: f[2].replace(/-/g, " "),
        keywords: f[4].replace(/ \| /g, " "),
        comment: f[1]
      });
    }
    root.entries = out;
  }

  readonly property var results: {
    const q = root.query.trim();
    const all = root.entries;
    if (q === "") return all.slice(0, 500);   // cap the idle list; 5042 rows
                                              // of delegates is pointless
    const scored = [];
    for (let i = 0; i < all.length; i++) {
      const s = Fuzzy.score(q, all[i]);
      if (s < 0) continue;
      scored.push({ e: all[i], s: s });
    }
    scored.sort((a, b) => b.s - a.s || a.e.name.localeCompare(b.e.name));
    return scored.slice(0, 500).map(r => r.e);
  }

  readonly property var current:
    selected >= 0 && selected < results.length ? results[selected] : null

  onVisibleChanged: {
    if (visible) {
      root.query = "";
      root.selected = 0;
      input.text = "";
      input.forceActiveFocus();
    }
  }

  onResultsChanged: if (root.selected >= results.length) root.selected = 0

  function copy() {
    if (!current) return;
    const emoji = current.emoji;
    EmojiState.hide();
    // Through argv, so nothing in the emoji can be reinterpreted by the shell.
    Quickshell.execDetached(["sh", "-c", 'printf %s "$1" | wl-copy', "sh", emoji]);
  }

  function move(delta) {
    const n = root.results.length;
    if (n === 0) return;
    root.selected = Math.max(0, Math.min(n - 1, root.selected + delta));
    grid.positionViewAtIndex(root.selected, GridView.Contain);
  }

  MouseArea {
    anchors.fill: parent
    onClicked: EmojiState.hide()
  }

  Rectangle {
    id: dialog
    anchors.centerIn: parent
    width: 700
    height: Math.min(parent.height - 120, 520)

    color: Theme.backgroundDark
    radius: 8
    border.width: 3
    border.color: Theme.accent

    MouseArea { anchors.fill: parent }

    Item {
      id: header
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.margins: 6
      height: 48

      Text {
        id: prompt
        anchors.left: parent.left
        anchors.leftMargin: 11
        anchors.verticalCenter: parent.verticalCenter
        text: "\uf118"   // nf-fa-smile_o
        color: Theme.textColor1
        font.family: Theme.fontFamily
        font.pixelSize: 16
      }

      TextInput {
        id: input
        anchors.left: prompt.right
        anchors.leftMargin: 11
        anchors.right: label.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        color: Theme.textColor1
        font.family: Theme.fontFamily
        font.pixelSize: 16
        selectByMouse: true
        focus: true

        onTextChanged: {
          root.query = text;
          root.selected = 0;
          grid.positionViewAtBeginning();
        }

        Keys.onPressed: event => {
          if (event.key === Qt.Key_Escape) {
            EmojiState.hide();
          } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            root.copy();
          } else if (event.key === Qt.Key_Right) {
            root.move(1);
          } else if (event.key === Qt.Key_Left) {
            root.move(-1);
          } else if (event.key === Qt.Key_Down) {
            root.move(grid.columns);
          } else if (event.key === Qt.Key_Up) {
            root.move(-grid.columns);
          } else {
            return;
          }
          event.accepted = true;
        }
      }

      Text {
        id: label
        anchors.right: parent.right
        anchors.rightMargin: 11
        anchors.verticalCenter: parent.verticalCenter
        width: 240
        horizontalAlignment: Text.AlignRight
        text: root.current ? root.current.name : ""
        color: Theme.textColor3
        font.family: Theme.fontFamily
        font.pixelSize: 11
        elide: Text.ElideLeft
      }

      Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: Theme.accent
      }
    }

    GridView {
      id: grid
      anchors.top: header.bottom
      anchors.topMargin: 8
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      anchors.margins: 14

      readonly property int columns: Math.max(1, Math.floor(width / 56))

      clip: true
      cellWidth: Math.floor(width / columns)
      cellHeight: 56
      model: root.results

      delegate: Item {
        id: cell
        required property var modelData
        required property int index

        width: grid.cellWidth
        height: grid.cellHeight

        Rectangle {
          anchors.fill: parent
          anchors.margins: 3
          radius: 6
          color: cell.index === root.selected ? Theme.accent : "transparent"

          Text {
            anchors.centerIn: parent
            text: cell.modelData.emoji
            font.pixelSize: 26
          }
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            root.selected = cell.index;
            root.copy();
          }
        }
      }
    }

    Text {
      anchors.centerIn: grid
      visible: root.results.length === 0
      text: root.entries.length === 0 ? "emoji.txt not loaded" : "No matches"
      color: Theme.textColor3
      font.family: Theme.fontFamily
      font.pixelSize: 14
    }
  }
}
