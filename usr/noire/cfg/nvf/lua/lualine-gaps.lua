local theme_name = vim.g.colors_name;
local _, theme_module = pcall(function()
    return require(theme_name);
end);


local colors = theme_module[theme_name] or
    {
        base00 = "#161616",
        base01 = "#262626",
        base02 = "#393939",
        base03 = "#525252",
        base04 = "#d0d0d0",
        base05 = "#f2f2f2",
        base06 = "#ffffff",
        base07 = "#08bdba",
        base08 = "#3ddbd9",
        base09 = "#78a9ff",
        base10 = "#ee5396",
        base11 = "#33b1ff",
        base12 = "#ff7eb6",
        base13 = "#42be65",
        base14 = "#be95ff",
        base15 = "#82cfff",
        blend = "#131313",
        none = "NONE",

        red = '#ca1243',
        grey = '#a0a1a7',
        black = '#383a42',
        white = '#f3f3f3',
        light_green = '#83a598',
        orange = '#fe8019',
        green = '#8ec07c',
    };


local theme = {
    normal = {
        a = { fg = colors.white, bg = colors.base01 },
        b = { fg = colors.white, bg = colors.base03 },
        c = { fg = colors.black, bg = colors.blend },
        z = { fg = colors.white, bg = colors.base01 },
    },
    insert = { a = { fg = colors.base01, bg = colors.light_green } },
    visual = { a = { fg = colors.base01, bg = colors.orange } },
    replace = { a = { fg = colors.base01, bg = colors.green } },
}

local empty = require('lualine.component'):extend()
function empty:draw(default_highlight)
    self.status = ''
    self.applied_separator = ''
    self:apply_highlights(default_highlight)
    self:apply_section_separators()
    return self.status
end

-- Put proper separators and gaps between components in sections
local function process_sections(sections)
    for name, section in pairs(sections) do
        local left = name:sub(9, 10) < 'x'
        for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
            table.insert(section, pos * 2, { empty, color = { fg = colors.blend, bg = colors.blend } })
        end
        for id, comp in ipairs(section) do
            if type(comp) ~= 'table' then
                comp = { comp }
                section[id] = comp
            end
            comp.separator = left and { right = '' } or { left = '' }
        end
    end
    return sections
end

local function search_result()
    if vim.v.hlsearch == 0 then
        return ''
    end
    local last_search = vim.fn.getreg('/')
    if not last_search or last_search == '' then
        return ''
    end
    local searchcount = vim.fn.searchcount { maxcount = 9999 }
    return last_search .. '(' .. searchcount.current .. '/' .. searchcount.total .. ')'
end

local function modified()
    if vim.bo.modified then
        return '+'
    elseif vim.bo.modifiable == false or vim.bo.readonly == true then
        return '-'
    end
    return ''
end

require('lualine').setup {
    options = {
        theme = theme,
        component_separators = '',
        section_separators = { left = '', right = '' },
    },
    sections = process_sections {
        lualine_a = { 'mode' },
        lualine_b = {
            'branch',
            'diff',
            {
                'diagnostics',
                source = { 'nvim' },
                sections = { 'error' },
                diagnostics_color = { error = { bg = colors.base10, fg = colors.white } },
            },
            {
                'diagnostics',
                source = { 'nvim' },
                sections = { 'warn' },
                diagnostics_color = { warn = { bg = colors.orange, fg = colors.white } },
            },
            { 'filename', file_status = false,        path = 1 },
            { modified,   color = { bg = colors.red } },
            {
                '%w',
                cond = function()
                    return vim.wo.previewwindow
                end,
            },
            {
                '%r',
                cond = function()
                    return vim.bo.readonly
                end,
            },
            {
                '%q',
                cond = function()
                    return vim.bo.buftype == 'quickfix'
                end,
            },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { search_result, 'filetype' },
        lualine_z = { '%l:%c', '%p%%/%L' },
    },
    inactive_sections = {
        lualine_c = { '%f %y %m' },
        lualine_x = {},
    },
}
