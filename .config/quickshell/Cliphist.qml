import QtQuick
import QtQuick.Layouts

// waybar `custom/cliphist`
IconButton {
  Layout.rightMargin: 23   // the shared #custom-* margin-right

  text: "\uf0ea"

  onClicked: Sh.run("sleep 0.1 && kitty --class clipse -e clipse")
}
