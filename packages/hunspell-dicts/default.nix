{ buildEnv, hunspellDicts }:
buildEnv {
  pname = "hunspell-dicts";
  version = hunspellDicts.en_GB-ise.version;

  # Dictionaries for Hunspell
  paths = with hunspellDicts; [
    en_GB-ise
    en_US
    ko_KR
  ];
}
