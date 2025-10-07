{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    # Add uutils coreutils and prioritise it over GNU coreutils
    (lib.hiPrio uutils-coreutils-noprefix)
  ];
}
