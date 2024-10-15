local alpha = require("alpha");
local dashboard = require("alpha.themes.dashboard");

--#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#--

local ENABLE_RANDOM_HEADERS = false;
local ENABLE_RANDOM_FOOTERS = false;

local IMAGE_SOURCE = "/home/noire/Pictures/IMG_1883.png";
local IMAGE_MAX_DIMENSIONS = { width = 24, height = 24 };
local IMAGE_MARGINS = { top = 2, bottom = 0 };

local HEADERS = {
    {
        [[                               __                ]],
        [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
        [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
        [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
        [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
    }
}

local DATE = os.date("*t");

local BUTTONS = {
    dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("q", "󰅚  Quit NVIM", ":qa<CR>"),
}

local FOOTERS = {
    "*= the way of the nyamurai. =*",
    "what the dog doin?",
    "󰙌",
    "huh?",
    "uh oh...",
    "remember to eat.",
    "good god, then there's me.",
    "skate through the world.",
    "always feel contented.",
    "cherish what you've got.",
    "you're too beautiful to be someone that ain't you.",
    "free your mind, unchained design.",
    "there's no one way to grind.",
    "be productve",
    "good luck.",
    ((DATE.month == 12 or DATE.month == 1) and "" or (DATE.month == 11 and "" or  (DATE.month == 10 and "󰮣" or ((DATE.month == 7 or DATE.month == 6 or (DATE.month == 5 and DATE.day >= 19)) and "󰖨" or ((DATE.month == 5 or DATE.month == 4 or DATE.month == 3) and "" or (DATE.month == 2 and "♥" or ""))))));
};

--#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#--

local HEADER = ENABLE_RANDOM_HEADERS and HEADERS[math.random(1, #HEADERS)] or HEADERS[1];
local FOOTER = ENABLE_RANDOM_FOOTERS and FOOTERS[math.random(1, #FOOTERS)] or FOOTERS[1];
local originalAlphaSetup = alpha.setup;
alpha.setup = function(...) end;

local didRequireImage, image = pcall(function()
    return require("image")
end)

local _, utils = pcall(function()
    return require("image.utils")
end)

assert(didRequireImage and image, "failed to require 'image.nvim'");

dashboard.section.buttons.val = BUTTONS;
dashboard.section.header.val = HEADER;
dashboard.section.footer.val = FOOTER;

dashboard.config.opts.noautocmd = true

local currentImage;
local cachedImages = {};
local function fetchImage(path)
    local randomImage = image.from_file(path)

    local imageChoice = randomImage.path or randomImage.original_path or path
    if (cachedImages[imageChoice]) then
        return cachedImages[imageChoice]
    else
        cachedImages[imageChoice] = randomImage;
    end

    return randomImage;
end

local function fetchImageDimensions(imgSource)
    local img = imgSource or currentImage;
    local imageWidth = math.min(img.image_width, IMAGE_MAX_DIMENSIONS.width);
    local imageHeight = math.min(img.image_height, IMAGE_MAX_DIMENSIONS.height);

    local screenDimensions = utils.term.get_size();
    local topLeftPosition = (screenDimensions.screen_cols / 2) - (imageWidth / 2);

    return imageWidth, imageHeight, topLeftPosition;
end

local function fetchHeaderImageAdjustments(imgSource)
    local img = imgSource or currentImage;
    local imageHeight = select(2, fetchImageDimensions(img));
    local newHeaderValue = {unpack(HEADER)};

    local result = math.floor(imageHeight / 4) + currentImage.geometry.y;
    local longestIndex = 0;
    for i = 1, #newHeaderValue do
        local len = #newHeaderValue[i];
        if (len > longestIndex) then
            longestIndex = len;
        end
    end

    local marginedTopResult = result + IMAGE_MARGINS.top;
    for _ = 1, math.max(marginedTopResult, marginedTopResult + IMAGE_MARGINS.bottom) do
        table.insert(newHeaderValue, 1, ([[ ]]):rep(longestIndex));
    end

    return newHeaderValue;
end

local function setupTestImage()
    currentImage = fetchImage(IMAGE_SOURCE);
    dashboard.section.header.val = fetchHeaderImageAdjustments();

    return currentImage;
end

local function renderImage(imgSource)
    local img = imgSource or currentImage;
    local width, height, topLeft  = fetchImageDimensions(img);
    img:clear();
    img:render({
        -- turns out ALL of the size metrics are in cells and NOT 
        -- in pixels. Huh.
        x = topLeft,
        y = IMAGE_MARGINS.top;

        width = width;
        height = height;
    });

end

local isAlphaOpen = false;
vim.api.nvim_create_autocmd("VimResized", {
    callback = function ()
        if (isAlphaOpen) then
            renderImage(currentImage)
        end
    end
});

vim.api.nvim_create_autocmd("User", {
    pattern = "Alpha*",
    callback = function(ev)
        if (ev.match == "AlphaClosed") then
            isAlphaOpen = false;
            if (currentImage) then
                currentImage:clear();
            end
            return;
        end

        --[[
        -- for some reason this fixes the problem
        -- of the image disappearing on VimEnter?
        -- cool i guess.
        --
        -- it's really deferred on VimEnter but
        -- after that it's instant so i guess its
        -- just an image.nvim bottleneck 
        --]]
        isAlphaOpen = true;
        vim.defer_fn(function()
            renderImage(currentImage)
        end, 0);
    end,
})

setupTestImage()
originalAlphaSetup(dashboard.config)
