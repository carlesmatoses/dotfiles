import QtQuick
import QtQuick.Layouts

// waybar `custom/exit` - #custom-exit margin: 0px 20px 0px 0px
IconButton {
  Layout.rightMargin: 20

  text: "\uf011"   // nf-fa-power_off

  onClicked: Sh.run("wlogout")
}
