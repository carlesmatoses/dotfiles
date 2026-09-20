import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

// One notification, shared by the toast stack and the history panel.
// Geometry follows .config/mako/config (width 350, border 2, radius 8,
// padding 10); colors come from Theme so they follow pywal.
Rectangle {
  id: root

  property var notification: null
  // Toasts show a close button and run an expiry timer; history rows do not.
  property bool popup: false

  readonly property bool critical:
    notification && notification.urgency === NotificationUrgency.Critical
  readonly property bool low:
    notification && notification.urgency === NotificationUrgency.Low

  implicitWidth: 350
  implicitHeight: layout.implicitHeight + 20   // padding: 10

  color: Qt.alpha(Theme.backgroundDark, Theme.panelAlpha)
  radius: 8
  border.width: 2
  // mako's `[urgency=high] border-color` was a distinct accent; use the
  // critical red so it reads as urgent against any wallpaper.
  border.color: critical ? Theme.critical : Theme.accent

  ColumnLayout {
    id: layout
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.margins: 10
    spacing: 6

    // Header: app icon, app name, close.
    RowLayout {
      Layout.fillWidth: true
      spacing: 6

      IconImage {
        implicitSize: 16
        visible: source !== ""
        source: root.notification && root.notification.appIcon
          ? Quickshell.iconPath(root.notification.appIcon, true)
          : ""
      }

      Text {
        Layout.fillWidth: true
        text: root.notification ? root.notification.appName : ""
        color: Theme.textColor3
        font.family: Theme.fontFamily
        font.pixelSize: 11
        elide: Text.ElideRight
      }

      Text {
        visible: root.popup
        text: "\uf00d"   // nf-fa-times
        color: Theme.textColor3
        font.family: Theme.fontFamily
        font.pixelSize: 12

        MouseArea {
          anchors.fill: parent
          anchors.margins: -4
          cursorShape: Qt.PointingHandCursor
          onClicked: NotificationService.dismiss(root.notification)
        }
      }
    }

    // Body: image on the left when the sender provided one.
    RowLayout {
      Layout.fillWidth: true
      spacing: 8

      Image {
        Layout.alignment: Qt.AlignTop
        // Image.implicitWidth/Height are read-only, so the box is sized
        // through the layout instead.
        Layout.preferredWidth: visible ? 48 : 0
        Layout.preferredHeight: visible ? 48 : 0
        visible: source !== ""
        source: root.notification && root.notification.image
          ? root.notification.image : ""
        sourceSize.width: 48
        sourceSize.height: 48
        fillMode: Image.PreserveAspectCrop
      }

      ColumnLayout {
        Layout.fillWidth: true
        spacing: 2

        Text {
          Layout.fillWidth: true
          text: root.notification ? root.notification.summary : ""
          color: root.low ? Theme.textColor3 : Theme.textColor1
          font.family: Theme.fontFamily
          font.pixelSize: 13
          font.bold: true
          wrapMode: Text.WordWrap
          maximumLineCount: 2
          elide: Text.ElideRight
        }

        Text {
          Layout.fillWidth: true
          visible: text !== ""
          text: root.notification ? root.notification.body : ""
          color: root.low ? Theme.textColor3 : Theme.textColor2
          font.family: Theme.fontFamily
          font.pixelSize: 12
          wrapMode: Text.WordWrap
          maximumLineCount: 6
          elide: Text.ElideRight
          // bodyMarkupSupported is advertised, so senders may use the
          // spec's small HTML subset (<b> <i> <u> <a>).
          textFormat: Text.StyledText
          onLinkActivated: link => Sh.run("xdg-open " + JSON.stringify(link))
        }
      }
    }

    // Action buttons.
    Flow {
      Layout.fillWidth: true
      spacing: 6
      visible: root.notification && root.notification.actions.length > 0

      Repeater {
        model: root.notification ? root.notification.actions : []

        delegate: Rectangle {
          required property var modelData

          radius: 4
          color: actionMouse.containsMouse ? Theme.accent : Theme.backgroundLight
          implicitWidth: actionText.implicitWidth + 16
          implicitHeight: actionText.implicitHeight + 8

          Text {
            id: actionText
            anchors.centerIn: parent
            text: parent.modelData.text
            color: Theme.textColor1
            font.family: Theme.fontFamily
            font.pixelSize: 11
          }

          MouseArea {
            id: actionMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              parent.modelData.invoke();
              NotificationService.hidePopup(root.notification.id);
            }
          }
        }
      }
    }

    // Inline reply, for senders that advertise it.
    Rectangle {
      Layout.fillWidth: true
      visible: root.notification && root.notification.hasInlineReply
      implicitHeight: 28
      radius: 4
      color: Theme.backgroundLight

      TextInput {
        id: reply
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        verticalAlignment: TextInput.AlignVCenter
        color: Theme.textColor1
        font.family: Theme.fontFamily
        font.pixelSize: 12
        selectByMouse: true

        onAccepted: {
          if (text === "") return;
          root.notification.sendInlineReply(text);
          text = "";
          NotificationService.hidePopup(root.notification.id);
        }
      }

      Text {
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        visible: reply.text === "" && !reply.activeFocus
        text: root.notification && root.notification.inlineReplyPlaceholder
          ? root.notification.inlineReplyPlaceholder : "Reply..."
        color: Theme.textColor3
        font.family: Theme.fontFamily
        font.pixelSize: 12
      }
    }
  }

  // Toast expiry. Critical never auto-expires (timeout 0), matching mako's
  // `[urgency=high] default-timeout=0`.
  Timer {
    running: root.popup && interval > 0
    interval: root.notification ? NotificationService.timeoutFor(root.notification) : 0
    onTriggered: NotificationService.expirePopup(root.notification)
  }
}
