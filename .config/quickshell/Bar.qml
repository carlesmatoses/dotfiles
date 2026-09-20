import Quickshell
import QtQuick
import QtQuick.Layouts

// Top bar, one instance per screen. Replaces waybar's config:
//   layer top, margins 0, spacing 0, transparent window background.
PanelWindow {
  id: bar

  anchors {
    top: true
    left: true
    right: true
  }

  color: "transparent"

  implicitHeight: 34

  // Left ----------------------------------------------------------------
  RowLayout {
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    anchors.leftMargin: 10   // #custom-appmenu margin-left
    spacing: 0

    AppMenu {}
    Tray {}
  }

  // Center --------------------------------------------------------------
  // Anchored to the panel centre rather than laid out between the side rows,
  // so workspaces do not drift when the right side changes width.
  Workspaces {
    anchors.centerIn: parent
    screenName: bar.screen ? bar.screen.name : ""
  }

  // Right ---------------------------------------------------------------
  RowLayout {
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    spacing: 0

    Volume {}
    Backlight {}
    BluetoothWidget {}
    Battery {}
    Network {}
    Hardware {}
    NotificationButton {}
    Cliphist {}
    ExitButton {}
    Clock {}
  }
}
