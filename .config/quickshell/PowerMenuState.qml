pragma Singleton

import Quickshell

// Open/closed state for the power menu, mirroring LauncherState so the bar's
// exit button and the Hyprland global shortcut can both drive it.
Singleton {
  id: root

  property bool open: false

  function show() { root.open = true; }
  function hide() { root.open = false; }
  function toggle() { root.open = !root.open; }
}
