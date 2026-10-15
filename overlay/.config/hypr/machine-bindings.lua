-- Managed by omarchy-pc-config. Gaming-PC-only key bindings
-- (loaded from bindings.lua after hypr/shared-bindings.lua).

-- Super+F was exclusive fullscreen (Hyprland and the app). Browsers and
-- Grok Build then present at their own rate, so the cursor stutters.
-- Cover the screen but keep the app windowed; games still get real fullscreen.
hl.unbind("SUPER + F")
o.bind("SUPER + F", "Full screen", function()
  local w = hl.get_active_window()
  if not w then
    return
  end

  local content = w.content or w.contentType or "none"
  if content == "game" or content == "video" then
    hl.dispatch(hl.dsp.window.fullscreen({ mode = "fullscreen" }))
    return
  end

  if (w.fullscreen or 0) ~= 0 then
    hl.dispatch(hl.dsp.window.fullscreen_state({
      internal = 0,
      client = 0,
      action = "set",
    }))
  else
    hl.dispatch(hl.dsp.window.fullscreen_state({
      internal = 2,
      client = 0,
      action = "set",
    }))
  end
end)

-- SUPER+W is Close window by default.
-- Ente Photos intercepts a graceful close and stays in the tray: SIGTERM it.
hl.unbind("SUPER + W")
o.bind("SUPER + W", "Close window", function()
  local window = hl.get_active_window()
  local class = ""
  if window then
    class = string.lower(window.class or window.initial_class or "")
  end

  if class == "ente" or class == "ente-desktop" then
    hl.dispatch(hl.dsp.window.signal({ signal = 15 }))
    return
  end

  hl.dispatch(hl.dsp.window.close())
end)

-- Voxtype: hold Right Super to talk, release to type.
-- Unbind Omarchy defaults (F9 hold, Super+Ctrl+X toggle).
hl.unbind("F9")
hl.unbind("SUPER + CTRL + X")
-- Right Super is code:134 (Super_R).
o.bind("code:134", "Start dictation (push-to-talk)", "voxtype record start", { repeating = false })
o.bind("code:134", "Stop dictation (push-to-talk)", "voxtype record stop", { release = true })
o.bind("SUPER + code:134", "Stop dictation (push-to-talk)", "voxtype record stop", { release = true })
