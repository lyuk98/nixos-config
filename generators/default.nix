{
  inputs,
  pkgs,
  lib,
  system,
  ...
}:
let
  # Generate configuration for nixos-generators with default settings
  generate =
    properties:
    inputs.nixos-generators.nixosGenerate (
      properties
      // {
        system = system;
        pkgs = pkgs;
        lib = lib;
      }
    );
in
{ }
