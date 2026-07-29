# dotfiles

my configs for [omarchy](https://omarchy.org/) (arch + hyprland) and neovim.

<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/1d92f45d-db6e-4014-9e20-c4a09a29318f" />

<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/6bbc73f6-71f7-4895-be43-f5775c703956" />

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
