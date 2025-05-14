{ pkgs, ... }:
{
  i18n.inputMethod = {
    # Enable additional input methods
    enable = true;

    # Use IBus input method
    type = "ibus";
  };

  # Enable Hangul IBus engine
  i18n.inputMethod.ibus.engines = with pkgs.ibus-engines; [ hangul ];
}
