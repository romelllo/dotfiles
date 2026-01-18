-- Pull in the wezterm API
local wezterm = require('wezterm')
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Front-End
config.front_end = "WebGpu"  -- uses Metal on macOS

-- Font
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 12

-- Window decorations
config.window_decorations = "RESIZE"

config.treat_east_asian_ambiguous_width_as_wide = true
config.keys = {
  {key="k", mods="CMD|SHIFT", action=act.ScrollToPrompt(-1)},
  {key="j", mods="CMD|SHIFT", action=act.ScrollToPrompt(1)},
}

-- Theme
config.color_scheme = 'Everforest Dark (Gogh)'
-- config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 10

-- Return the configuration to wezterm
return config
