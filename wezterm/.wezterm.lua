-- Pull in the wezterm API
local wezterm = require('wezterm')
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Front-End
config.front_end = "WebGpu"  -- uses Metal on macOS

config.treat_east_asian_ambiguous_width_as_wide = true
config.keys = {
  {key="k", mods="CMD|SHIFT", action=act.ScrollToPrompt(-1)},
  {key="j", mods="CMD|SHIFT", action=act.ScrollToPrompt(1)},
}

-- Theme
config.color_scheme = 'nord'

-- Return the configuration to wezterm
return config
