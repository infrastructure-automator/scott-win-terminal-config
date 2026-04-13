-- Text Formats (ANSI escape codes)
local NORMAL_TEXT = "\x1b[37m"   -- White
local HIGHLIGHT_TEXT = "\x1b[1;33m" -- Bold Yellow
local RESET_TEXT = "\x1b[0m"

-- Oh My Posh config paths
local omp_config_path = os.getenv("USERPROFILE") .. "\\.terminal-config\\oh-my-posh\\"
local default_config = omp_config_path .. "scott-default.omp.json"
local expanded_config = omp_config_path .. "scott-expanded.omp.json"

-- Helper to (re)initialize oh-my-posh with a given config
local function load_omp(config)
    local init = io.popen('oh-my-posh init cmd --config "' .. config .. '"')
    local script = init:read("*a")
    init:close()
    load(script)()
end

-- dft: switch to Default Prompt
local function dft_impl()
    print(NORMAL_TEXT .. 'Loading Default Prompt (Type "' .. HIGHLIGHT_TEXT .. "eft" .. NORMAL_TEXT .. '" to switch to Expanded Prompt)' .. RESET_TEXT)
    load_omp(default_config)
end

-- eft: switch to Expanded Prompt
local function eft_impl()
    print(NORMAL_TEXT .. 'Loading Expanded Prompt (Type "' .. HIGHLIGHT_TEXT .. "dft" .. NORMAL_TEXT .. '" to switch to Default Prompt)' .. RESET_TEXT)
    load_omp(expanded_config)
end

-- Intercept "dft" and "eft" commands before they reach cmd.exe
local function filter_input(text)
    local trimmed = text:match("^%s*(.-)%s*$")
    if trimmed == "dft" then
        dft_impl()
        return "", false
    elseif trimmed == "eft" then
        eft_impl()
        return "", false
    end
end

if clink.onfilterinput then
    clink.onfilterinput(filter_input)
end

-- Load default prompt on startup
load_omp(default_config)
