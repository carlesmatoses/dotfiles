import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

// Replaces .config/hypr/scripts/keybindings.sh (Super+. and the Apps pill
// right-click), which piped an awk-formatted list into `rofi -dmenu`.
//
// Same source and the same transformation: read keybindings.conf, keep the
// `bind*` lines, show $mainMod as SUPER, split into keys and action. The
// script's \r-joined two-line rofi rows become proper columns here.
PanelWindow {
  id: root

  readonly property string configPath:
    "/home/carles/.config/hypr/configs/keybindings.conf"

  property string query: ""
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
  WlrLayershell.namespace: "quickshell-keybinds"

  color: Qt.rgba(0, 0, 0, 0.5)
  visible: KeybindsState.open

  FileView {
    id: file
    path: root.configPath
    watchChanges: true
    onFileChanged: reload()
    onLoaded: root.parse(text())
  }

  function parse(raw) {
    const out = [];
    const lines = raw.split("\n");

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i].trim();
      // bind, bindm, bindel, bindl ... all start with "bind".
      if (line.indexOf("bind") !== 0) continue;

      const eq = line.indexOf("=");
      if (eq < 0) continue;

      // Strip an inline trailing comment, as the script's -F'[=#]' did.
      let body = line.slice(eq + 1);
      const hash = body.indexOf("#");
      if (hash >= 0) body = body.slice(0, hash);

      body = body.replace(/\$mainMod/g, "SUPER").trim();

      // "MODS, KEY, dispatcher, args"
      const parts = body.split(",");
      if (parts.length < 2) continue;

      const mods = parts[0].trim();
      const key = parts[1].trim();
      const action = parts.slice(2).join(",").trim();

      out.push({
        keys: mods === "" ? key : mods + " + " + key,
        action: action
      });
    }
    root.entries = out;
  }

  readonly property var results: {
    const q = root.query.trim().toLowerCase();
    if (q === "") return root.entries;
    const out = [];
    for (let i = 0; i < root.entries.length; i++) {
      const e = root.entries[i];
      if (e.keys.toLowerCase().indexOf(q) >= 0
          || e.action.toLowerCase().indexOf(q) >= 0)
        out.push(e);
    }
    return out;
  }

  onVisibleChanged: {
    if (visible) {
      root.query = "";
      input.text = "";
      file.reload();
      input.forceActiveFocus();
    }
  }

  MouseArea {
    anchors.fill: parent
    onClicked: KeybindsState.hide()
  }

  Rectangle {
    id: dialog
    anchors.centerIn: parent
    width: 820
    height: Math.min(parent.height - 120, 620)

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
        text: "\uf11c"   // nf-fa-keyboard_o
        color: Theme.textColor1
        font.family: Theme.fontFamily
        font.pixelSize: 16
      }

      TextInput {
        id: input
        anchors.left: prompt.right
        anchors.leftMargin: 11
        anchors.right: count.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        color: Theme.textColor1
        font.family: Theme.fontFamily
        font.pixelSize: 16
        selectByMouse: true
        focus: true

        onTextChanged: {
          root.query = text;
          list.positionViewAtBeginning();
        }

        Keys.onPressed: event => {
          if (event.key === Qt.Key_Escape) {
            KeybindsState.hide();
          } else if (event.key === Qt.Key_Down) {
            list.contentY = Math.min(
              Math.max(0, list.contentHeight - list.height), list.contentY + 28);
          } else if (event.key === Qt.Key_Up) {
            list.contentY = Math.max(0, list.contentY - 28);
          } else if (event.key === Qt.Key_PageDown) {
            list.contentY = Math.min(
              Math.max(0, list.contentHeight - list.height),
              list.contentY + list.height);
          } else if (event.key === Qt.Key_PageUp) {
            list.contentY = Math.max(0, list.contentY - list.height);
          } else {
            return;
          }
          event.accepted = true;
        }
      }

      Text {
        id: count
        anchors.right: parent.right
        anchors.rightMargin: 11
        anchors.verticalCenter: parent.verticalCenter
        text: root.results.length + " binds"
        color: Theme.textColor3
        font.family: Theme.fontFamily
        font.pixelSize: 11
      }

      Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: Theme.accent
      }
    }

    ListView {
      id: list
      anchors.top: header.bottom
      anchors.topMargin: 8
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      anchors.margins: 14

      clip: true
      spacing: 2
      model: root.results

      delegate: Rectangle {
        required property var modelData
        required property int index

        width: list.width
        height: 26
        radius: 4
        // Zebra striping keeps two dense columns readable.
        color: index % 2 === 0 ? "transparent" : Qt.rgba(1, 1, 1, 0.03)

        Text {
          anchors.left: parent.left
          anchors.leftMargin: 10
          anchors.verticalCenter: parent.verticalCenter
          width: 240
          text: parent.modelData.keys
          color: Theme.accent
          font.family: Theme.fontFamily
          font.pixelSize: 13
          font.bold: true
          elide: Text.ElideRight
        }

        Text {
          anchors.left: parent.left
          anchors.leftMargin: 260
          anchors.right: parent.right
          anchors.rightMargin: 10
          anchors.verticalCenter: parent.verticalCenter
          text: parent.modelData.action
          color: Theme.textColor2
          font.family: Theme.fontFamily
          font.pixelSize: 13
          elide: Text.ElideRight
        }
      }
    }

    Text {
      anchors.centerIn: list
      visible: root.results.length === 0
      text: root.entries.length === 0 ? "Could not read keybindings.conf" : "No matches"
      color: Theme.textColor3
      font.family: Theme.fontFamily
      font.pixelSize: 14
    }
  }
}
