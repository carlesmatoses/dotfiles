import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

// waybar `pulseaudio`
//   format:        "{icon} {volume}%"
//   format-muted:  "\uf6a9  {format_source}"
//   format-source: "{volume}% \uf130"
Pill {
  id: root

  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property PwNode source: Pipewire.defaultAudioSource

  readonly property bool muted: sink && sink.audio ? sink.audio.muted : false
  readonly property int percent: sink && sink.audio
    ? Math.round(sink.audio.volume * 100) : 0
  readonly property bool sourceMuted: source && source.audio
    ? source.audio.muted : false
  readonly property int sourcePercent: source && source.audio
    ? Math.round(source.audio.volume * 100) : 0

  // Without a tracker the audio sub-objects never bind.
  PwObjectTracker {
    objects: {
      const objs = [];
      if (root.sink) objs.push(root.sink);
      if (root.source) objs.push(root.source);
      return objs;
    }
  }

  Layout.rightMargin: Theme.moduleGap

  readonly property string formatSource: sourceMuted
    ? "\uf131"
    : sourcePercent + "% \uf130"

  text: {
    if (!sink) return "";
    if (muted) return "\uf6a9  " + formatSource;
    // format-icons default: ["\uf026", "\uf028 ", "\uf028 "]
    const icons = ["\uf026", "\uf028 ", "\uf028 "];
    const i = percent >= 66 ? 2 : (percent >= 33 ? 1 : 0);
    return icons[i] + " " + percent + "%";
  }

  // `#pulseaudio.muted` flips to the dark background + textcolor1.
  color: muted ? Theme.backgroundDark : Theme.backgroundLight
  foreground: muted ? Theme.textColor1 : Theme.textColor2

  onClicked: Sh.run("pavucontrol")
}
