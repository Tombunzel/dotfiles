-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- Create the configuration object
local config = wezterm.config_builder()

-- Set your preferred color scheme
config.color_scheme = 'astromouse (terminal.sexy)'

-- Enable transparency
config.window_background_opacity = 0.85  -- Adjust opacity (0.0 = fully transparent, 1.0 = fully opaque)
config.macos_window_background_blur = 20

-- Key bindings for splitting panes and closing them
config.keys = {
  -- Split vertically (Ctrl+Shift+Enter)
  {
    key = 'Enter',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- Close the current pane (Ctrl+Shift+W)
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  -- Navigate to the left pane (Ctrl+Shift+H)
  {
    key = 'h',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  -- Navigate to the right pane (Ctrl+Shift+L)
  {
    key = 'l',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  -- Navigate to the upper pane (Ctrl+Shift+K)
  {
    key = 'k',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  -- Navigate to the lower pane (Ctrl+Shift+J)
  {
    key = 'j',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
}

-- Finally, return the configuration to wezterm
return config
