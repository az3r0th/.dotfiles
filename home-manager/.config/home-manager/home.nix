{
  home.username = "azeroth";
  home.homeDirectory = "/home/azeroth";

  home.stateVersion = "25.05";

  home.file = {};

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  imports = [
    ./terminator.nix
    ./git.nix
    ./neovim.nix
    ./home-manager.nix
    ./tmux.nix
    ./zsh.nix
  ];
}
