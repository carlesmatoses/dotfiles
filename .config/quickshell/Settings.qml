import QtQuick
import QtQuick.Layouts

// waybar `custom/settings` - #custom-settings overrides margin-right to 16px
IconButton {
  Layout.rightMargin: 16

  text: "\uf013"

  onClicked: Sh.run("rofi -modi 'Config:~/.config/rofi/scripts/config.sh' -show Config")
}
