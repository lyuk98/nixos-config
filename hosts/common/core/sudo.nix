{ lib, ... }:
{
  security.sudo-rs = {
    # Enable sudo-rs
    enable = true;

    # Only allow members of group wheel to run sudo
    execWheelOnly = true;
  };

  # Forcefully prevent sudo from being enabled
  security.sudo.enable = lib.mkForce false;
}
