-- Managed by omarchy-pc-config.
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = 1

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- AOC 24G42E: 1080p 180Hz Adaptive Sync. Default "preferred" was locking 60Hz.
-- vrr = 3 matches misc.vrr: Adaptive Sync only for fullscreen game/video.
hl.monitor({
  output = "DP-2",
  mode = "1920x1080@180",
  position = "0x0",
  scale = 1,
  vrr = 3,
})

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
