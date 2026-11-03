-------------------
--- KEYBINDINGS ---
-------------------

-- See https://wiki.hypr.land/configuring/core/binds/
-- The Quickshell cheatsheet (.config/quickshell/Keybinds.qml) lists these from
-- `hyprctl binds -j`, so every bind needs a desc.
local mainMod = "SUPER" -- Sets "Windows" key as main modifier

local terminal = "kitty"
local fileManager = "dolphin"

local function bind(keys, dispatcher, desc, opts)
    opts = opts or {}
    opts.desc = desc
    hl.bind(keys, dispatcher, opts)
end

bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal), "Open terminal")
bind(mainMod .. " + C", hl.dsp.window.close(), "Close window")
bind(mainMod .. " + M", hl.dsp.exit(), "Exit Hyprland")
bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager), "Open file manager")
bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }), "Toggle floating")
bind("SUPER + V", hl.dsp.exec_cmd("kitty --class clipse -e clipse"), "Clipboard history")
-- App launcher: Quickshell widget (see .config/quickshell/Launcher.qml)
bind(mainMod .. " + space", hl.dsp.global("quickshell:launcher"), "Application launcher")
-- Power menu: Quickshell widget (see .config/quickshell/PowerMenu.qml)
bind(mainMod .. " + P", hl.dsp.global("quickshell:powermenu"), "Power menu")
bind(mainMod .. " + SHIFT + Return", hl.dsp.window.fullscreen(), "Toggle fullscreen")
bind(mainMod .. " + T", hl.dsp.layout("togglesplit"), "Toggle split") -- dwindle

-- Move focus with mainMod + hjkl
-- Swap windows with mainMod + SHIFT + hjkl
for key, direction in pairs({ h = "left", l = "right", k = "up", j = "down" }) do
    bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = direction }), "Focus " .. direction)
    bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.swap({ direction = direction }), "Swap window " .. direction)
end

-- Example special workspace (scratchpad)
bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"), "Toggle scratchpad")
bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }), "Move window to scratchpad")

-- Scroll through existing workspaces with mainMod + scroll
bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), "Next workspace")
bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), "Previous workspace")

-- Move/resize windows with mainMod + LMB/RMB and dragging
bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), "Move window", { mouse = true })
bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), "Resize window", { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
local held = function() return { locked = true, repeating = true } end
bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), "Volume up", held())
bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), "Volume down", held())
bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), "Mute audio", held())
bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), "Mute microphone", held())
bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 set 5%+"), "Brightness up", held())
bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 set 5%-"), "Brightness down", held())

-- Requires playerctl
bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), "Next track", { locked = true })
bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), "Play/pause", { locked = true })
bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), "Play/pause", { locked = true })
bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), "Previous track", { locked = true })

-- Custom keybindings
-- Keybinds cheatsheet: Quickshell widget (see .config/quickshell/Keybinds.qml)
bind(mainMod .. " + period", hl.dsp.global("quickshell:keybinds"), "Keybinds cheatsheet")
bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/wallpapers.sh"), "Random wallpaper")
-- Wallpaper picker: Quickshell widget (see .config/quickshell/WallpaperPicker.qml)
bind(mainMod .. " + W", hl.dsp.global("quickshell:wallpapers"), "Wallpaper picker")
-- Emoji picker: Quickshell widget (see .config/quickshell/EmojiPicker.qml)
bind(mainMod .. " + comma", hl.dsp.global("quickshell:emoji"), "Emoji picker")
bind(mainMod .. " + A", hl.dsp.exec_cmd("firefox --new-window 'https://aroundsk.online'"), "Open aroundsk.online")

-- Screenshots
bind(mainMod .. " + Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]), "Screenshot selection to clipboard")
bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd("grim - | wl-copy"), "Screenshot full screen to clipboard")
bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | tee ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png | wl-copy]]), "Screenshot selection to file and clipboard")
bind(mainMod .. " + ALT + P", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot-window.sh"), "Screenshot a window to file and clipboard")

-- Screen recording
bind(mainMod .. " + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenrecord.sh"), "Toggle full-screen recording")
bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenrecord.sh region"), "Toggle region recording")
