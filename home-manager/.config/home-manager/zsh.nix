{
  config,
  pkgs,
  ...
}: let
  p10k-config = ''
    # Enable Powerlevel10k instant prompt. Should stay close to the top.
    if [[ -r "${config.xdg.configHome}/zsh/.p10k.zsh" ]]; then
      source "${config.xdg.configHome}/zsh/.p10k.zsh"
    fi
  '';
in {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = "${config.xdg.configHome}/zsh";

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "zsh-autosuggestions" "zsh-syntax-highlighting"];
      theme = "powerlevel10k/powerlevel10k";
    };

    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
      gp = "git push";
      ga = "git add .";
    };

    sessionVariables = {
      EDITOR = "nvim";
      PATH = "$HOME/.local/bin:$PATH";
    };

    initExtra = p10k-config;
  };

  home.packages = with pkgs; [
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];
}
