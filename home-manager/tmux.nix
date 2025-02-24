{pkgs, ...}: let
  catppuccin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "unstable-2024-05-15";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "cce60abc8efd7a641a5fcc8001e6b3ae61e8d5fe";
      hash = "sha256-d2S6mlo21JGvueSZjANTB437lbUa76e5X0Ad4hdb2Zk=";
    };
    postInstall = ''
      sed -i -e 's|''${PLUGIN_DIR}/catppuccin-selected-theme.tmuxtheme|''${TMUX_TMPDIR}/catppuccin-selected-theme.tmuxtheme|g' $target/catppuccin.tmux
    '';
  };
in {
  programs.tmux = {
    enable = true;
    shell = "/usr/bin/zsh";
    terminal = "tmux-256color";
    historyLimit = 100000;
    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.tmux-fzf
      tmuxPlugins.sensible
      tmuxPlugins.open
      tmuxPlugins.better-mouse-mode
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
          set -g status-right 'Continuum status: #{continuum_status}'
        '';
      }
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }

      {
        plugin = catppuccin;
        extraConfig = ''
          # Options to make tmux more pleasant
          set -g terminal-overrides 'xterm*:smcup@:rmcup@'
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"


          # Make the status line pretty and add some modules
          set -g @catppuccin_status_background "#242638"
          set -g @catppuccin_window_current_text " #{E:window_name}"
          set -g @catppuccin_window_text " #{E:window_name}"
          set -g status-right-length 100
          set -g status-left-length 100
          set -g status-left "#{?client_prefix,#[fg=#{@thm_red} bold]PREFIX ,#{?#{==:#{pane_mode},copy-mode},#[fg=#{@thm_yellow} bold]COPY ,#[fg=#{@thm_green} bold]NORMAL }}"
          set -g status-right "#{E:@catppuccin_status_application}"
        '';
      }
    ];
    extraConfig = ''
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf
      bind % split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"

      set -g prefix c-a
      set -g mouse on

      setw -g mode-keys vi
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi V send -X select-line
      bind-key -T copy-mode-vi 'C-v' send -X begin-selection \; send -X rectangle-toggle
      bind-key -T copy-mode-vi y send -X copy-selection-and-cancel

      # start index at 1
      set -g base-index 1
      set -g pane-base-index 1

      # renumber when window is closed
      set -g renumber-window on

      # movement between the panes
      bind-key l select-pane -L
      bind-key h select-pane -R
      bind-key k select-pane -U
      bind-key j select-pane -D

      # Set the status bar postion at top
      set-option -g status-position top

    '';
  };
}
