pragma Singleton

import Quickshell

// Open/closed state for the history panel, mirroring LauncherState so the
// bar button and the panel itself stay decoupled.
Singleton {
  id: root

  property bool open: false

  function show() {
    root.open = true;
    NotificationService.markRead();
  }

  function hide() { root.open = false; }

  function toggle() {
    if (root.open) root.hide();
    else root.show();
  }
}
