import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

// waybar `group/hardware` - a drawer holding custom/system, disk, cpu, memory
// and hyprland/language. The chip icon is always visible; hovering slides the
// stats out to its left (transition-left-to-right: false) over 300ms.
//
// The root is a plain Item rather than a RowLayout because the hover MouseArea
// has to cover the whole widget, and anchors are ignored on a Layout's direct
// children.
Item {
  id: root

  property int diskPercent: 0
  property int memPercent: 0
  property int cpuPercent: 0
  property string layout: ""

  // Previous /proc/stat sample, for the cpu delta.
  property int prevTotal: 0
  property int prevIdle: 0

  readonly property bool expanded: hoverArea.containsMouse

  Layout.rightMargin: 15   // #custom-system margin-right

  implicitWidth: content.implicitWidth
  implicitHeight: content.implicitHeight

  RowLayout {
    id: content
    width: parent.width
    height: parent.height
    spacing: 0

    // Drawer contents - width animates to zero when collapsed. The inner row
    // is right-anchored so the stats slide out leftwards from behind the icon.
    Item {
      Layout.preferredWidth: root.expanded ? stats.implicitWidth : 0
      Layout.preferredHeight: stats.implicitHeight
      clip: true

      Behavior on Layout.preferredWidth {
        NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
      }

      RowLayout {
        id: stats
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        Text {
          text: "D " + root.diskPercent + "% "
          color: Theme.iconColor
          font.family: Theme.fontFamily
          font.pixelSize: 16
        }
        Text {
          text: "/ C " + root.cpuPercent + "% "
          color: Theme.iconColor
          font.family: Theme.fontFamily
          font.pixelSize: 16
        }
        Text {
          text: "/ M " + root.memPercent + "% "
          color: Theme.iconColor
          font.family: Theme.fontFamily
          font.pixelSize: 16
        }
        Text {
          // #language margin-right: 10px
          Layout.rightMargin: 10
          text: root.layout === "" ? "" : "/ K " + root.layout
          color: Theme.iconColor
          font.family: Theme.fontFamily
          font.pixelSize: 16
        }
      }
    }

    IconButton {
      text: "\uf2db"
      onClicked: Sh.run("kitty -e btop")
    }
  }

  // Covers the icon and the expanded drawer. NoButton so clicks still reach
  // the IconButton underneath.
  MouseArea {
    id: hoverArea
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.NoButton
  }

  // disk% mem% cpuTotal cpuIdle, in one shot. The cpu figure is a delta, so
  // it is computed here rather than in the shell.
  Process {
    id: statsProc
    running: true
    command: ["sh", "-c", `
      d=$(df -P / | awk 'NR==2{sub(/%/,"",$5); print $5}')
      m=$(awk '/^MemTotal:/{t=$2} /^MemAvailable:/{a=$2} END{printf "%d", (t-a)*100/t}' /proc/meminfo)
      c=$(awk '/^cpu /{idle=$5+$6; tot=0; for(i=2;i<=NF;i++) tot+=$i; print tot" "idle}' /proc/stat)
      printf '%s %s %s' "$d" "$m" "$c"
    `]

    stdout: StdioCollector {
      onStreamFinished: {
        const f = this.text.trim().split(/\s+/);
        if (f.length < 4) return;
        root.diskPercent = parseInt(f[0], 10);
        root.memPercent = parseInt(f[1], 10);

        const total = parseInt(f[2], 10);
        const idle = parseInt(f[3], 10);
        if (root.prevTotal > 0 && total > root.prevTotal) {
          const dTotal = total - root.prevTotal;
          const dIdle = idle - root.prevIdle;
          root.cpuPercent = Math.max(0, Math.round((dTotal - dIdle) * 100 / dTotal));
        }
        root.prevTotal = total;
        root.prevIdle = idle;
      }
    }
  }

  // waybar's hyprland/language {short}. The Hyprland singleton has no keyboard
  // layout property, so this comes from hyprctl.
  Process {
    id: layoutProc
    running: true
    command: ["hyprctl", "devices", "-j"]

    stdout: StdioCollector {
      onStreamFinished: {
        try {
          const keebs = JSON.parse(this.text).keyboards;
          for (let i = 0; i < keebs.length; i++) {
            if (!keebs[i].main) continue;
            // "English (US)" -> "en", "Spanish (Spain)" -> "sp"
            root.layout = keebs[i].active_keymap.slice(0, 2).toLowerCase();
            return;
          }
        } catch (e) {
          root.layout = "";
        }
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: {
      statsProc.running = true;
      layoutProc.running = true;
    }
  }
}
