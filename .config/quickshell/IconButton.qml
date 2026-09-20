import QtQuick

// Bare nerd-font glyph with no chip behind it - the `#custom-*` rule in
// waybar/style.css: font-size 20px, bold, @iconcolor, plus the 1px text-shadow
// in @bordercolor that keeps icons legible on a transparent bar.
Item {
  id: root

  property string text: ""
  property color foreground: Theme.iconColor
  property int fontSize: Theme.iconFontSize

  signal clicked()
  signal rightClicked()

  implicitWidth: label.implicitWidth
  implicitHeight: label.implicitHeight

  Text {
    id: shadow
    anchors.centerIn: parent
    text: root.text
    color: Theme.borderColor
    font.family: Theme.fontFamily
    font.pixelSize: root.fontSize
    font.bold: true
    // Stand-in for `text-shadow: 0px 0px 1px @bordercolor`.
    style: Text.Outline
    styleColor: Theme.borderColor
    opacity: 0.55
  }

  Text {
    id: label
    anchors.centerIn: parent
    text: root.text
    color: root.foreground
    font.family: Theme.fontFamily
    font.pixelSize: root.fontSize
    font.bold: true
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: mouse => {
      if (mouse.button === Qt.RightButton) root.rightClicked();
      else root.clicked();
    }
  }
}
