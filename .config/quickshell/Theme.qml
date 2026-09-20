pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Colors come from pywal, the same source waybar's style.css imports via
// `@import '/home/carles/.cache/wal/colors-waybar.css'`. We read colors.json
// instead of the css because it needs no parsing.
//
// Property names deliberately mirror the @define-color names in
// waybar/style.css so the two can be diffed by eye.
Singleton {
  id: root

  // Fallbacks match the palette that was live when this was written, so the
  // bar still renders if the wal cache is missing.
  property color backgroundLight: "#121518"  // @color0
  property color backgroundDark: "#121518"   // @background
  property color textColor1: "#cbe6f0"       // @foreground
  property color textColor2: "#cbe6f0"       // @color7
  property color textColor3: "#8ea1a8"       // @color8
  property color iconColor: "#5D7083"        // @color2
  property color workspaceActive: "#5D7083"  // @color2
  property color borderColor: "#68B6C5"      // @color4

  // What rofi/sk_theme.rasi calls @accent / @hv - it resolves to
  // selected-normal-background in colors-rofi-dark.rasi, which is color2.
  property color accent: "#5D7083"           // @color2

  // Not themed by wal in waybar either - these are literals in style.css.
  readonly property color critical: "#f53c3c"

  // Metrics lifted from waybar/style.css.
  readonly property string fontFamily: "JetBrainsMono Nerd Font"
  readonly property int radius: 15
  readonly property int pillFontSize: 16
  readonly property int iconFontSize: 20
  readonly property int moduleGap: 15      // margin-right on every pill
  readonly property int pillPaddingH: 10   // padding: 2px 10px
  readonly property int pillPaddingV: 2

  FileView {
    path: "/home/carles/.cache/wal/colors.json"
    watchChanges: true

    onFileChanged: reload()
    onLoaded: root.apply(text())
  }

  function apply(raw) {
    try {
      const w = JSON.parse(raw);
      root.backgroundLight = w.colors.color0;
      root.backgroundDark = w.special.background;
      root.textColor1 = w.special.foreground;
      root.textColor2 = w.colors.color7;
      root.textColor3 = w.colors.color8;
      root.iconColor = w.colors.color2;
      root.workspaceActive = w.colors.color2;
      root.accent = w.colors.color2;
      root.borderColor = w.colors.color4;
    } catch (e) {
      console.warn("Theme: could not parse wal colors.json:", e);
    }
  }
}
