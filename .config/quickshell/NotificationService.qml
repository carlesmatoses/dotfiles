pragma Singleton

import Quickshell
import Quickshell.Services.Notifications
import QtQuick

// The notification daemon, replacing dunst/mako.
//
// Named NotificationService rather than Notifications so it does not collide
// with the Quickshell.Services.Notifications module import.
//
// Quickshell discards a notification as soon as the `notification` signal
// returns unless `tracked` is set true. History therefore means holding
// `tracked` true until the user clears it, which makes "currently showing as
// a toast" a separate concept - hence popupIds alongside the server's
// trackedNotifications.
Singleton {
  id: root

  // mako's `default-timeout=5000`, used when the sender does not set one.
  readonly property int defaultTimeout: 5000
  readonly property int historyLimit: 100

  // Ids currently displayed as toasts, newest last.
  property var popupIds: []
  // Bumped whenever popupIds is mutated, so bindings re-evaluate.
  property int popupRevision: 0

  // Notifications that arrived since the center was last opened.
  property int unreadCount: 0

  readonly property var history: {
    const all = [];
    const tracked = server.trackedNotifications.values;
    for (let i = 0; i < tracked.length; i++) {
      // `transient` means "show it, but do not persist it", per the spec.
      if (tracked[i].transient) continue;
      all.push(tracked[i]);
    }
    all.sort((a, b) => b.id - a.id);   // newest first
    return all.slice(0, root.historyLimit);
  }

  readonly property var popups: {
    root.popupRevision;   // dependency
    const ids = root.popupIds;
    const out = [];
    const all = server.trackedNotifications.values;
    for (let i = 0; i < ids.length; i++)
      for (let j = 0; j < all.length; j++)
        if (all[j].id === ids[i]) { out.push(all[j]); break; }
    return out;
  }

  NotificationServer {
    id: server

    keepOnReload: true

    bodySupported: true
    bodyMarkupSupported: true
    bodyImagesSupported: true
    actionsSupported: true
    actionIconsSupported: true
    imageSupported: true
    inlineReplySupported: true
    persistenceSupported: true   // we keep history

    onNotification: notification => {
      // Without this the notification is destroyed immediately.
      notification.tracked = true;

      root.showPopup(notification.id);
      if (!notification.transient) root.unreadCount++;
    }
  }

  function showPopup(id) {
    const ids = root.popupIds.slice();
    if (ids.indexOf(id) < 0) ids.push(id);
    root.popupIds = ids;
    root.popupRevision++;
  }

  function hidePopup(id) {
    const ids = root.popupIds.slice();
    const i = ids.indexOf(id);
    if (i < 0) return;
    ids.splice(i, 1);
    root.popupIds = ids;
    root.popupRevision++;
  }

  // How long a toast stays up. Critical never auto-expires, matching mako's
  // `[urgency=high] default-timeout=0`.
  function timeoutFor(notification) {
    if (notification.urgency === NotificationUrgency.Critical) return 0;
    if (notification.expireTimeout > 0) return notification.expireTimeout;
    return root.defaultTimeout;
  }

  // A toast timed out. Normally it just stops showing and stays in history;
  // a transient one is never in history, so it has to be released here or it
  // would stay tracked forever.
  function expirePopup(notification) {
    root.hidePopup(notification.id);
    if (notification.transient) notification.expire();
  }

  // Drop it entirely - toast and history.
  function dismiss(notification) {
    root.hidePopup(notification.id);
    notification.dismiss();
  }

  function clearHistory() {
    const all = root.history;
    for (let i = 0; i < all.length; i++) {
      root.hidePopup(all[i].id);
      all[i].dismiss();
    }
    root.unreadCount = 0;
  }

  function markRead() {
    root.unreadCount = 0;
  }
}
