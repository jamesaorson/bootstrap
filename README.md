# Linux Config

## Important Links

- [Repository](https://git.sr.ht/~jamesaorson/bootstrap)
- [Nerd Fonts](https://www.nerdfonts.com/)
- [Starship](https://starship.rs/)

## Setup

Run [`bootstrap`](./bootstrap) if you want everything

You can also pick and choose modules by listing the directories to install and they will install in that order

```shell
./bootstrap apt bat #NOTE: Installs apt scripts and cat-alternative, bat
./bootstrap omarchy git vim
```

## Platforms

`bootstrap` detects the OS and installs with that platform's package manager.

- Debian and Ubuntu use apt
- Omarchy uses `omarchy pkg` for official packages and `omarchy pkg aur` when a module is AUR-only
- macOS uses Homebrew

Omarchy is detected from `/etc/os-release` (`ID=omarchy`). With no arguments, Omarchy installs the same modules as macOS, with the `omarchy` helpers in place of `brew`. Debian and Ubuntu keep the shorter apt module list.

## Docker Container

You can build and run this locally at a whim

```shell
sudo podman build --tag dev --progress=plain .
sudo podman run -it -v ~/.ssh:/home/dev/.ssh:ro localhost/dev:latest
```

