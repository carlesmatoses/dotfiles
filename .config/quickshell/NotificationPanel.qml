import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

// Notification history. Full-screen transparent overlay with the panel pinned
// top-right under the bar, so a click anywhere else dismisses it - the same
// pattern as Launcher.qml.
PanelWindow {
  id: root

  readonly property int barHeight: 34
  readonly property int edgeMargin: 10

  screen: Monitors.focused

  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }

  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
  WlrLayershell.namespace: "quickshell-notification-center"

  color: "transparent"
  visible: NotificationCenter.open

  MouseArea {
    anchors.fill: parent
    onClicked: NotificationCenter.hide()
  }

  Rectangle {
    id: panel

    anchors.top: parent.top
    anchors.right: parent.right
    anchors.topMargin: root.barHeight + root.edgeMargin
    anchors.rightMargin: root.edgeMargin

    width: 370
    height: Math.min(parent.height - root.barHeight - root.edgeMargin * 2,
                     header.height + 8 + Math.max(60, list.contentHeight) + 16)

    color: Qt.alpha(Theme.backgroundDark, Theme.panelAlpha)
    radius: 8
    border.width: 2
    border.color: Theme.accent

    // Swallow clicks so they do not reach the dismiss handler behind.
    MouseArea { anchors.fill: parent }

    RowLayout {
      id: header
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.margins: 10
      height: 20

      Text {
        Layout.fillWidth: true
        text: "Notifications"
        color: Theme.textColor1
        font.family: Theme.fontFamily
        font.pixelSize: 13
        font.bold: true
      }

      Text {
        visible: NotificationService.history.length > 0
        text: "Clear all"
        color: clearMouse.containsMouse ? Theme.textColor1 : Theme.textColor3
        font.family: Theme.fontFamily
        font.pixelSize: 11

        MouseArea {
          id: clearMouse
          anchors.fill: parent
          anchors.margins: -4
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: NotificationService.clearHistory()
        }
      }
    }

    ListView {
      id: list
      anchors.top: header.bottom
      anchors.topMargin: 8
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      anchors.leftMargin: 10
      anchors.rightMargin: 10
      anchors.bottomMargin: 10

      clip: true
      spacing: 8
      model: NotificationService.history

      delegate: NotificationCard {
        required property var modelData
        width: list.width
        notification: modelData
        popup: false

        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.MiddleButton
          onClicked: NotificationService.dismiss(modelData)
        }
      }
    }

    Text {
      anchors.centerIn: list
      visible: NotificationService.history.length === 0
      text: "No notifications"
      color: Theme.textColor3
      font.family: Theme.fontFamily
      font.pixelSize: 12
    }
  }
}
