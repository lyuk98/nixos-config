# NixOS configurations

This repository contains a flake managing my personal devices' configurations.

## Current state

The system configuration is currently available for the following device:

- [Personal laptop (Framework Laptop 13)](./hosts/framework/default.nix)

The [user configuration](./home/lyuk98/) is available with host-specific modules.

## Building

With `nix`, run:

```sh
nix-shell
```

Alternatively, if you have experimental features `flakes` and `nix-command` enabled, run:

```sh
nix develop
```

Build system configurations using `nixos-rebuild`:

```sh
nixos-rebuild build --flake .
```

Build user configurations using `home-manager`:

```sh
home-manager build --flake .
```
