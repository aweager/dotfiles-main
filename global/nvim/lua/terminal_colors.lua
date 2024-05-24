-- TODO: unify this list somehow with wezterm, which is where i got it from
local colors = {
    "#000000",
    "#cc5555",
    "#55cc55",
    "#cdcd55",
    "#5455cb",
    "#cc55cc",
    "#7acaca",
    "#cccccc",

    "#555555",
    "#ff5555",
    "#55ff55",
    "#ffff55",
    "#5555ff",
    "#ff55ff",
    "#55ffff",
    "#ffffff",
}

for index, color in pairs(colors) do
    vim.g["terminal_color_" .. (index - 1)] = color
end
