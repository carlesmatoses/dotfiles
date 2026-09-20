pragma Singleton

import Quickshell

// Open/closed state for the keybinds cheatsheet, mirroring LauncherState.
Singleton {
  id: root

  property bool open: false

  function show() { root.open = true; }
  function hide() { root.open = false; }
  function toggle() { root.open = !root.open; }
}
