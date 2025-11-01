# NixOS configurations

This repository contains a flake managing my personal devices' configurations.

## Current state

The system configuration is currently available for the following devices:

- [Personal laptop (Framework Laptop 13)](./hosts/framework/default.nix)
- [Museum instance (Amazon Lightsail)](./hosts/museum/default.nix)
- [Vault instance (DigitalOcean Droplet)](./hosts/vault/default.nix)
- [Personal laptop/server (Dell XPS 13 9350)](./hosts/xps13/default.nix)

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

Home Manager configurations are built together with the NixOS system. However, if it is desirable to separately do so, `home-manager` can be used:

```sh
home-manager build --flake .
```
