import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

// waybar `hyprland/workspaces` with separate-outputs + persistent-workspaces
// ("*": 1-5, "DP-1": 6-10). Hyprland only reports workspaces that currently
// exist, so the persistent set is synthesised here and merged with live state.
RowLayout {
  id: root

  property string screenName: ""

  // Mirrors the workspace->monitor bindings in hypr/monitors/carles-pc.conf.
  readonly property var workspaceIds: screenName === "DP-1"
    ? [6, 7, 8, 9, 10]
    : [1, 2, 3, 4, 5]

  readonly property var monitor: {
    const mons = Hyprland.monitors.values;
    for (let i = 0; i < mons.length; i++)
      if (mons[i].name === root.screenName) return mons[i];
    return null;
  }

  readonly property int activeId: monitor && monitor.activeWorkspace
    ? monitor.activeWorkspace.id : -1

  spacing: 6   // #workspaces button margin: 4px 3px

  Repeater {
    model: root.workspaceIds

    delegate: Rectangle {
      id: ws
      required property int modelData

      readonly property bool isActive: ws.modelData === root.activeId

      // `min-width: 40px` on .active, otherwise hug the label + 5px padding.
      implicitWidth: isActive || mouse.containsMouse
        ? Math.max(40, label.implicitWidth + 10)
        : label.implicitWidth + 10
      implicitHeight: label.implicitHeight + 4

      radius: Theme.radius
      color: isActive || mouse.containsMouse ? Theme.workspaceActive : "transparent"

      Behavior on implicitWidth {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
      }
      Behavior on color {
        ColorAnimation { duration: 300; easing.type: Easing.InOutQuad }
      }

      Text {
        id: label
        anchors.centerIn: parent
        text: ws.modelData
        color: ws.isActive || mouse.containsMouse ? Theme.textColor1 : Theme.textColor3
        font.family: Theme.fontFamily
        font.pixelSize: 16
        font.bold: true
      }

      MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Hyprland.dispatch("workspace " + ws.modelData)
      }
    }
  }
}
