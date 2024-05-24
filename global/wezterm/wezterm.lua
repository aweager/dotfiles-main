local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Colors
-- TODO
wezterm.color_scheme = "VSCodeDark+ (Gogh)"

-- Key mappings
local function mapCmdToMeta()
    local keys = "abdefghijklmnopqrstuwxyz-=1234567890[]\\;',./`" -- no c,v
    local keymappings = {}

    for i = 1, #keys do
        local c = keys:sub(i, i)
        table.insert(keymappings, {
            key = c,
            mods = "CMD",
            action = wezterm.action.SendKey({
                key = c,
                mods = "META",
            }),
        })
        table.insert(keymappings, {
            key = c,
            mods = "CMD|CTRL",
            action = wezterm.action.SendKey({
                key = c,
                mods = "META|CTRL",
            }),
        })
        table.insert(keymappings, {
            key = c,
            mods = "CMD|SHIFT",
            action = wezterm.action.SendKey({
                key = c,
                mods = "META|SHIFT",
            }),
        })
        table.insert(keymappings, {
            key = c,
            mods = "CMD|CTRL|SHIFT",
            action = wezterm.action.SendKey({
                key = c,
                mods = "META|CTRL|SHIFT",
            }),
        })
    end
    return keymappings
end

config.keys = mapCmdToMeta()

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

-- Multiplexer
config.enable_tab_bar = false

-- Terminfo
-- config.term = "wezterm"

return config
