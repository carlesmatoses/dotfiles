import QtQuick
import QtQuick.Layouts

// waybar `custom/appmenu`
Pill {
  Layout.rightMargin: Theme.moduleGap

  text: "Apps"
  color: Theme.backgroundDark
  foreground: Theme.textColor1

  onClicked: LauncherState.toggle()
  onRightClicked: Sh.run("~/.config/hypr/scripts/keybindings.sh")
}
