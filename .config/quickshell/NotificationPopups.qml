import Quickshell
import Quickshell.Wayland
import QtQuick

// Toast stack. mako had `anchor=top-right, margin=10`; here the top margin
// also clears the bar's 34px strip.
//
// The window is sized to the stack rather than the screen so clicks outside
// it pass through to whatever is underneath.
PanelWindow {
  id: root

  readonly property int barHeight: 34
  readonly property int edgeMargin: 10   // mako `margin=10`

  // mako put toasts on the focused output; do the same.
  screen: Monitors.focused

  anchors {
    top: true
    right: true
  }

  margins {
    top: barHeight + edgeMargin
    right: edgeMargin
  }

  implicitWidth: 350 + 2
  implicitHeight: Math.max(1, column.implicitHeight)

  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  // OnDemand, not Exclusive - the inline reply field needs to be able to take
  // focus when clicked, but this window is long-lived and must never hold the
  // keyboard the way the launcher does.
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
  WlrLayershell.namespace: "quickshell-notifications"

  color: "transparent"
  visible: NotificationService.popups.length > 0

  Column {
    id: column
    anchors.right: parent.right
    anchors.top: parent.top
    spacing: 8

    Repeater {
      model: NotificationService.popups

      delegate: NotificationCard {
        required property var modelData
        notification: modelData
        popup: true
      }
    }
  }
}
