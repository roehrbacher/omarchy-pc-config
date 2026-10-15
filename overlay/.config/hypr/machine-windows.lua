-- Managed by omarchy-pc-config. Gaming PC window rules (loaded from hyprland.lua).

-- Omarchy floats every Steam client window and centers the library at 1100x700.
-- Tile the main library; leave Friends List and other Steam dialogs floating.
o.window({ class = "^steam$", title = "^Steam$" }, { tile = true })

-- Omarchy tags Bitwarden and the presentation terminal as floating-window, then
-- a tag rule floats them. Electron also restores a saved floating geometry after
-- map. Drop the tag, tile on open, and retry briefly so the sibling can split.
local function auto_tile_window(w)
  if not w then
    return false
  end
  local class = w.class or w.initial_class or ""
  local title = w.title or w.initial_title or ""
  if class == "Bitwarden" then
    return true
  end
  if class == "chrome-nngceckbapebfimnlniiiahkandclblb-Default" then
    return true
  end
  if class == "org.omarchy.terminal" and title == "Omarchy" then
    return true
  end
  return false
end

local function window_sel(w)
  if not w then
    return nil
  end
  local address = w.address
  if type(address) == "string" and address ~= "" then
    if address:sub(1, 8) == "address:" then
      return address
    end
    return "address:" .. address
  end
  return w
end

local function force_tile(selector)
  if not selector then
    return
  end
  local win = hl.get_window(selector)
  if not win or not auto_tile_window(win) then
    return
  end
  if win.floating then
    hl.dispatch(hl.dsp.window.float({ action = "unset", window = selector }))
  end
end

o.window({ class = "^(Bitwarden)$" }, { tag = "-floating-window", tile = true })
o.window("chrome-nngceckbapebfimnlniiiahkandclblb-Default", { tag = "-floating-window", tile = true })
o.window({ class = "^org\\.omarchy\\.terminal$", title = "^Omarchy$" }, { tag = "-floating-window", tile = true })

local function schedule_force_tile(w)
  if not auto_tile_window(w) then
    return
  end
  local selector = window_sel(w)
  force_tile(selector)
  for _, delay in ipairs({ 50, 150, 400 }) do
    hl.timer(function()
      force_tile(selector)
    end, { timeout = delay, type = "oneshot" })
  end
end

hl.on("window.open", schedule_force_tile)
hl.on("window.update_rules", function(w)
  if auto_tile_window(w) then
    force_tile(window_sel(w))
  end
end)

-- Overwatch (Steam Proton app 2357570): opaque, no animations, tearing in
-- exclusive fullscreen, inhibit idle so the lock screen does not fire mid-match.
o.window("steam_app_2357570", {
  tag = "-default-opacity",
  opacity = "1 1",
  no_anim = true,
  immediate = true,
  idle_inhibit = "fullscreen",
  content = "game",
})
