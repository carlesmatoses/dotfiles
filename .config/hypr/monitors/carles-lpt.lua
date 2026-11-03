-- Monitor configuration for carles-lpt (Laptop)

-- Built-in laptop display (adjust resolution as needed)
-- Uncomment and adjust when you know your laptop's monitor name:
-- hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1 })

-- External monitor example (if you use one)
-- hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "1920x0", scale = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- Workspace assignments for laptop
-- hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true })
-- hl.workspace_rule({ workspace = "2", monitor = "eDP-1" })

local mainMod = "SUPER"

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { desc = "Switch to workspace " .. i })
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), { desc = "Move window to workspace " .. i })
end
