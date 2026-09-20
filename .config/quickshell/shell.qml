import Quickshell

// Entry point. `qs -p ~/github/dotfiles/.config/quickshell` loads this file.
ShellRoot {
  Variants {
    model: Quickshell.screens

    Bar {
      required property var modelData
      screen: modelData
    }
  }
}
