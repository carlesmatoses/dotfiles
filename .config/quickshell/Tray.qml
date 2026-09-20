import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

// waybar `tray` - spacing 10, #tray margin-right 10px
RowLayout {
  id: root

  Layout.rightMargin: 10
  spacing: 10

  // Quickshell exposes SystemTrayItem.status as a plain int using the
  // StatusNotifierItem values; there is no QML enum to reference.
  readonly property int statusPassive: 0

  Repeater {
    model: SystemTray.items

    delegate: Item {
      id: entry
      required property SystemTrayItem modelData

      implicitWidth: 18
      implicitHeight: 18

      IconImage {
        anchors.fill: parent
        source: entry.modelData.icon
        // `#tray > .passive { -gtk-icon-effect: dim }`
        opacity: entry.modelData.status === root.statusPassive ? 0.5 : 1.0
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
          if (mouse.button === Qt.RightButton || entry.modelData.onlyMenu)
            entry.modelData.display(entry, 0, entry.height);
          else
            entry.modelData.activate();
        }
      }
    }
  }
}
