#!/usr/bin/env bash

# Rofi wallpaper browser: shows a thumbnail grid of every downloaded wallpaper.
#   Enter   -> set that wallpaper (calls wallpapers.sh, does not touch random pick)
#   Alt+d   -> delete the image and its matching line in urls.txt
#   Alt+a   -> prompt for a URL, download it, and append it to urls.txt

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
URLS_FILE="$WALLPAPER_DIR/urls.txt"
APPLY_SCRIPT="$HOME/.config/hypr/scripts/wallpapers.sh"

# Gallery layout: window is a fixed 80% width x 90% height of the screen.
# ICON_W/ICON_H are the only size knobs - each thumbnail lives in a fixed
# ICON_W x ICON_H box and is scaled to fit inside it without distortion
# (letterboxed if its aspect ratio doesn't match). COLUMNS/ROWS are computed
# below from the focused monitor's real resolution so exactly as many cells as
# fit the 80% x 90% area are shown - however many that is for this screen.
ICON_W=200
ICON_H=120

read -r MON_W MON_H MON_SCALE < <(hyprctl monitors | awk '
    /^Monitor/ { w=""; h=""; s="" }
    /^\t[0-9]+x[0-9]+@/ { split($1, a, "x"); w=a[1]; split(a[2], b, "@"); h=b[1] }
    /scale:/ { s=$2 }
    /focused: yes/ { print w, h, s; exit }
')
MON_SCALE=${MON_SCALE:-1}

read -r COLUMNS ROWS <<< "$(awk -v mw="$MON_W" -v mh="$MON_H" -v sc="$MON_SCALE" -v iw="$ICON_W" -v ih="$ICON_H" 'BEGIN {
    avail_w = (mw / sc) * 0.80
    avail_h = (mh / sc) * 0.90
    cols = int(avail_w / iw); if (cols < 1) cols = 1
    lines = int(avail_h / ih); if (lines < 1) lines = 1
    print cols, lines
}')"

GRID_THEME='
window {width: 80%; height: 90%; location: center; border-radius: 12px; padding: 0px;}
listview {columns: '"$COLUMNS"'; lines: '"$ROWS"'; spacing: 0px; fixed-columns: true;}
element {orientation: vertical; padding: 0px;}
element-icon {size: '"$ICON_W"'px; width: '"$ICON_W"'px; height: '"$ICON_H"'px; horizontal-align: 0.5; vertical-align: 0.5;}
element-text {enabled: false;}
'

while true; do
    mapfile -t FILES < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) \
        -printf "%f\n" | sort)

    if [ ${#FILES[@]} -eq 0 ]; then
        notify-send "Wallpapers" "No wallpapers found in $WALLPAPER_DIR"
        exit 0
    fi

    SELECTED=$(
        for f in "${FILES[@]}"; do
            printf '%s\0icon\x1f%s\n' "$f" "$WALLPAPER_DIR/$f"
        done | rofi -dmenu -i -p "Wallpaper (Enter: set  ·  Alt+d: delete  ·  Alt+a: add url)" \
            -show-icons \
            -kb-custom-1 "Alt+d" \
            -kb-custom-2 "Alt+a" \
            -theme-str "$GRID_THEME"
    )
    CODE=$?

    [ -z "$SELECTED" ] && break

    case $CODE in
        10)
            # Alt+d: delete the image and its matching urls.txt entry
            rm -f "$WALLPAPER_DIR/$SELECTED"
            if [ -f "$URLS_FILE" ]; then
                grep -vF "/$SELECTED" "$URLS_FILE" > "$URLS_FILE.tmp" && mv "$URLS_FILE.tmp" "$URLS_FILE"
            fi
            notify-send "Wallpapers" "Removed $SELECTED"
            ;;
        11)
            # Alt+a: prompt for a URL, download it, and append it to urls.txt
            NEW_URL=$(printf "" | rofi -dmenu -p "Add wallpaper URL" -theme-str 'window {width: 40%;}')
            if [ -n "$NEW_URL" ]; then
                # Strip any query string/fragment so the saved filename is clean
                # (e.g. Reddit preview links end in "?width=...&s=<hash>")
                CLEAN_URL="${NEW_URL%%#*}"
                CLEAN_URL="${CLEAN_URL%%\?*}"
                CLEAN_NAME=$(basename "$CLEAN_URL")

                if grep -qxF "$NEW_URL" "$URLS_FILE" 2>/dev/null; then
                    notify-send "Wallpapers" "URL already in the list"
                elif [ -e "$WALLPAPER_DIR/$CLEAN_NAME" ]; then
                    notify-send "Wallpapers" "$CLEAN_NAME already downloaded"
                elif wget -q --timeout=15 -t 2 -O "$WALLPAPER_DIR/$CLEAN_NAME" "$NEW_URL"; then
                    # urls.txt's last line may not end in a newline - fix that before appending
                    [ -s "$URLS_FILE" ] && [ -n "$(tail -c1 "$URLS_FILE")" ] && echo >> "$URLS_FILE"
                    echo "$NEW_URL" >> "$URLS_FILE"
                    notify-send "Wallpapers" "Added $CLEAN_NAME"
                else
                    rm -f "$WALLPAPER_DIR/$CLEAN_NAME"
                    notify-send "Wallpapers" "Failed to download $NEW_URL"
                fi
            fi
            ;;
        0)
            # Enter: apply the selected wallpaper
            "$APPLY_SCRIPT" "$WALLPAPER_DIR/$SELECTED"
            break
            ;;
        *)
            break
            ;;
    esac
done
