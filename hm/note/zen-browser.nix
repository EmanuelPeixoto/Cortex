{ inputs, pkgs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.default
  ];

  programs.zen-browser = {
    enable = true;
    nativeMessagingHosts = [ pkgs.keepassxc ];
    policies = {
      DisableWelcomePages = true;
      DisablePocket = true;
      DisableTelemetry = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      TranslateEnabled = false;
      SearchEngines = {
        Default = "DuckDuckGo";
        PreventInstalls = true;
        Remove = [
          "Google"
          "Bing"
          "eBay"
          "Wikipedia"
          "Perplexity"
        ];
      };
    };
    profiles.default = {
      name = "default";
      isDefault = true;
      settings = {
        "browser.download.autohideButton" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.didSkipDefaultBrowserCheck" = true;
        "browser.translation.detectLanguage" = false;
        "browser.translation.enable" = false;
        "browser.translation.ui.show" = false;
        "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["keepassxc-browser_keepassxc_org-browser-action","gelprec_smd_gmail_com-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","vertical-spacer","urlbar-container","unified-extensions-button","ublock0_raymondhill_net-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs"],"vertical-tabs":[],"PersonalToolbar":["personal-bookmarks"],"zen-sidebar-top-buttons":[],"zen-sidebar-foot-buttons":["downloads-button","zen-workspaces-button","zen-expand-sidebar-button"]},"seen":["developer-button","screenshot-button","keepassxc-browser_keepassxc_org-browser-action","gelprec_smd_gmail_com-browser-action","ublock0_raymondhill_net-browser-action"],"dirtyAreaCache":["nav-bar","vertical-tabs","zen-sidebar-foot-buttons","PersonalToolbar","toolbar-menubar","TabsToolbar","zen-sidebar-top-buttons","unified-extensions-area","widget-overflow-fixed-list"],"currentVersion":23,"newElementCount":9}'';
        "intl.locale.requested" = "pt-BR,en-US";
        "zen.tabs.show-newtab-vertical" = false;
        "zen.tabs.vertical.right-side" = true;
        "zen.view.show-newtab-button-top" = false;
        "zen.view.use-single-toolbar" = false;
      };
      mods = [
        "2317fd93-c3ed-4f37-b55a-304c1816819e" # Audio Indicator Enhanced
        "c6813222-6571-4ba6-8faf-58f3343324f6" # Disable Rounded Corners
        "5941aefd-67b0-453d-9b62-9071a31cbb0d" # Smaller Compact Mode
        "22c9ec3b-7c62-46ae-991f-c8fff5046829" # Tab Numbers
        "c8d9e6e6-e702-4e15-8972-3596e57cf398" # Zen Back Forward
      ];
    };
  };
}
