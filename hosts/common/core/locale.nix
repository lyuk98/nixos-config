{ lib, ... }:
{
  i18n = {
    # Set system locale
    defaultLocale = lib.mkDefault "en_GB.UTF-8";

    # Add additional supported locales
    supportedLocales = lib.mkDefault [
      "C.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "ko_KR.EUC-KR/EUC-KR"
      "ko_KR.UTF-8/UTF-8"
    ];
  };

  # Set default time zone
  time.timeZone = lib.mkDefault "Asia/Seoul";
}
