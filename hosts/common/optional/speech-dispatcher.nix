{ pkgs, ... }:
{
  # Enable speech-dispatcher daemon
  services.speechd.enable = true;

  # Add packages for speech synthesiser
  environment.systemPackages = [
    # Use Piper
    pkgs.piper-tts

    # Use Pied for managing voices
    pkgs.pied

    # Add killall since Pied assumes it is installed
    # https://fosstodon.org/@reshi/114525494628077289
    pkgs.killall
  ];
}
