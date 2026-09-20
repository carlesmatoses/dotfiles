import Quickshell
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Layouts

// waybar `bluetooth`. format-off / format-disabled / format-no-controller are
// all "" in modules.json, and `#bluetooth.off` drops the chip entirely - so
// with no adapter (carles-pc has none) this renders nothing at all.
Pill {
  id: root

  readonly property var adapter: Bluetooth.defaultAdapter
  readonly property bool on: adapter ? adapter.enabled === true : false

  readonly property int connectedCount: {
    if (!on) return 0;
    const devs = Bluetooth.devices.values;
    let n = 0;
    for (let i = 0; i < devs.length; i++)
      if (devs[i].connected) n++;
    return n;
  }

  Layout.rightMargin: on ? Theme.moduleGap : 0

  text: on ? (connectedCount > 0 ? "\uf294 " + connectedCount : "\uf294") : ""

  onClicked: Sh.run("blueman-manager")
  onRightClicked: Sh.run("blueman-manager")
}
