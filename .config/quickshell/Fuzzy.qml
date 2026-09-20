pragma Singleton

import Quickshell

// Scoring for the app launcher's search field.
//
// rofi's drun does case-insensitive substring matching on the name only. This
// keeps that behaviour at the top of the ranking and then falls through to
// looser matches, so "fox" still finds Firefox and "calc" finds a calculator
// via its Keywords= line.
//
// score() returns a number where higher is better, or -1 for no match.
// An empty query matches everything with score 0.
Singleton {
  id: root

  readonly property string wordSeparators: " -_./"

  function score(query, entry) {
    const q = query.trim().toLowerCase();
    if (q === "") return 0;

    const name = (entry.name || "").toLowerCase();

    // Name matches, best first. The small length penalty on a prefix hit
    // breaks ties towards the shorter name ("Files" over "Files Extra").
    if (name === q) return 1000;
    if (name.indexOf(q) === 0) return 900 - Math.min(name.length, 99) * 0.5;

    const wordHit = root.wordStartIndex(name, q);
    if (wordHit >= 0) return 800 - wordHit;

    const idx = name.indexOf(q);
    if (idx >= 0) return 700 - idx;

    if (root.initialsMatch(name, q)) return 650;

    const sub = root.subsequenceScore(name, q);
    if (sub >= 0) return 400 + sub;

    // Secondary fields, all weighted below any name match.
    const generic = (entry.genericName || "").toLowerCase();
    if (generic.indexOf(q) >= 0) return 300;

    if (root.keywordText(entry).indexOf(q) >= 0) return 200;

    const comment = (entry.comment || "").toLowerCase();
    if (comment.indexOf(q) >= 0) return 100;

    return -1;
  }

  // Index of `q` where it starts a word, e.g. "dev" in "Firefox Developer".
  function wordStartIndex(text, q) {
    let from = 0;
    for (;;) {
      const i = text.indexOf(q, from);
      if (i < 0) return -1;
      if (i === 0 || root.wordSeparators.indexOf(text.charAt(i - 1)) >= 0) return i;
      from = i + 1;
    }
  }

  // "fde" -> "Firefox Developer Edition". Two chars minimum, or almost
  // everything would match on a single letter.
  function initialsMatch(text, q) {
    if (q.length < 2) return false;
    const words = text.split(/[\s\-_.\/]+/);
    let initials = "";
    for (let i = 0; i < words.length; i++)
      if (words[i].length > 0) initials += words[i].charAt(0);
    return initials.indexOf(q) === 0;
  }

  // Characters of `q` appearing in order, gaps penalised. 0-100, -1 if the
  // characters do not all appear in order.
  function subsequenceScore(text, q) {
    let from = 0;
    let gaps = 0;
    let last = -1;
    for (let i = 0; i < q.length; i++) {
      const found = text.indexOf(q.charAt(i), from);
      if (found < 0) return -1;
      if (last >= 0) gaps += found - last - 1;
      last = found;
      from = found + 1;
    }
    return Math.max(0, 100 - gaps);
  }

  // DesktopEntry.keywords is a string list; tolerate a plain string too.
  function keywordText(entry) {
    const k = entry.keywords;
    if (!k) return "";
    if (Array.isArray(k)) return k.join(" ").toLowerCase();
    return String(k).toLowerCase();
  }
}
