import Quickshell
import Quickshell.Widgets
import QtQuick

// One result row. Ports rofi/sk_theme.rasi `element`:
//   padding: 4px 12px; margin: 4px 0px; border-radius: 4px;
// with `element selected.normal` giving bg @hv and fg @primary.
Rectangle {
  id: root

  property var entry: null
  property bool selected: false

  signal activated()

  // `element { padding: 4px 12px }` around a 16px name and an 11px comment.
  implicitHeight: 40

  radius: 4
  color: selected ? Theme.accent : "transparent"

  IconImage {
    id: icon
    anchors.left: parent.left
    anchors.leftMargin: 12   // element padding-left
    anchors.verticalCenter: parent.verticalCenter
    implicitSize: 24
    // `element-icon { size: 0.9em }` against a 16px font is small; 24px reads
    // better at this row height and still matches rofi's proportions.
    source: root.entry ? Quickshell.iconPath(root.entry.icon, true) : ""
    visible: source !== ""
  }

  Column {
    anchors.left: icon.visible ? icon.right : parent.left
    anchors.leftMargin: 12
    anchors.right: parent.right
    anchors.rightMargin: 12
    anchors.verticalCenter: parent.verticalCenter
    spacing: 0

    Text {
      width: parent.width
      text: root.entry ? root.entry.name : ""
      color: root.selected ? Theme.textColor1 : Theme.textColor2
      font.family: Theme.fontFamily
      font.pixelSize: 16
      elide: Text.ElideRight
    }

    Text {
      width: parent.width
      // drun-display-format is "{icon} {name}"; the comment is extra, shown
      // dimmed because it also feeds the search.
      text: root.entry && root.entry.comment ? root.entry.comment : ""
      visible: text !== ""
      color: Theme.textColor3
      font.family: Theme.fontFamily
      font.pixelSize: 11
      elide: Text.ElideRight
    }
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: root.activated()
  }
}
