import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

// Entry point. `qs -p ~/github/dotfiles/.config/quickshell` loads this file.
ShellRoot {
  // Replaces hyprpaper - one background surface per screen.
  Variants {
    model: Quickshell.screens

    Wallpaper {
      required property var modelData
      screen: modelData
    }
  }

  Variants {
    model: Quickshell.screens

    Bar {
      required property var modelData
      screen: modelData
    }
  }

  // One launcher, not one per screen - it follows the focused monitor.
  Launcher {}

  // Notification daemon UI. The server itself lives in NotificationService,
  // which is a singleton so it stays alive independently of these windows.
  NotificationPopups {}
  NotificationPanel {}

  // Replaces wlogout.
  PowerMenu {}

  // Replaces .config/hypr/scripts/wallpaper-picker.sh.
  WallpaperPicker {}

  // Replaces `rofi -modi emoji`.
  EmojiPicker {}

  // Replaces .config/hypr/scripts/keybindings.sh.
  Keybinds {}

  // Bound in hypr/configs/keybindings.conf as:
  //   bind = $mainMod, space, global, quickshell:launcher
  GlobalShortcut {
    appid: "quickshell"
    name: "launcher"
    description: "Toggle the application launcher"
    onPressed: LauncherState.toggle()
  }

  // Bound as: bind = $mainMod, P, global, quickshell:powermenu
  GlobalShortcut {
    appid: "quickshell"
    name: "powermenu"
    description: "Toggle the power menu"
    onPressed: PowerMenuState.toggle()
  }

  // Bound as: bind = $mainMod, W, global, quickshell:wallpapers
  GlobalShortcut {
    appid: "quickshell"
    name: "wallpapers"
    description: "Toggle the wallpaper picker"
    onPressed: WallpaperState.toggle()
  }

  // Bound as: bind = $mainMod, comma, global, quickshell:emoji
  GlobalShortcut {
    appid: "quickshell"
    name: "emoji"
    description: "Toggle the emoji picker"
    onPressed: EmojiState.toggle()
  }

  // Bound as: bind = $mainMod, period, global, quickshell:keybinds
  GlobalShortcut {
    appid: "quickshell"
    name: "keybinds"
    description: "Toggle the keybinds cheatsheet"
    onPressed: KeybindsState.toggle()
  }

  // `qs ipc call launcher toggle` - useful for debugging and for binding
  // from anywhere that cannot use the global shortcut protocol.
  IpcHandler {
    target: "launcher"

    function toggle(): void { LauncherState.toggle(); }
    function open(): void { LauncherState.show(); }
    function close(): void { LauncherState.hide(); }
  }

  IpcHandler {
    target: "wallpapers"

    function toggle(): void { WallpaperState.toggle(); }
    function open(): void { WallpaperState.show(); }
    function close(): void { WallpaperState.hide(); }
  }

  IpcHandler {
    target: "emoji"

    function toggle(): void { EmojiState.toggle(); }
    function open(): void { EmojiState.show(); }
    function close(): void { EmojiState.hide(); }
  }

  IpcHandler {
    target: "keybinds"

    function toggle(): void { KeybindsState.toggle(); }
    function open(): void { KeybindsState.show(); }
    function close(): void { KeybindsState.hide(); }
  }

  IpcHandler {
    target: "powermenu"

    function toggle(): void { PowerMenuState.toggle(); }
    function open(): void { PowerMenuState.show(); }
    function close(): void { PowerMenuState.hide(); }
  }

  IpcHandler {
    target: "notifications"

    function toggle(): void { NotificationCenter.toggle(); }
    function open(): void { NotificationCenter.show(); }
    function close(): void { NotificationCenter.hide(); }
    function clear(): void { NotificationService.clearHistory(); }
    function count(): string {
      return NotificationService.history.length + " in history, "
        + NotificationService.popups.length + " showing, "
        + NotificationService.unreadCount + " unread";
    }
  }
}
