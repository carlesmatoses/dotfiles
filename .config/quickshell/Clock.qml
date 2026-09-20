import Quickshell
import QtQuick
import QtQuick.Layouts

// waybar `clock`
//   format:     "{:%H:%M %d/%m/%y %a}"
//   format-alt: "{:%A, %B %d, %Y (%R)} "   (toggled by clicking)
//
// The calendar tooltip is not reproduced.
Pill {
  id: root

  property bool alt: false

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  Layout.rightMargin: Theme.moduleGap

  baseColor: Theme.backgroundDark
  foreground: Theme.textColor1

  text: alt
    ? Qt.formatDateTime(clock.date, "dddd, MMMM dd, yyyy (HH:mm)") + " "
    : Qt.formatDateTime(clock.date, "HH:mm dd/MM/yy ddd")

  onClicked: alt = !alt
}
