-- Pull in the wezterm API
local wezterm = require('wezterm')

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Theme
config.color_scheme = 'Solarized Dark (Gogh)'

-- Return the configuration to wezterm
return config
