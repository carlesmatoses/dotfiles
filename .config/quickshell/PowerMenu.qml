import Quickshell
import Quickshell.Wayland
import QtQuick

// Replacement for wlogout. The five entries, their order, their labels and
// their single-key shortcuts come from .config/wlogout/layout; every action
// still runs ~/.config/hypr/scripts/power.sh, which handles terminating
// clients gracefully before exit/reboot/shutdown.
PanelWindow {
  id: root

  property int selected: 0

  readonly property var entries: [
    { icon: "\uf023", text: "Lock",      key: Qt.Key_L, action: "lock" },
    { icon: "\uf08b", text: "Log Out",   key: Qt.Key_E, action: "exit" },
    { icon: "\uf186", text: "Suspend",   key: Qt.Key_U, action: "suspend" },
    { icon: "\uf021", text: "Restart",   key: Qt.Key_R, action: "reboot" },
    { icon: "\uf011", text: "Power Off", key: Qt.Key_S, action: "shutdown" }
  ]

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
  WlrLayershell.namespace: "quickshell-powermenu"

  // wlogout drew a 50% black wash over a blurred wallpaper; the blur comes
  // from the layerrule in hyprland.conf, this is the wash.
  color: Qt.rgba(0, 0, 0, Theme.scrimAlpha)
  visible: PowerMenuState.open

  onVisibleChanged: {
    if (visible) {
      root.selected = 0;
      keyHandler.forceActiveFocus();
    }
  }

  function activate(index) {
    if (index < 0 || index >= entries.length) return;
    const action = entries[index].action;
    PowerMenuState.hide();
    Sh.run("~/.config/hypr/scripts/power.sh " + action);
  }

  // Click anywhere outside a button to dismiss.
  MouseArea {
    anchors.fill: parent
    onClicked: PowerMenuState.hide()
  }

  Item {
    id: keyHandler
    anchors.fill: parent
    focus: true

    Keys.onPressed: event => {
      // Single-key shortcuts, matching wlogout's `keybind` fields.
      for (let i = 0; i < root.entries.length; i++) {
        if (event.key === root.entries[i].key) {
          root.activate(i);
          event.accepted = true;
          return;
        }
      }

      if (event.key === Qt.Key_Escape) {
        PowerMenuState.hide();
      } else if (event.key === Qt.Key_Right || event.key === Qt.Key_Tab) {
        root.selected = (root.selected + 1) % root.entries.length;
      } else if (event.key === Qt.Key_Left || event.key === Qt.Key_Backtab) {
        root.selected = (root.selected - 1 + root.entries.length) % root.entries.length;
      } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
        root.activate(root.selected);
      } else {
        return;
      }
      event.accepted = true;
    }

    Row {
      anchors.centerIn: parent
      spacing: 20   // wlogout `button { margin: 10px }` either side

      Repeater {
        model: root.entries

        delegate: Rectangle {
          id: button
          required property var modelData
          required property int index

          // Keyboard selection and hover are deliberately separate states,
          // as they were in wlogout's `button:focus` vs `button:hover`.
          // Hover must not move the keyboard selection: otherwise leaving the
          // pointer over "Power Off" and pressing Enter would shut down
          // instead of acting on whatever was selected with the arrows.
          readonly property bool selected: index === root.selected
          readonly property bool hovered: mouse.containsMouse

          width: 170
          height: 170
          radius: 20   // wlogout `#lock, #logout, ... { border-radius: 20px }`

          color: selected ? Theme.accent : Theme.backgroundDark
          border.width: 2
          border.color: selected || hovered ? Theme.borderColor : Theme.accent

          // wlogout grew the button on hover.
          scale: selected || hovered ? 1.06 : 1.0
          Behavior on scale { NumberAnimation { duration: 150 } }
          Behavior on color { ColorAnimation { duration: 150 } }

          Column {
            anchors.centerIn: parent
            spacing: 14

            Text {
              anchors.horizontalCenter: parent.horizontalCenter
              text: button.modelData.icon
              color: Theme.textColor1
              font.family: Theme.fontFamily
              font.pixelSize: 48
            }

            Text {
              anchors.horizontalCenter: parent.horizontalCenter
              text: button.modelData.text
              color: Theme.textColor1
              font.family: Theme.fontFamily
              font.pixelSize: 15
            }
          }

          MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.activate(button.index)
          }
        }
      }
    }

    // Shortcut hint, since wlogout's keybinds are not otherwise discoverable.
    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.verticalCenter
      anchors.topMargin: 130
      text: "L lock   E log out   U suspend   R restart   S power off   Esc cancel"
      color: Theme.textColor3
      font.family: Theme.fontFamily
      font.pixelSize: 12
    }
  }
}
