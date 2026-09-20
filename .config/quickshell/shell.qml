import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

// Entry point. `qs -p ~/github/dotfiles/.config/quickshell` loads this file.
ShellRoot {
  Variants {
    model: Quickshell.screens

    Bar {
      required property var modelData
      screen: modelData
    }
  }

  // One launcher, not one per screen - it follows the focused monitor.
  Launcher {}

  // Bound in hypr/configs/keybindings.conf as:
  //   bind = $mainMod, space, global, quickshell:launcher
  GlobalShortcut {
    appid: "quickshell"
    name: "launcher"
    description: "Toggle the application launcher"
    onPressed: LauncherState.toggle()
  }

  // `qs ipc call launcher toggle` - useful for debugging and for binding
  // from anywhere that cannot use the global shortcut protocol.
  IpcHandler {
    target: "launcher"

    function toggle(): void { LauncherState.toggle(); }
    function open(): void { LauncherState.show(); }
    function close(): void { LauncherState.hide(); }
  }
}
