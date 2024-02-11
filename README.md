## Dear, Diary...

A repository for my Nix shenanigans.
Need a to-do because I keep forgetting
what I was on about.

- [ ] Configure neovim flake.

  - I decided against using the jank
    LazyVim copy-to-share `~/.config`.
    I wonder if this costs me in customizability though...

  - [ ] Implement Nix code action to change between `mkDefault`
        and `mkForce` options interchangeably.

- [ ] Implement `wlsunset`-based nightlight widget
      using [`eww`](elkowar/eww).

- [ ] Create custom firefox option-set because
      the home-manager configuration doesn't work.

- [ ] Implement `agenix`.

  - I am in despair.

- [ ] Configure default firefox profile.

  - [ ] Configure userchrome based off of
        the theme

- [ ] Implement a clipboard manager using [`eww`](elkowar/eww)
      and [`cliphist`](sentriz/cliphist).

- [ ] Implement a screen recording solution.

  - 'Nuff said. Might look into asciinema for
    terminal solutions and gpu-screen-recorder
    for desktop.

- [ ] Extract theming system into a different
      flake.

  - Problem with such a fragmented configuration is that
    Nix seemingly doesn't have a path shortcut for the
    flake root.

    Today I also learned that `self` refers to the root
    directory of the flake and not the flake attrset. Huh.

- [ ] Apply current theme to screenshot tool

- [ ] Fix Roblox Studio + Wayland mouse acceleration problem.

  - Supposedly "fixed" in Wine 9.0-rc2, but Vinegar uses a patched
    Wine 9.0-rc1. Could just up and yoink the patches from the source but
    laziness is a vice.

- [x] Install video editor

  - Kdenlive will probably do.

- [x] Make screenshot script freeze the screen

- [x] Install [neovim-flake](https://github.com/jordanisaacs/neovim-flake)

- [x] Add window rules to enable tearing on full-screen
      applications.

  - Turns out that tearing with double buffering is a feat
    that Linux doesn't like. Seems like it's a "deal with it and
    wait" problem.

- [x] Install Rojo.

  - Need this for Roblox development. Probably.

- [x] Personalize Waybar (or just use Eww)

  - Ended up sticking with Eww because waybar has
    layering problems and doesn't play well with follow-mouse
    on hyprland. Siiiigh.
