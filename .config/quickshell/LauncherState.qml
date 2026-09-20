pragma Singleton

import Quickshell

// Open/closed state for the app launcher, kept separate from the window so
// the bar's AppMenu pill and the Hyprland global shortcut can both drive it
// without reaching across the window tree for an id.
Singleton {
  id: root

  property bool open: false

  function show() { root.open = true; }
  function hide() { root.open = false; }
  function toggle() { root.open = !root.open; }
}
