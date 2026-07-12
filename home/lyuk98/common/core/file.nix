{ pkgs, ... }:
{
  # Manually override pkgs.file until the merged PR reaches nixos-unstable
  # https://github.com/NixOS/nixpkgs/pull/540742
  nixpkgs.overlays = [
    (final: prev: {
      file = prev.file.overrideAttrs (oldAttrs: {
        postPatch = ''
          substituteInPlace src/landlock.c --replace-fail \
            "LANDLOCK_ACCESS_FS_READ_FILE | LANDLOCK_ACCESS_FS_READ_DIR" \
            "LANDLOCK_ACCESS_FS_READ_FILE | LANDLOCK_ACCESS_FS_READ_DIR | LANDLOCK_ACCESS_FS_EXECUTE"
        '';
      });
    })
  ];

  # Add file to environment
  home.packages = [ pkgs.file ];
}
