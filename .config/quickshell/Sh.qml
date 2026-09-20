pragma Singleton

import Quickshell

// Fire-and-forget shell launcher for the `on-click` actions in
// waybar/modules.json. Detached so the spawned app outlives a bar reload.
Singleton {
  function run(cmd) {
    Quickshell.execDetached(["sh", "-c", cmd]);
  }
}
