pragma Singleton

import Quickshell
import Quickshell.Hyprland

// Maps Hyprland's focused monitor onto the matching ShellScreen, for the
// single-instance windows (launcher, notification popups, notification
// center) that should follow focus rather than pin to one output.
Singleton {
  id: root

  readonly property var focused: {
    const mon = Hyprland.focusedMonitor
      || (Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.monitor : null);
    const screens = Quickshell.screens;
    if (mon)
      for (let i = 0; i < screens.length; i++)
        if (screens[i].name === mon.name) return screens[i];
    return screens.length > 0 ? screens[0] : null;
  }
}
