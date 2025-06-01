-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- macOS color scheme for WezTerm
local wezterm = require('wezterm')

-- Define the color scheme
local macos_colors = {
  -- Default colors
  foreground = '#000000',
  background = '#ffffff',
  cursor_fg = '#ffffff',
  cursor_bg = '#000000',
  cursor_border = '#000000',
  selection_fg = '#ffffff',
  selection_bg = '#4d90fe',

  -- Terminal colors (Normal)
  ansi = {
    '#000000', -- Black
    '#c23621', -- Red
    '#25bc24', -- Green
    '#adad27', -- Yellow
    '#492ee1', -- Blue
    '#d338d3', -- Magenta
    '#33bbc8', -- Cyan
    '#cbcccd', -- White
  },

  -- Terminal colors (Bright)
  brights = {
    '#686a66', -- Bright Black
    '#fc391f', -- Bright Red
    '#31e722', -- Bright Green
    '#eaec23', -- Bright Yellow
    '#5833ff', -- Bright Blue
    '#f935f8', -- Bright Magenta
    '#14f0f0', -- Bright Cyan
    '#e9ebeb', -- Bright White
  },
}

-- Add the scheme to WezTerm's color schemes
config = {
  color_schemes = {
    ['macOS'] = macos_colors,
  },
  
  -- Set it as the default color scheme
  color_scheme = 'macOS',
  
  -- Additional settings to make it more macOS-like
  window_decorations = 'TITLE | RESIZE',
  window_padding = {
    left = '1cell',
    right = '1cell',
    top = '0.5cell',
    bottom = '0.5cell',
  },
  font = wezterm.font('Menlo', {weight = 'Regular', italic = false}),
  font_size = 12.0,
}

-- Font size 
config.font_size = 13.5

-- and finally, return the configuration to wezterm
return config
