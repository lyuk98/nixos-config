{ lib, config, ... }:
{
  security = if (lib.versionAtLeast lib.trivial.release "26.05") then {
    run0 = {
      # Require authentication from users of the group wheel
      wheelNeedsPassword = true;

      # Make sudo an alias only if Sudo (and its Rust variant) is not enabled
      enableSudoAlias = lib.mkDefault (!config.security.sudo.enable && !config.security.sudo.enable);
    };

    # Disable Sudo by default
    sudo.enable = lib.mkDefault false;
    sudo-rs.enable = lib.mkDefault false;
  } else {
    # Keep Sudo enabled for systems with Nixpkgs prior to 26.05
    sudo-rs.enable = lib.mkDefault true;
  };
}
