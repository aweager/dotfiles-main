local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Colors and appearance
local colors = wezterm.color.get_default_colors()
colors.cursor_bg = "grey"
colors.cursor_border = "grey"
config.colors = colors

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

wezterm.on("window-focus-changed", function(window, pane)
    local overrides = window:get_config_overrides() or {}
    if window:is_focused() then
        overrides.foreground_text_hsb = nil
    else
        overrides.foreground_text_hsb = {
            hue = 1.0,
            saturation = 1.0,
            brightness = 0.5,
        }
    end
    window:set_config_overrides(overrides)
end)

-- Key bindings
local function mapCmdToMeta(other_mods)
    local keys = "abcdefghijklmnopqrstuvwxyz1234567890-=[]\\;',./`"
    local bindings = {}

    for i = 1, #keys do
        local c = keys:sub(i, i)
        bindings[c] = wezterm.action.SendKey({
            key = c,
            mods = "META" .. other_mods,
        })
    end
    return bindings
end

local mods = {
    cmd = "CMD",
    cmd_shift = "CMD|SHIFT",
    cmd_ctrl_shift = "CMD|CTRL|SHIFT",
    cmd_ctrl = "CMD|CTRL",
}

local key_bindings = {
    [mods.cmd] = mapCmdToMeta(""),
    [mods.cmd_shift] = mapCmdToMeta("|SHIFT"),
    [mods.cmd_ctrl_shift] = mapCmdToMeta("|CTRL|SHIFT"),
    [mods.cmd_ctrl] = mapCmdToMeta("|CTRL"),
}

key_bindings[mods.cmd]["="] = wezterm.action.ActivateTabRelative(1)
key_bindings[mods.cmd_shift]["="] = wezterm.action.SpawnTab("CurrentPaneDomain")
key_bindings[mods.cmd_shift]["-"] = wezterm.action.CloseCurrentTab({ confirm = true })
key_bindings[mods.cmd].v = wezterm.action.PasteFrom("Clipboard")
key_bindings[mods.cmd].q = wezterm.action.QuitApplication
key_bindings[mods.cmd].UpArrow = wezterm.action.IncreaseFontSize
key_bindings[mods.cmd].DownArrow = wezterm.action.DecreaseFontSize
key_bindings[mods.cmd_ctrl_shift].r = wezterm.action.ReloadConfiguration

config.keys = {}
for modifier, bindings in pairs(key_bindings) do
    for key, action in pairs(bindings) do
        table.insert(config.keys, {
            key = key,
            mods = modifier,
            action = action,
        })
    end
end

-- Font
config.font = wezterm.font({
    family = "JetBrains Mono",
})

config.font_size = 21.0
config.bold_brightens_ansi_colors = "No"

local function noop(dict) end

local font_matchers = {
    italic = {
        [false] = noop,
        [true] = function(dict)
            dict.style = "Italic"
        end,
    },
    intensity = {
        ["Normal"] = noop,
        ["Bold"] = function(dict)
            dict.weight = "Bold"
        end,
        ["Half"] = function(dict)
            dict.weight = "Light"
        end,
    },
}

local function shallow_copy(dict)
    local ret = {}
    for k, v in pairs(dict) do
        ret[k] = v
    end
    return ret
end

local function all_combos(dict)
    local tuples = { {} }
    -- for each field
    for field, values in pairs(dict) do
        local new_tuples = {}
        -- for each value that field can take
        for value, _ in pairs(values) do
            -- duplicate tuples with field = value
            for _, tuple in pairs(tuples) do
                local new_tuple = shallow_copy(tuple)
                new_tuple[field] = value
                table.insert(new_tuples, new_tuple)
            end
        end
        tuples = new_tuples
    end
    return tuples
end

local font_rules = {}
for _, matcher in pairs(all_combos(font_matchers)) do
    local rule = {}
    local font_config = {
        family = "JetBrains Mono",
    }
    for field, value in pairs(matcher) do
        rule[field] = value
        font_matchers[field][value](font_config)
    end
    rule.font = wezterm.font_with_fallback({
        font_config,
    })
    table.insert(font_rules, rule)
end

config.font_rules = font_rules
config.freetype_load_flags = "NO_HINTING"
config.freetype_load_target = "Light"

-- Multiplexer
config.enable_tab_bar = false

-- Terminfo
config.term = "wezterm"

return config
