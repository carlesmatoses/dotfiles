import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

// waybar `backlight`. Quickshell has no backlight service, so poll
// `brightnessctl -m` (machine-readable: device,class,current,percent%,max).
// Stays hidden on machines with no backlight device, e.g. carles-pc.
Pill {
  id: root

  property int percent: -1
  // Latches false on a desktop (no brightnessctl / no backlight device) so we
  // stop respawning a process that can never succeed.
  property bool supported: true
  readonly property bool available: supported && percent >= 0

  Layout.rightMargin: available ? Theme.moduleGap : 0

  // format-icons ["\u{F06E9}", "\u{F06E8}"] - above the BMP, so built by
  // codepoint rather than written as literals.
  readonly property string iconLow: String.fromCodePoint(0xF06E9)
  readonly property string iconHigh: String.fromCodePoint(0xF06E8)

  text: available
    ? (percent >= 50 ? iconHigh : iconLow) + " " + percent + "%"
    : ""

  Process {
    id: proc
    command: ["brightnessctl", "-m"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        const fields = this.text.trim().split(",");
        // e.g. intel_backlight,backlight,45000,38%,120000
        if (fields.length >= 4)
          root.percent = parseInt(fields[3].replace("%", ""), 10);
        else
          root.percent = -1;
      }
    }

    // No brightnessctl / no device - stay hidden rather than error out.
    onExited: code => {
      if (code !== 0) {
        root.percent = -1;
        root.supported = false;
      }
    }
    // Emitted when the binary itself is missing.
    onStarted: root.supported = true
  }

  Timer {
    interval: 2000
    running: root.supported
    repeat: true
    onTriggered: proc.running = true
  }

  // `Process failed to start` does not fire onExited, so catch the missing
  // binary by checking that the first run actually produced a reading.
  Timer {
    interval: 3000
    running: true
    repeat: false
    onTriggered: if (root.percent < 0) root.supported = false
  }

  onClicked: Sh.run("brightnessctl set +5%")
  onRightClicked: Sh.run("brightnessctl set 5%-")
}
