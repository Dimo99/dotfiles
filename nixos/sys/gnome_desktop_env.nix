{pkgs, ...}: {
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Needed for Home Manager to be able to update DConf settings
  # See: https://github.com/nix-community/home-manager/blob/f911ebbec927e8e9b582f2e32e2b35f730074cfc/modules/misc/dconf.nix#L25-L26
  programs.dconf.enable = true;

  hardware.pulseaudio.enable = false;
  # bluez needs pulseaudio CLI tools to be installed
  environment.systemPackages = [pkgs.pulseaudio];

  security.rtkit.enable = true;

  services.blueman.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    media-session.config.bluez-monitor.rules = [
      {
        # Matches all cards
        matches = [{"device.name" = "~bluez_card.*";}];
        actions = {
          "update-props" = {
            "bluez5.reconnect-profiles" = ["hfp_ag" "hfp_hf" "hsp_hs" "a2dp_sink"];
            # mSBC is not expected to work on all headset + adapter combinations.
            "bluez5.msbc-support" = true;
            # SBC-XQ is not expected to work on all headset + adapter combinations.
            "bluez5.sbc-xq-support" = true;
          };
        };
      }
      {
        matches = [
          # Matches all sources
          {"node.name" = "~bluez_input.*";}
          # Matches all outputs
          {"node.name" = "~bluez_output.*";}
        ];
      }
    ];
  };
}
