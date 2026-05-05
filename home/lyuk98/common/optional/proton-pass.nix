{
  services.proton-pass-agent = {
    # Enable Proton Pass SSH agent
    enable = true;
  };

  home.sessionVariables = {
    # Use D-Bus Secret Service provider
    PROTON_PASS_LINUX_KEYRING = "dbus";
  };
}
