{
  boot = {
    # Enable Plymouth boot splash screen
    plymouth.enable = true;

    # Enable silent boot
    kernelParams = [ "quiet" ];
  };
}
