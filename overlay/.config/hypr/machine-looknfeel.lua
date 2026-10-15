-- Managed by omarchy-pc-config. Gaming display settings.

-- Tearing is off unless a window rule sets `immediate` (Overwatch, etc).
-- VRR mode 3 = Adaptive Sync only for fullscreen game/video.
-- no_break_fs_vrr = 2 is Hyprland's default: skip extra cursor frames
-- only for content type "game", so a Super+F browser keeps a 180 Hz cursor.
hl.config({
  general = {
    allow_tearing = true,
  },
  misc = {
    vrr = 3,
  },
  cursor = {
    no_break_fs_vrr = 2,
  },
})
