import QtQuick
import QtQuick.Layouts

// waybar `custom/appmenu`
Pill {
  Layout.rightMargin: Theme.moduleGap

  text: "Apps"
  baseColor: Theme.backgroundDark
  foreground: Theme.textColor1

  onClicked: LauncherState.toggle()
  onRightClicked: KeybindsState.toggle()
}
