import Quickshell
import Quickshell.Wayland
import QtQuick

// Replaces hyprpaper. One of these per screen, on the background layer.
//
// hyprpaper needed .config/hypr/hyprpaper.conf regenerated and the daemon
// restarted on every change; here the path comes from Theme.wallpaper, which
// is the `wallpaper` key of the same ~/.cache/wal/colors.json that already
// drives the palette. Wallpaper and colors therefore change together and
// nothing has to be restarted.
PanelWindow {
  id: root

  readonly property string target:
    Theme.wallpaper === "" ? "" : "file://" + Theme.wallpaper

  // Straight A/B double buffer. `front` is what you see; the incoming image
  // is decoded into `back` at opacity 0 and only then faded in over the top.
  //
  // The outgoing image is never faded out - it just gets covered. That
  // matters: an earlier version animated one shared opacity from both a
  // sourceChanged handler and a statusChanged handler, so a fast-decoding
  // image reversed the fade before it was visible and the change looked
  // instant, while a slow 20MB PNG got a full fade. Load time decided the
  // behaviour, which is why it was inconsistent.
  property bool aIsFront: true
  readonly property Image frontImage: aIsFront ? imgA : imgB
  readonly property Image backImage: aIsFront ? imgB : imgA

  readonly property int fadeDuration: 400

  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }

  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Background
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
  WlrLayershell.namespace: "quickshell-wallpaper"

  color: "black"   // shows through only before the first image decodes

  onTargetChanged: {
    if (target === "") return;
    if (frontImage.source.toString() === target) return;
    backImage.source = target;   // fade starts from onStatusChanged, below
  }

  component Surface: Image {
    anchors.fill: parent
    fillMode: Image.PreserveAspectCrop   // hyprpaper's `fit_mode = cover`
    asynchronous: true
    // Decode at screen resolution rather than the file's native size, so a
    // 20MB 4K PNG does not sit in memory at full resolution.
    sourceSize.width: root.screen ? root.screen.width : 1920
    sourceSize.height: root.screen ? root.screen.height : 1080

    onStatusChanged: {
      // Only the incoming buffer drives the fade, and only once it is fully
      // decoded - so the timing no longer depends on how big the file is.
      if (status === Image.Ready && this === root.backImage) root.beginFade();
    }
  }

  Surface {
    id: imgA
    opacity: 1
    z: root.aIsFront ? 0 : 1
  }

  Surface {
    id: imgB
    opacity: 0
    z: root.aIsFront ? 1 : 0
  }

  function beginFade() {
    fade.target = root.backImage;
    fade.restart();
  }

  NumberAnimation {
    id: fade
    property: "opacity"
    from: 0
    to: 1
    duration: root.fadeDuration
    easing.type: Easing.InOutQuad

    onFinished: {
      // The buffer that just faded in becomes the front. Flipping aIsFront
      // also flips the z bindings, so the old front drops underneath at the
      // same moment its opacity is zeroed - no visible step.
      const outgoing = root.frontImage;
      root.aIsFront = !root.aIsFront;
      outgoing.opacity = 0;
    }
  }

  // First wallpaper of the session: nothing to fade from, so show it directly.
  Component.onCompleted: {
    if (root.target !== "") {
      imgA.source = root.target;
      imgA.opacity = 1;
    }
  }
}
