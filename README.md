# Timon's Omarchy – gaming PC

> **Heads-up:** these are my (Timon's) personal Omarchy configs and plugins, shared as-is.
> Use them at your own risk. Before installing, read the code yourself or have your
> favorite AI review it first.

Private. Gaming-PC-only settings. **Install `roehrbacher/omarchy-shared-config`
first**, then this repo:

```bash
~/Work/omarchy-shared-config/install.sh
~/Work/omarchy-pc-config/install.sh
```

Backups go to `~/.local/share/omarchy-config-backups/omarchy-pc-config/`;
`./uninstall.sh` restores the latest one.

## What is in here

- `hypr/monitors.lua` – AOC 24G42E at 1920×1080, 180 Hz, variable refresh, 1× scale
- `hypr/machine-looknfeel.lua` – tearing allowed (only for windows that ask for
  it), variable refresh for fullscreen games/video
- `hypr/machine-bindings.lua` – Super+F covers the screen but keeps apps
  windowed (games and video still get real fullscreen); Super+W kills Ente
  Photos properly; hold either Context Menu key to dictate with Voxtype
  (F9 and Super+Ctrl+X unbound)
- `hypr/machine-windows.lua` – Steam library and Bitwarden open tiled;
  Overwatch: full opacity, tearing, no idle while fullscreen
- `omarchy/shell.d/50-pc.json` – adds the pointer-speed toggle after Grokbar
  (the `timon.audio` panel itself now lives in omarchy-shared-config; on this PC
  it picks outputs through `omarchy-audio-output-pick` so the choice sticks)
- `omarchy/plugins/timon.pointer` + `omarchy/pointer.json` + `omarchy-pointer` –
  separate flat speed for the ProtoArc and the G305. `omarchy-pointer set`
  rewrites the mouse block in `hypr/shared-input.lua`; copy that change back to
  omarchy-shared-config if you want to keep it
- `omarchy/audio-passthrough.machine.conf` – which mic (Razer Seiren V3 Mini) and
  headphones (Apple USB-C adapter) Audio passthrough uses on this PC; its widget
  is placed in the bar by `shell.d/50-pc.json`.
- Audio: `audio-sticky-sink` (games can't steal the default output; Ctrl+^,
  the audio panel count as your choice and stick),
  `omarchy-audio-output-pick` / `-switch-two`,
  WirePlumber rules (hide unused outputs, no auto-switch), speaker EQ
  (`omarchy-speaker-tuning` PipeWire filter-chain + service)
- Sunshine game streaming (enabled as a user service)
- Voxtype on the Radeon (Vulkan, `VOXTYPE_VULKAN_DEVICE=amd`) with logging
- `voxtype/config.toml` – Voxtype settings for this PC: large-v3-turbo q5_0 on
  the GPU, English/German, a short vocabulary hint (Omarchy, Grok Bot, Timon
  Röhrbacher, …) and replacements for words dictation keeps getting wrong
- `omarchy/shell.toml` – bar font 14; terminal font size 11
- `wireplumber/.../60-bluetooth-names.conf` – the Bose headphones' Bluetooth name
  starts with an emoji, which made Ctrl+^ and the audio panel show "(null)";
  they are now called "Bose"
- Insomnia (the eye in the bar centre) comes from omarchy-shared-config and
  runs with its defaults here, so this repo has no `insomnia.conf`: a session
  blocks suspend/hibernate/idle (`systemd-inhibit --what=sleep:idle`) and
  starting it locks and turns the display off, so the PC stays reachable for
  Grok Bot. When it ends, normal behaviour is back

## Removed on the PC

`timon.bar`, `timon.power`, the WhatsApp Chromium workaround (back to the
Omarchy web app), Hermes on Super+Ctrl+Return (now the shared agent key),
omasnap (`sudo pacman -R omasnap`).

## Audio passthrough

The service, helper and `timon.audio-passthrough` widget live in
omarchy-shared-config. This repo only sets the devices in
`~/.config/omarchy/audio-passthrough.machine.conf` (`SINK`, `SOURCE`). Your level
and on/off are in `~/.config/omarchy/audio-passthrough.conf` (set by the widget).

## License

0BSD (see `LICENSE`), © 2026 Timon Röhrbacher. Third-party plugins and assets in `overlay/` (e.g. folders not named `timon.*`) keep their own licenses, see the `LICENSE` file inside each.
