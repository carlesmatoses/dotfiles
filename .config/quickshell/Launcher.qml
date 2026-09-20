import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick

// Replacement for `rofi -show drun`. Styling ports rofi/sk_theme.rasi; the
// key bindings port rofi/config.rasi.
//
// Full-screen transparent overlay holding a centred dialog, so a click
// anywhere outside the dialog dismisses it.
PanelWindow {
  id: root

  property string query: ""
  property int selected: 0

  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }

  // A full-screen panel must not reserve space, or it would push every
  // window off the screen while open.
  exclusionMode: ExclusionMode.Ignore

  WlrLayershell.layer: WlrLayer.Overlay            // above the bar
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
  WlrLayershell.namespace: "quickshell-launcher"   // for the blur layerrule

  color: "transparent"
  visible: LauncherState.open

  // Follow the focused monitor rather than always landing on the primary.
  screen: Monitors.focused

  readonly property var results: {
    const q = root.query;
    const scored = [];
    const apps = DesktopEntries.applications.values;
    for (let i = 0; i < apps.length; i++) {
      const app = apps[i];
      if (app.noDisplay) continue;
      const s = Fuzzy.score(q, app);
      if (s < 0) continue;
      scored.push({ entry: app, score: s });
    }
    scored.sort((a, b) => b.score - a.score
      || a.entry.name.localeCompare(b.entry.name));
    return scored.map(r => r.entry);
  }

  onVisibleChanged: {
    if (visible) {
      root.query = "";
      root.selected = 0;
      input.text = "";
      input.forceActiveFocus();
    }
  }

  // Selection must never point past the end of a shrinking result list.
  onResultsChanged: if (root.selected >= results.length) root.selected = 0

  // Matches `terminal: "kitty"` in rofi/config.rasi and $terminal in
  // hypr/hyprland.conf.
  readonly property string terminal: "kitty"

  function activate() {
    const list = root.results;
    if (root.selected < 0 || root.selected >= list.length) return;
    const entry = list[root.selected];
    LauncherState.hide();

    // execute() handles Exec field codes and Path=, but silently does
    // nothing for Terminal=true entries (btop, htop, nvim, vim, ...), so
    // those get spawned in a terminal here. entry.command is already an argv
    // list with the field codes stripped.
    if (entry.runInTerminal) {
      const argv = [root.terminal, "-e"].concat(entry.command);
      if (entry.workingDirectory)
        Quickshell.execDetached({ command: argv, workingDirectory: entry.workingDirectory });
      else
        Quickshell.execDetached(argv);
    } else {
      entry.execute();
    }
  }

  function move(delta) {
    const n = root.results.length;
    if (n === 0) return;
    root.selected = (root.selected + delta + n) % n;
    list.positionViewAtIndex(root.selected, ListView.Contain);
  }

  // Click-outside-to-dismiss.
  MouseArea {
    anchors.fill: parent
    onClicked: LauncherState.hide()
  }

  // Row geometry, also used to size the dialog. `element` is 40px tall with
  // `margin: 4px 0px` either side, hence 8px of spacing between rows.
  readonly property int rowHeight: 40
  readonly property int rowSpacing: 8
  readonly property int visibleRows: Math.max(1, Math.min(results.length, 12))
  readonly property int listHeight:
    visibleRows * rowHeight + (visibleRows - 1) * rowSpacing

  // `window { width: 700; border: 3px; border-radius: 8px; padding: 6px }`
  Rectangle {
    id: dialog
    anchors.centerIn: parent
    width: 700
    // Computed from the row count rather than list.contentHeight - the list
    // is anchored to this rectangle, so deriving the height from its content
    // would be a binding loop and collapse the dialog to nothing.
    //   6 window padding + inputbar + 8 gap + rows + (8 listview + 6 window)
    height: Math.min(parent.height - 80,
                     6 + inputBar.height + 8 + root.listHeight + 14)

    color: Qt.alpha(Theme.backgroundDark, Theme.panelAlpha)
    radius: 8
    border.width: 3
    border.color: Theme.accent

    // Swallow clicks so they do not reach the dismiss handler behind.
    MouseArea { anchors.fill: parent }

    // `inputbar { padding: 11px; border: 0 0 1px 0; border-color: @accent }`
    Item {
      id: inputBar
      anchors.top: parent.top
      anchors.topMargin: 6      // window padding
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.leftMargin: 6
      anchors.rightMargin: 6
      height: 48

      Text {
        id: prompt
        anchors.left: parent.left
        anchors.leftMargin: 11
        anchors.verticalCenter: parent.verticalCenter
        // `display-drun: " "` in config.rasi
        text: "\uf422"
        color: Theme.textColor1
        font.family: Theme.fontFamily
        font.pixelSize: 16
      }

      TextInput {
        id: input
        anchors.left: prompt.right
        anchors.leftMargin: 11   // prompt margin-right 5px + inputbar padding
        anchors.right: parent.right
        anchors.rightMargin: 11
        anchors.verticalCenter: parent.verticalCenter

        color: Theme.textColor1
        font.family: Theme.fontFamily
        font.pixelSize: 16
        selectByMouse: true
        focus: true

        onTextChanged: {
          root.query = text;
          root.selected = 0;
          list.positionViewAtBeginning();
        }

        // rofi/config.rasi kb-* bindings.
        Keys.onPressed: event => {
          const ctrl = (event.modifiers & Qt.ControlModifier) !== 0;

          if (event.key === Qt.Key_Escape) {
            LauncherState.hide();
          } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter
                     || (ctrl && (event.key === Qt.Key_Y || event.key === Qt.Key_Z))) {
            root.activate();
          } else if (event.key === Qt.Key_Down || (ctrl && event.key === Qt.Key_J)) {
            root.move(1);
          } else if (event.key === Qt.Key_Up || (ctrl && event.key === Qt.Key_K)) {
            root.move(-1);
          } else if (ctrl && event.key === Qt.Key_B) {
            input.cursorPosition = Math.max(0, input.cursorPosition - 1);
          } else if (ctrl && event.key === Qt.Key_F) {
            input.cursorPosition = Math.min(input.text.length, input.cursorPosition + 1);
          } else {
            return;   // let TextInput handle ordinary editing
          }
          event.accepted = true;
        }
      }

      Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: Theme.accent
      }
    }

    // `listview { padding: 8px; lines: 12; columns: 1 }`
    ListView {
      id: list
      anchors.top: inputBar.bottom
      anchors.topMargin: 8
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      anchors.leftMargin: 8 + 6
      anchors.rightMargin: 8 + 6
      anchors.bottomMargin: 8 + 6

      clip: true
      spacing: root.rowSpacing   // `element { margin: 4px 0px }` top + bottom
      model: root.results
      currentIndex: root.selected

      delegate: LauncherRow {
        required property var modelData
        required property int index

        width: list.width
        entry: modelData
        selected: index === root.selected
        onActivated: {
          root.selected = index;
          root.activate();
        }
      }
    }

    Text {
      anchors.centerIn: list
      visible: root.results.length === 0
      text: "No matches"
      color: Theme.textColor3
      font.family: Theme.fontFamily
      font.pixelSize: 16
    }
  }
}
