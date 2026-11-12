-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Front-End
config.front_end = "WebGpu" -- uses Metal on macOS

-- Font
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 12

-- Window decorations
-- config.window_decorations = "RESIZE"

config.treat_east_asian_ambiguous_width_as_wide = false

-- Theme
config.color_scheme = "nord"
-- config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 10

-- CRUK Griffin HPC
-- Griffin panes run the system `ssh griffin`, which shares one ControlMaster connection
-- (see ~/.ssh/config), so only the first connection needs a DUO push.
local griffin_ssh = { "/usr/bin/ssh", "griffin" }

local function is_local_host(host)
	return host == nil or host == "" or host == "localhost" or host == wezterm.hostname()
end

-- If the pane is running ssh to Griffin, return a command that opens a Griffin shell
-- in the same directory (reported by the remote shell via OSC 7, see ~/.bashrc on Griffin)
local function griffin_command(pane)
	local info = pane:get_foreground_process_info()
	if not info or info.name ~= "ssh" then
		return nil
	end
	local to_griffin = false
	for _, arg in ipairs(info.argv) do
		if arg:find("griffin", 1, true) then
			to_griffin = true
		end
	end
	if not to_griffin then
		return nil
	end
	local cwd = pane:get_current_working_dir()
	if cwd and not is_local_host(cwd.host) then
		local dir = "'" .. (cwd.file_path:gsub("'", "'\\''")) .. "'"
		return { "/usr/bin/ssh", "-t", "griffin", "cd " .. dir .. " 2>/dev/null; exec bash -l" }
	end
	return griffin_ssh
end

-- Split Griffin panes into new Griffin shells, everything else as usual
local function split(direction)
	return wezterm.action_callback(function(window, pane)
		local args = griffin_command(pane)
		local command = args and { args = args } or { domain = "CurrentPaneDomain" }
		window:perform_action(act.SplitPane({ direction = direction, command = command }), pane)
	end)
end

config.keys = {
	{ key = "k", mods = "CMD|SHIFT", action = act.ScrollToPrompt(-1) },
	{ key = "j", mods = "CMD|SHIFT", action = act.ScrollToPrompt(1) },
	{ key = "g", mods = "CMD|SHIFT", action = act.SpawnCommandInNewTab({ args = griffin_ssh }) },
	{ key = "d", mods = "CMD", action = split("Right") },
	{ key = "d", mods = "CMD|SHIFT", action = split("Down") },
}

for i = 1, 8 do
	-- CTRL+ALT + number to move to that position
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CTRL|ALT",
		action = wezterm.action.MoveTab(i - 1),
	})
end

-- Return the configuration to wezterm
return config
