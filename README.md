# Timon's Omarchy – gaming PC

> **Heads-up:** these are my (Timon's) personal Omarchy configs and plugins, shared as-is.
> Use them at your own risk. Before installing, read the code yourself or have your
> favorite AI review it first.

## How this setup works

I run [Omarchy](https://omarchy.org) on two machines:

- **Gaming PC** – Ryzen 7 7700, Radeon RX 9060 XT
- **Laptop** – Dell XPS 14

My config is split into three repos so nothing is duplicated:

| Repo | Used on | What it holds |
|---|---|---|
| [omarchy-shared-config](https://github.com/roehrbacher/omarchy-shared-config) | both | theme, top bar layout, my plugins, keybindings, menu, night light, auto timezone, audio passthrough, Insomnia (stay awake) |
| [omarchy-pc-config](https://github.com/roehrbacher/omarchy-pc-config) | gaming PC | monitor, mouse pointer speed, headphones/speakers switching, passthrough headphones, game and streaming tweaks |
| [omarchy-xps-config](https://github.com/roehrbacher/omarchy-xps-config) | laptop | touchpad, battery and charge limit, speaker tuning, passthrough headphones, local AI model |

```
omarchy-shared-config   (install first)
        ├── omarchy-pc-config    (then this on the PC)
        └── omarchy-xps-config   (or this on the laptop)
```

**Install order:** shared first, then the machine repo. Each `install.sh` backs up
whatever it replaces, `./install.sh --dry-run` shows what would change, and
`./uninstall.sh` restores the last backup.

## What's in this repo

- **Screen:** AOC 24G42E at 1080p 180 Hz, variable refresh, tearing for games
- **Mouse:** pointer-speed bar widget with separate speeds for two mice
- **Audio:** sticky default output (games can't steal it), quick
  headphones/speakers switch, speaker EQ, hidden unused outputs, Bose rename
- **Passthrough headphones:** the Apple USB-C adapter (mic = system default, the Razer Seiren V3 Mini)
- **Gaming and streaming:** Sunshine, Overwatch and Steam window rules
- **Dictation:** Voxtype on the Radeon GPU, held on the Context Menu key
- **Fonts:** bar and terminal sizes for this monitor
- **Brave:** UI scale 1.1 (`brave-flags.d/50-pc.conf`, merged with the shared flags and summarize extensions from omarchy-shared-config)

## Install

Install omarchy-shared-config first, then:

```bash
~/Work/omarchy-shared-config/install.sh
~/Work/omarchy-pc-config/install.sh
```

Backups go to `~/.local/share/omarchy-config-backups/omarchy-pc-config/`;
`./uninstall.sh` restores the latest one.

---

# Details

## Everything in here

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
- `omarchy/audio-passthrough.machine.conf` – which headphones (Apple USB-C adapter)
  Audio passthrough plays into on this PC (the mic is the system default); its widget
  is placed in the bar by `shell.d/50-pc.json`.
- Audio: `audio-sticky-sink` (games can't steal the default output; Ctrl+^,
  the audio panel count as your choice and stick),
  `omarchy-audio-output-pick` / `-switch-two`,
  WirePlumber rules (hide unused outputs, no auto-switch), speaker EQ
  (`omarchy-speaker-tuning` PipeWire filter-chain + service)
- Sunshine game streaming (enabled as a user service)
- Voxtype on the Radeon (Vulkan, `VOXTYPE_VULKAN_DEVICE=amd`) with logging
- Voxtype settings (`voxtype/config.toml`) now come from omarchy-shared-config
  (same on both machines); only the Radeon drop-ins above stay here
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
`~/.config/omarchy/audio-passthrough.machine.conf` (`SINK`; the mic is the system default). Your level
and on/off are in `~/.config/omarchy/audio-passthrough.conf` (set by the widget).

## Packages

PC-only extra apps (`PACKAGES` in `repo.conf`; the shared list is in omarchy-shared-config): sunshine, bankstown (AUR), android-udev.

`./install.sh` installs only the ones that are missing (`pacman -S --needed`,
AUR packages through `yay`). It never upgrades or removes anything, and a package
that fails is skipped with a message. If sudo needs a password and there is no
terminal, it just prints what is pending. `./uninstall.sh` never removes packages;
remove them by hand with `sudo pacman -Rns <pkg>`.

**Using this repo yourself?** Trim `PACKAGES` in `repo.conf` to the apps you want first.

## License

0BSD (see `LICENSE`), © 2026 Timon Röhrbacher. Third-party plugins and assets in `overlay/` (e.g. folders not named `timon.*`) keep their own licenses, see the `LICENSE` file inside each.
