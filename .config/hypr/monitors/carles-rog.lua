-- Monitor configuration for carles-rog (ASUS ROG laptop)

-- Built-in display: Sharp Corporation LQ134N1JW54
hl.monitor({ output = "eDP-1", mode = "1920x1200@120", position = "0x0", scale = 1.33 })

-- Workspace assignments for the built-in display
hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true })
for i = 2, 5 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1" })
end

local mainMod = "SUPER"

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { desc = "Switch to workspace " .. i })
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), { desc = "Move window to workspace " .. i })
end
