local wezterm = require 'wezterm'
local act = wezterm.action;

-- config
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- theme settings
-- opacity horizon's default = 0.4 (both)
config.window_background_opacity = 0.8
config.text_background_opacity = 1
-- default blur = 30
config.macos_window_background_blur =  0
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

-- toggle opacity/blur callback

-- local toggle_opacity = wezterm.action_callback(function(window, pane)
--     local overrides = window:get_config_overrides() or {}
--     local effective = overrides.window_background_opacity or window::effective_config().window_background_opacity
--     local new_opacity = (effective == 0.6) and 0.8 or 0.6
--     overrides.window_background_opacity = new_opacity
--     window::set_config_overrides(overrides)
-- end)


--config.color_scheme = 'Catppuccin Frappe'
config.color_scheme = 'iceberg-dark'
-- config.window_background_image = '/Users/horizon/Pictures/Wallpapers/nono_valentine.jpg'
config.window_background_image_hsb = {
    brightness = 0.4
}
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_frame = {
    inactive_titlebar_bg = "none",
    active_titlebar_bg = "none",
}
config.use_fancy_tab_bar = false

config.use_ime = true

-- font settings
-- config.font = wezterm.font("Roboto Mono for Powerline", {weight="Regular", stretch="Normal", style="Normal"})
config.font = wezterm.font_with_fallback({
    { family = "FiraCode Nerd Font" },
    { family = "Roboto Mono for Powerline" },
    { family = "Hiragino Kaku Gothic ProN" },
})
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
