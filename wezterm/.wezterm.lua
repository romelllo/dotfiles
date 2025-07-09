-- Pull in the wezterm API
local wezterm = require('wezterm')

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Define the monochrome color scheme
local mono_colors = {
  -- Default colors
  foreground = '#000000',  -- Pure black text
  background = '#ffffff',  -- Pure white background
  cursor_fg = '#ffffff',   -- White cursor text
  cursor_bg = '#000000',   -- Black cursor background
  cursor_border = '#000000',
  selection_fg = '#ffffff', -- White text for selections
  selection_bg = '#555555', -- Dark gray selection background

  -- Terminal colors (Normal) - various shades of gray
  ansi = {
    '#000000', -- Black
    '#555555', -- Dark Gray
    '#777777', -- Medium Gray
    '#999999', -- Gray
    '#aaaaaa', -- Light Gray
    '#cccccc', -- Very Light Gray
    '#dddddd', -- Almost White
    '#ffffff', -- White
  },

  -- Terminal colors (Bright) - more shades of gray
  brights = {
    '#333333', -- Dark Gray
    '#666666', -- Medium Dark Gray
    '#888888', -- Medium Gray
    '#aaaaaa', -- Gray
    '#bbbbbb', -- Medium Light Gray
    '#dddddd', -- Light Gray
    '#eeeeee', -- Very Light Gray
    '#ffffff', -- White
  },
}

-- Add the scheme to WezTerm's color schemes
config.color_schemes = {
  ['Monochrome'] = mono_colors,
}

-- Set it as the default color scheme
config.color_scheme = 'Monochrome'

-- macOS-like settings
config.window_decorations = 'TITLE | RESIZE'
config.window_padding = {
  left = '1cell',
  right = '1cell',
  top = '0.5cell',
  bottom = '0.5cell',
}
config.font = wezterm.font('Menlo', {weight = 'Regular', italic = false})
config.font_size = 13.5

-- Return the configuration to wezterm
return config
