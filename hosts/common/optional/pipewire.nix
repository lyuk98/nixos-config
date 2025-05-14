{
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

    # Enable JACK emulation
    jack.enable = true;

    # Enable PulseAudio emulation
    pulse.enable = true;
  };
}
