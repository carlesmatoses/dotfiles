import QtQuick
import QtQuick.Layouts

// Bar widget: bell glyph plus an unread badge, toggling the history panel.
Item {
  id: root

  readonly property int unread: NotificationService.unreadCount

  Layout.rightMargin: 23   // the shared #custom-* margin in waybar/style.css

  implicitWidth: bell.implicitWidth
  implicitHeight: bell.implicitHeight

  IconButton {
    id: bell
    anchors.centerIn: parent
    // nf-fa-bell, or bell-slash when there is nothing unread.
    text: root.unread > 0 ? "\uf0f3" : "\uf0a2"
    onClicked: NotificationCenter.toggle()
  }

  // Unread count, tucked into the top-right of the glyph.
  Rectangle {
    visible: root.unread > 0
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.rightMargin: -4
    anchors.topMargin: -2

    width: Math.max(14, count.implicitWidth + 6)
    height: 14
    radius: 7
    color: Theme.accent

    Text {
      id: count
      anchors.centerIn: parent
      text: root.unread > 99 ? "99+" : root.unread
      color: Theme.textColor1
      font.family: Theme.fontFamily
      font.pixelSize: 9
      font.bold: true
    }
  }
}
