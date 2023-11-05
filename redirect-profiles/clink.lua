-- Redirecting Profile to Scott's Terminal Configuration

local HOME_PATH = os.getenv("USERPROFILE")
local PROFILE_REDIRECT = HOME_PATH .. "/.terminal-config/profiles/clink.lua"
dofile (PROFILE_REDIRECT)
