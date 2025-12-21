{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Add environment variables for audio plugins
  home.sessionVariables =
    let
      makePluginPath =
        format:
        (lib.makeSearchPath format [
          "${config.home.profileDirectory}/lib"
          "/run/current-system/sw/lib"
        ])
        + ":${config.home.homeDirectory}/.${format}";
    in
    {
      DSSI_PATH = makePluginPath "dssi";
      LADSPA_PATH = makePluginPath "ladspa";
      LV2_PATH = makePluginPath "lv2";
      LXVST_PATH = makePluginPath "lxvst";
      VST_PATH = makePluginPath "vst";
      VST3_PATH = makePluginPath "vst3";
    };

  # Add audio plugins
  home.packages = with pkgs; [
    drumgizmo # DrumGizmo LV2 plugin
    noise-repellent # LV2 plugins for noise reduction
  ];
}
