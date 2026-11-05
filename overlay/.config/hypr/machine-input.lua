-- Managed by omarchy-pc-config. PC-only input overrides.
-- Loaded AFTER hypr/shared-input.lua (see hypr/input.lua).
--
-- Pointer speeds live here (not in shared-input.lua) so shared-config sync
-- keeps the install defaults and never overwrites a tuned PC feel.
-- `omarchy-pointer set` rewrites the pointer-profiles block below.

-- pointer-profiles:begin
hl.device({
  name = "compx-2.4g-receiver-mouse",
  sensitivity = -0.45,
  accel_profile = "flat",
})

hl.device({
  name = "logitech-g305-1",
  sensitivity = -0.45,
  accel_profile = "flat",
})

-- pointer-profiles:end
