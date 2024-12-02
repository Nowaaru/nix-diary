local alpha = require("alpha");
local dashboard = require("alpha.themes.dashboard");

--#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#--

local DATE = os.date("*t");

local ENABLE_RANDOM_IMAGES = true;
local ENABLE_RANDOM_HEADERS = false;
local ENABLE_RANDOM_FOOTERS = true;


local IMAGE_SOURCES = {
    { "/home/noire/Pictures/IMG_1883.png", 0.5 };
};

local IMAGE_MAX_DIMENSIONS = { width = 24, height = 24 };
local IMAGE_MARGINS = { top = 2, bottom = 0 };

local HEADERS = {
    ["neovim-block"] = {
        [[                               __                ]],
        [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
        [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
        [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
        [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
    },
}

local HEADER_KEYS = {}; do
    for i in pairs(HEADERS) do
        table.insert(HEADER_KEYS, i);
    end
end



local BUTTONS = {
    dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("q", "󰅚  Quit NVIM", ":qa<CR>"),
    dashboard.button("o", "  Open Recent", ":qa<CR>"),
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

local function weighted_random(LIST)
    local errorMessage = "expected a table of { weight = num, src = string } , { string, num } , or string.";
    local overallWeight = 0;

    local tableIndices = {};
    for i, _ in pairs(LIST) do
        local item = LIST[i];
        if (type(item) == "table") then
            local tableWeight = item.weight or item[2];
            overallWeight = overallWeight + tableWeight;
            tableIndices[#tableIndices+1] = item;
        elseif (type(item) == "string") then
            local weight = (overallWeight == 0 and 1 or overallWeight) / (#tableIndices + 1);
            overallWeight = overallWeight + weight;
            tableIndices[#tableIndices+1] = { weight = weight, src = item };
        else
            error(errorMessage);
        end
    end

    table.sort(tableIndices, function(a, b)
        return (a.weight or a[2]) < (b.weight or b[2]);
    end);

    local randomValue; do
        if (overallWeight <= 1) then
            randomValue = math.random(overallWeight * 100) / 100;
        else
            randomValue = math.random(math.floor(overallWeight)) + (overallWeight % 1 ~= 0 and (math.random((overallWeight % 1) * 100) / 100) or 0);
        end
    end;

    local weightsCursor = 0;
    for i = 1, #tableIndices do
        local currentIndex = tableIndices[i];
        weightsCursor = weightsCursor + (currentIndex.weight or currentIndex[2]);
        if (weightsCursor >= randomValue) then
             return (currentIndex.src or currentIndex.item or currentIndex.img or currentIndex.image or currentIndex.source or currentIndex[1]), weightsCursor, randomValue;
        end
    end

    return nil, weightsCursor, randomValue;
end

local IMAGE_SOURCE; do
    if (ENABLE_RANDOM_IMAGES) then
        local randomImage, weightsCursor, randomValue = weighted_random(IMAGE_SOURCES);
        assert(randomImage, "weight out of bounds: ".. weightsCursor .. " out of " .. randomValue);

        IMAGE_SOURCE = randomImage;
    else
        IMAGE_SOURCE = IMAGE_SOURCES[1];
    end
end

local HEADER = ENABLE_RANDOM_HEADERS and HEADERS[HEADER_KEYS[math.random(1, #HEADER_KEYS)]] or HEADERS[HEADER_KEYS[1]];
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

dashboard.section.header.opts.position = "center";
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
    local topLeftPositionX = math.floor((screenDimensions.screen_cols / 2) - (imageWidth / 2));
    local topLeftPositionY = math.floor((screenDimensions.screen_rows / 2) - imageHeight);

    return imageWidth, imageHeight, topLeftPositionX, topLeftPositionY;
end

local function fetchHeaderImageAdjustments(imgSource)
    local img = imgSource or currentImage;
    local imageHeight = select(2, fetchImageDimensions(img));
    local newHeaderValue = {unpack(HEADER)};

    local result = math.ceil(imageHeight / 4) + currentImage.geometry.y + 1;
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
    local width, height, topLeftX, topLeftY = fetchImageDimensions(img);
    img:clear();
    img:render({
        -- turns out ALL of the size metrics are in cells and NOT 
        -- in pixels. Huh.
        x = topLeftX,
        y = IMAGE_MARGINS.top,

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
