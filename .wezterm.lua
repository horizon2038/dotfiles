local wezterm = require 'wezterm'
local act = wezterm.action;

-- config
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- theme settings
-- opacity horizon's default = 0.4 (both)
config.window_background_opacity = 0.4
config.text_background_opacity = 0.4
config.macos_window_background_blur = 5
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
--config.color_scheme = 'Catppuccin Frappe'
config.color_scheme = 'iceberg-dark'
-- config.window_background_image = '/Users/horizon/Pictures/Wallpapers/deadmau5-eating-cheese.jpg'
config.window_background_image_hsb = {
    brightness = 0.4
}

-- font settings
config.font = wezterm.font("Roboto Mono for Powerline", {weight="Regular", stretch="Normal", style="Normal"})
config.font_size = 12

-- key settings
config.send_composed_key_when_left_alt_is_pressed = true

config.mouse_bindings = {
    -- Change the default click behavior so that it only selects
    -- text and doesn't open hyperlinks
    {
      event={Up={streak=1, button="Left"}},
      mods="NONE",
      action=act.CompleteSelection("PrimarySelection"),
    },

    -- and make CTRL-Click open hyperlinks
    {
      event={Up={streak=1, button="Left"}},
      mods="CTRL",
      action=act.OpenLinkAtMouseCursor,
    },

    -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
    {
      event = { Down = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.Nop,
    }
  }

return config
