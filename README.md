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
```

## Docker Container

You can build and run this locally at a whim

```shell
sudo podman build --tag dev --progress=plain .
sudo podman run -it -v ~/.ssh:/home/dev/.ssh:ro localhost/dev:latest
```

