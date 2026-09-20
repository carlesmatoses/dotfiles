import QtQuick

// The rounded module chip shared by clock/volume/network/battery/... .
// Mirrors the common block in waybar/style.css:
//   border-radius: 15px; padding: 2px 10px 0px 10px; font-size: 16px;
Rectangle {
  id: root

  property string text: ""
  // Subclasses set baseColor, not color: `color` applies Theme.surfaceAlpha
  // on top so bar translucency is a single knob in Theme.qml.
  property color baseColor: Theme.backgroundLight
  property color foreground: Theme.textColor2
  property int fontSize: Theme.pillFontSize
  property bool bold: false

  signal clicked()
  signal rightClicked()

  color: Qt.alpha(baseColor, Theme.surfaceAlpha)
  radius: Theme.radius
  visible: text !== ""

  implicitWidth: label.implicitWidth + Theme.pillPaddingH * 2
  implicitHeight: label.implicitHeight + Theme.pillPaddingV * 2

  Text {
    id: label
    anchors.centerIn: parent
    text: root.text
    color: root.foreground
    font.family: Theme.fontFamily
    font.pixelSize: root.fontSize
    font.bold: root.bold
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
