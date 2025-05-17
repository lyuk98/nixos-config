{ inputs, ... }:
{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

  services.flatpak = {
    # Enable nix-flatpak
    enable = true;

    update = {
      # Enable periodic updates
      auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };

    # Add Flatpak packages
    packages = [
      "com.github.tchx84.Flatseal" # Flatseal
      "com.makemkv.MakeMKV" # MakeMKV
      "com.mojang.Minecraft" # Minecraft
      "com.obsproject.Studio" # OBS Studio
      "com.usebottles.bottles" # Bottles
      "com.valvesoftware.Steam" # Steam
      "de.haeckerfelix.Shortwave" # Shortwave
      "im.bernard.Nostalgia" # Nostalgia
      "io.gitlab.azymohliad.WatchMate" # Watchmate
      "net.mediaarea.MediaInfo" # MediaInfo
      "net.supertuxkart.SuperTuxKart" # SuperTuxKart
      "no.mifi.losslesscut" # LosslessCut
      "org.audacityteam.Audacity" # Audacity
      "org.fedoraproject.MediaWriter" # Fedora Media Writer
      "org.gnome.Boxes" # Boxes
      "org.gnucash.GnuCash" # GnuCash
      "org.gtk.Gtk3theme.adw-gtk3-dark" # adw-gtk3 GTK Theme
      "org.gtk.Gtk3theme.adw-gtk3" # adw-gtk3 GTK Theme
      "org.gtk.Gtk3theme.Adwaita-dark" # Adwaita dark GTK theme
      "org.gtk.Gtk3theme.Breeze" # Breeze GTK theme
      "org.hydrogenmusic.Hydrogen" # Hydrogen
      "org.kde.kdenlive" # Kdenlive
      "org.kde.kid3" # Kid3
      "org.kde.optiimage" # OptiImage
      "org.libreoffice.LibreOffice" # LibreOffice
      "org.mozilla.Thunderbird" # Thunderbird
      "org.musicbrainz.Picard" # MusicBrainz Picard
      "org.raspberrypi.rpi-imager" # Raspberry Pi Imager
      "org.standardnotes.standardnotes" # Standard Notes
      "org.videolan.VLC" # VLC
      "re.sonny.Eloquent" # Eloquent
    ];
  };
}
