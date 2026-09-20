import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Qt.labs.folderlistmodel
import QtQuick

// Replacement for .config/hypr/scripts/wallpaper-picker.sh.
//
// Keeps that script's contract exactly:
//   Enter  -> apply via wallpapers.sh (which also regenerates the pywal theme)
//   Alt+D  -> delete the image and its matching line in urls.txt
//   Alt+A  -> prompt for a URL, download it, append it to urls.txt
//   typing -> filter, as `rofi -dmenu -i` did
//
// The geometry knobs are the ones from the script: 200x120 thumbnails in a
// window 80% wide by 90% tall.
PanelWindow {
  id: root

  readonly property string wallpaperDir: "/home/carles/.config/hypr/wallpapers"
  readonly property string urlsFile: wallpaperDir + "/urls.txt"
  readonly property string applyScript: "/home/carles/.config/hypr/scripts/wallpapers.sh"

  readonly property int cellWidth: 200
  readonly property int cellHeight: 120

  // The wallpaper set is ~226MB with individual PNGs up to 20MB. Decoding
  // sixty of those on every open takes ~10s, and Qt's in-memory cache does
  // not survive the window being hidden - so thumbnails are generated once
  // to disk and the grid reads those instead.
  readonly property string thumbDir: "/home/carles/.cache/quickshell/wallpaper-thumbs"

  property string query: ""
  property int selected: 0
  // Alt+A swaps the search field for a URL field.
  property bool urlMode: false

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
  WlrLayershell.namespace: "quickshell-wallpapers"

  color: Qt.rgba(0, 0, 0, 0.5)
  visible: WallpaperState.open

  FolderListModel {
    id: folder
    folder: "file://" + root.wallpaperDir
    // Same extensions the script's `find` matched.
    nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.webp", "*.gif"]
    showDirs: false
    sortField: FolderListModel.Name
  }

  // FolderListModel cannot filter on a query, so flatten it and filter here.
  // Sixty-odd files make this trivially cheap per keystroke.
  readonly property var files: {
    const q = root.query.trim().toLowerCase();
    const out = [];
    for (let i = 0; i < folder.count; i++) {
      const name = folder.get(i, "fileName");
      if (q !== "" && name.toLowerCase().indexOf(q) < 0) continue;
      out.push({ name: name, path: root.wallpaperDir + "/" + name });
    }
    return out;
  }

  readonly property var current:
    selected >= 0 && selected < files.length ? files[selected] : null

  onVisibleChanged: {
    if (visible) {
      root.query = "";
      root.selected = 0;
      root.urlMode = false;
      input.text = "";
      folder.folder = "";                          // force a rescan, so files
      folder.folder = "file://" + root.wallpaperDir;  // added elsewhere show up
      thumbProc.running = true;    // cheap no-op once the cache is warm
      input.forceActiveFocus();
    }
  }

  onFilesChanged: if (root.selected >= files.length) root.selected = 0

  function apply() {
    if (!current) return;
    const path = current.path;
    WallpaperState.hide();
    Quickshell.execDetached([root.applyScript, path]);
  }

  function remove() {
    if (!current) return;
    // Paths go through argv rather than the command string so filenames with
    // spaces or quotes cannot break out.
    removeProc.command = ["sh", "-c", `
      rm -f "$1"
      rm -f "$4/$3.jpg"
      if [ -f "$2" ]; then
        grep -vF "/$3" "$2" > "$2.tmp" && mv "$2.tmp" "$2"
      fi
      notify-send "Wallpapers" "Removed $3"
    `, "sh", current.path, root.urlsFile, current.name, root.thumbDir];
    removeProc.running = true;
  }

  function addUrl(url) {
    if (url.trim() === "") return;
    addProc.command = ["sh", "-c", `
      NEW_URL="$1"
      WALLPAPER_DIR="$2"
      URLS_FILE="$3"

      # Strip query string/fragment so the saved filename is clean - Reddit
      # preview links end in "?width=...&s=<hash>".
      CLEAN_URL="\${NEW_URL%%#*}"
      CLEAN_URL="\${CLEAN_URL%%\\?*}"
      CLEAN_NAME=$(basename "$CLEAN_URL")

      if grep -qxF "$NEW_URL" "$URLS_FILE" 2>/dev/null; then
        notify-send "Wallpapers" "URL already in the list"
      elif [ -e "$WALLPAPER_DIR/$CLEAN_NAME" ]; then
        notify-send "Wallpapers" "$CLEAN_NAME already downloaded"
      elif wget -q --timeout=15 -t 2 -O "$WALLPAPER_DIR/$CLEAN_NAME" "$NEW_URL"; then
        # urls.txt's last line may not end in a newline - fix that first.
        [ -s "$URLS_FILE" ] && [ -n "$(tail -c1 "$URLS_FILE")" ] && echo >> "$URLS_FILE"
        echo "$NEW_URL" >> "$URLS_FILE"
        notify-send "Wallpapers" "Added $CLEAN_NAME"
      else
        rm -f "$WALLPAPER_DIR/$CLEAN_NAME"
        notify-send "Wallpapers" "Failed to download $NEW_URL"
      fi
    `, "sh", url.trim(), root.wallpaperDir, root.urlsFile];
    addProc.running = true;
  }

  // Builds any missing thumbnails. Runs at startup so the cache is usually
  // warm before the picker is ever opened, and again on each open to pick up
  // wallpapers added by other means. Skips files it has already done, so the
  // repeat cost is one stat() per wallpaper.
  Process {
    id: thumbProc
    running: true
    command: ["sh", "-c", `
      SRC="$1"; OUT="$2"
      mkdir -p "$OUT"
      for f in "$SRC"/*.jpg "$SRC"/*.jpeg "$SRC"/*.png "$SRC"/*.webp "$SRC"/*.gif; do
        [ -e "$f" ] || continue
        t="$OUT/$(basename "$f").jpg"
        if [ ! -e "$t" ] || [ "$f" -nt "$t" ]; then
          # [0] takes the first frame, so animated gifs do not explode.
          magick "$f[0]" -resize 400x240 -quality 82 "$t" 2>/dev/null
        fi
      done
    `, "sh", root.wallpaperDir, root.thumbDir]

    // Nudge the delegates to re-resolve their source now thumbs exist.
    onExited: root.thumbRevision++
  }

  property int thumbRevision: 0

  Process { id: removeProc }
  Process {
    id: addProc
    // Pull the new file into the grid once wget finishes.
    onExited: {
      folder.folder = "";
      folder.folder = "file://" + root.wallpaperDir;
    }
  }

  function move(delta) {
    const n = root.files.length;
    if (n === 0) return;
    root.selected = Math.max(0, Math.min(n - 1, root.selected + delta));
    grid.positionViewAtIndex(root.selected, GridView.Contain);
  }

  MouseArea {
    anchors.fill: parent
    onClicked: WallpaperState.hide()
  }

  Rectangle {
    id: dialog
    anchors.centerIn: parent
    width: parent.width * 0.80    // script: `window {width: 80%; height: 90%}`
    height: parent.height * 0.90

    color: Theme.backgroundDark
    radius: 12
    border.width: 2
    border.color: Theme.accent

    MouseArea { anchors.fill: parent }

    // Header: prompt, input, and the selected filename.
    Item {
      id: header
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.margins: 10
      height: 40

      Text {
        id: prompt
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        text: root.urlMode ? "Add URL:" : "\uf03e"
        color: root.urlMode ? Theme.textColor1 : Theme.accent
        font.family: Theme.fontFamily
        font.pixelSize: 16
      }

      TextInput {
        id: input
        anchors.left: prompt.right
        anchors.leftMargin: 10
        anchors.right: hint.left
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        color: Theme.textColor1
        font.family: Theme.fontFamily
        font.pixelSize: 16
        selectByMouse: true
        focus: true

        onTextChanged: {
          if (root.urlMode) return;
          root.query = text;
          root.selected = 0;
          grid.positionViewAtBeginning();
        }

        Keys.onPressed: event => {
          const alt = (event.modifiers & Qt.AltModifier) !== 0;

          if (event.key === Qt.Key_Escape) {
            if (root.urlMode) {
              root.urlMode = false;
              input.text = root.query;
            } else {
              WallpaperState.hide();
            }
          } else if (alt && event.key === Qt.Key_A) {
            root.urlMode = true;
            input.text = "";
          } else if (alt && event.key === Qt.Key_D) {
            if (!root.urlMode) root.remove();
          } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            if (root.urlMode) {
              root.addUrl(input.text);
              root.urlMode = false;
              input.text = root.query;
            } else {
              root.apply();
            }
          } else if (!root.urlMode && event.key === Qt.Key_Right) {
            root.move(1);
          } else if (!root.urlMode && event.key === Qt.Key_Left) {
            root.move(-1);
          } else if (!root.urlMode && event.key === Qt.Key_Down) {
            root.move(grid.columns);
          } else if (!root.urlMode && event.key === Qt.Key_Up) {
            root.move(-grid.columns);
          } else {
            return;   // ordinary editing
          }
          event.accepted = true;
        }
      }

      Text {
        id: hint
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        text: root.urlMode
          ? "Enter add   ·   Esc cancel"
          : (root.current ? root.current.name + "   ·   " : "")
            + "Enter set   ·   Alt+D delete   ·   Alt+A add url"
        color: Theme.textColor3
        font.family: Theme.fontFamily
        font.pixelSize: 11
      }
    }

    GridView {
      id: grid
      anchors.top: header.bottom
      anchors.topMargin: 6
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      anchors.margins: 10

      readonly property int columns: Math.max(1, Math.floor(width / root.cellWidth))

      clip: true
      cellWidth: Math.floor(width / columns)
      cellHeight: root.cellHeight
      model: root.files
      // Keep a screenful of thumbnails decoded either side of the viewport.
      cacheBuffer: root.cellHeight * 4

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
          color: "transparent"
          border.width: cell.index === root.selected ? 3 : 0
          border.color: Theme.accent

          Image {
            id: thumb
            anchors.fill: parent
            anchors.margins: 3

            // Prefer the cached thumbnail; fall back to the original if it
            // has not been generated yet (see onStatusChanged below).
            source: {
              root.thumbRevision;   // re-resolve once generation finishes
              return "file://" + root.thumbDir + "/" + cell.modelData.name + ".jpg";
            }

            sourceSize.width: root.cellWidth * 2   // 2x for HiDPI crispness
            sourceSize.height: root.cellHeight * 2
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            cache: true

            onStatusChanged: {
              if (status === Image.Error && source.toString().indexOf(root.thumbDir) >= 0)
                source = "file://" + cell.modelData.path;
            }
          }
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            root.selected = cell.index;
            root.apply();
          }
        }
      }
    }

    Text {
      anchors.centerIn: grid
      visible: root.files.length === 0
      text: folder.count === 0
        ? "No wallpapers in " + root.wallpaperDir
        : "No matches"
      color: Theme.textColor3
      font.family: Theme.fontFamily
      font.pixelSize: 14
    }
  }
}
