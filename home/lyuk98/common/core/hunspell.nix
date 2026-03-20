{ pkgs, lib, ... }:
{
  options.programs.hunspell = {
    # Make option for other modules to refer to
    dictionaries = lib.mkOption {
      description = "The derivation to use for Hunspell dictionaries";

      default =
        with pkgs;
        (buildEnv {
          pname = "hunspell-dicts";
          version = hunspellDicts.en_GB-ise.version;

          # Dictionaries for Hunspell
          paths = with hunspellDicts; [
            en_GB-ise
            en_US
            ko_KR
          ];
        });
    };
  };
}
