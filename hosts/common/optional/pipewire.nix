{ pkgs, ... }: {
  # Enable RealtimeKit for acquiring realtime priority
  security.rtkit.enable = true;

  services.pipewire = {
    # Enable PipeWire if not already enabled
    enable = true;

    alsa = {
      # Enable ALSA support
      enable = true;

      # Enable support for 32-bit ALSA
      support32Bit = true;
    };

    # Enable PulseAudio emulation
    pulse.enable = true;
  };

  # Enable JACK emulation with nix-ld, as services.pipewire.jack.enable is deprecated
  # due to its modification to LD_LIBRARY_PATH
  programs.nix-ld.libraries = [ pkgs.pipewire.jack ];
}
