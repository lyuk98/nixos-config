{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  # Create option to enable Zen Browser
  options.applications.network.zen-browser.enable = lib.mkEnableOption "Zen Browser";

  config = lib.mkIf config.applications.network.zen-browser.enable {
    programs.zen-browser = {
      # Enable Zen Browser
      enable = true;

      # Enable native messaging
      nativeMessagingHosts = [
        pkgs.firefoxpwa
      ];

      # Apply policies
      policies =
        let
          # List of packages to allow in private browsing
          allowInPrivateBrowsing = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
          ];

          # Declare extension policy from given Firefox addon packages
          mkExtensionSettings = (
            extensions:
            builtins.listToAttrs (
              builtins.map (extension: {
                name = extension.addonId;
                value =
                  let
                    uuid = builtins.elemAt (builtins.attrNames (builtins.readDir "${extension}/share/mozilla/extensions")) 0;
                  in
                  {
                    install_url = "file://${extension}/share/mozilla/extensions/${uuid}/${extension.addonId}.xpi";
                    installation_mode = "force_installed";
                    default_area = "menupanel";

                    private_browsing = builtins.elem extension allowInPrivateBrowsing;
                  };
              }) extensions
            )
          );

          # Create locked preferences
          mkLockedAttrs = builtins.mapAttrs (
            _: value: {
              Value = value;
              Status = "locked";
            }
          );
        in
        {
          # Disable autofill
          AutofillAddressEnabled = false;
          AutofillCreditCardEnabled = false;

          # Disable certain aspects of the browser
          DisableAppUpdate = true;
          DisableFirefoxStudies = true;
          DisableFormHistory = true;
          DisableSetDesktopBackground = true;
          DisableTelemetry = true;

          # Do not notify for not being a default browser
          DontCheckDefaultBrowser = true;

          # Enable tracking protection
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Category = "strict";
          };

          # Manage browser extensions
          ExtensionSettings = mkExtensionSettings (
            with pkgs.nur.repos.rycee.firefox-addons;
            [
              proton-pass
              ublock-origin
            ]
          );

          # Use HTTPS-only mode for all windows
          HttpsOnlyMode = "force_enabled";

          # Prevent installation of extensions by default
          InstallAddonsPermission = {
            Default = false;
          };

          # Empty bookmarks
          ManagedBookmarks = [ ];

          # Do not create default bookmarks
          NoDefaultBookmarks = true;

          # Do not offer to save passwords
          OfferToSaveLogins = false;

          # Set browser preferences
          Preferences = mkLockedAttrs {
            # Ctrl+Tab cycles through tabs in recently used order
            "browser.ctrlTab.sortByRecentlyUsed" = true;

            # Contrast Control - Automatic (use system settings)
            "browser.display.document_color_use" = 0;

            # Show search suggestions
            "browser.search.suggest.enabled" = true;

            # Show search suggestions in Private Windows
            "browser.search.suggest.enabled.private" = false;

            # Ask before closing multiple tabs
            "browser.tabs.warnOnClose" = true;

            # Show search suggestions ahead of browsing history in address bar results
            "browser.urlbar.showSearchSuggestionsFirst" = false;

            # Show recent searches
            "browser.urlbar.suggest.recentsearches" = false;
          };

          # Ask each time a file is downloaded
          PromptForDownloadLocation = true;

          # Set locales for web browsing
          RequestedLocales = [
            "en-GB"
            "en-US"
            "en"
            "ko-KR"
          ];

          # Manage search engine settings
          SearchEngines = rec {
            # Add search engines
            Add = [
              {
                Name = "DuckDuckGo";
                URLTemplate = "https://duckduckgo.com/?q={searchTerms}";
                Method = "GET";
                IconURL = "https://duckduckgo.com/favicon.ico";
                Alias = "duckduckgo";
                Description = "DuckDuckGo Search";
                SuggestURLTemplate = "https://duckduckgo.com/ac/?q={searchTerms}&kl=wt-wt";
              }
            ];

            # Set default search engine to the first entry
            Default = (builtins.elemAt Add 0).Name;

            # Prevent websites from installing search engines
            PreventInstalls = true;

            # Start downloads in a temporary directory
            StartDownloadsInTempDirectory = true;
          };
        };
    };
  };
}
