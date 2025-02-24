{
  programs.terminator = {
    enable = true;
    config = {
      global_config = {
        title_hide_size = true;
      };
      profiles.default = {
        font = "JetBrainsMono Nerd Font 12";
        foreground_color = "#00ff00";
        background_darkness = "0.95";
        cursor_color = "#f38ba8";
        icon_bell = false;
        show_titlebar = false;
        background_type = "transparent";
        pallette = "#1f2229:#d41919:#5ebdab:#fea44c:#367bf0:#9755b3:#49aee6:#e6e6e6:#198388:#ec0101:#47d4b9:#ff8a18:#277fff:#962ac3:#05a1f7:#ffffff";
        use_system_font = false;
        title_transmit_fg_color = "#000000";
        title_transmit_bg_color = "#35e410";
      };
    };
  };
}
