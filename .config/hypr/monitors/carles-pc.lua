-- Monitor configuration for carles-pc (Desktop)

-- Primary monitor - HDMI-A-1
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "0x0", scale = 1 })

-- Secondary monitor - DP-1
hl.monitor({ output = "DP-1", mode = "1920x1080@74.97300", position = "1920x0", scale = 1 })

---------------
--- TABLETS ---
---------------

-- Wacom Intuos S - map pen to secondary monitor (DP-1) instead of spanning both
hl.device({ name = "wacom-intuos-s-pen", output = "DP-1" })

------------------
--- WORKSPACES ---
------------------

-- Assign workspaces 1-5 to primary monitor (HDMI-A-1), 6-10 to secondary (DP-1)
for i = 1, 5 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1" })
    hl.workspace_rule({ workspace = tostring(i + 5), monitor = "DP-1" })
end

local mainMod = "SUPER"

-- Switch workspaces with mainMod + [1-5] (activates paired workspaces on both monitors)
for i = 1, 5 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.exec_cmd("~/.config/hypr/scripts/switch-workspaces.sh " .. i .. " " .. i + 5), { desc = "Switch to workspaces " .. i .. " and " .. i + 5 })
end

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), { desc = "Move window to workspace " .. i })
end
