# dotfiles

my configs for [omarchy](https://omarchy.org/) (arch + hyprland).

everything here mirrors `~/.config/`, so restoring is just a copy.

## what's in here

| dir | what it is |
| --- | --- |
| `waybar/` | status bar — segmented pill layout, custom clock, media visualizer, text readout cluster |
| `hypr/` | hyprland — gaps, bindings, monitors, idle, lock screen |
| `ghostty/` | terminal config + kanso theme files |
| `nvim/` | lazyvim setup, plugin versions pinned in `lazy-lock.json` |

## the look

- theme is [kanso](https://github.com/webhooked/kanso.nvim) (ink variant) across ghostty and neovim
- waybar isn't one solid bar — each module group is its own pill on a transparent background, so the wallpaper shows through
- pills use `#0F1318`, a midpoint between kanso zen and ink
- separators and clock brackets are dimmed to `#5C6066` so labels read louder than dividers

## restore

```sh
git clone https://github.com/zeke-john/dotfiles.git
cd dotfiles
cp -r waybar hypr ghostty nvim ~/.config/
```

then reload things:

```sh
omarchy restart waybar
omarchy restart terminal
hyprctl reload
```

neovim will install its plugins on first launch.

## notes

- `waybar/scripts/media-player.py` needs `playerctl`
- the arch pill on the far left opens the omarchy menu (same as `super + alt + space`)
- `hypr/looknfeel.conf` sets `gaps_out = 5, 10, 10, 10` — tighter on top so windows sit closer under the bar
