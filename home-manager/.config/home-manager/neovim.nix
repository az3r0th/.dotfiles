{ pkgs, ... }:
{
  home.packages = with pkgs; [
    #Fonts
    nerd-fonts.jetbrains-mono
    #Devel
    nodejs_23
    go
    rustc
    rustfmt
    go
    cargo
    luajitPackages.luarocks
    tree-sitter
    stylua
    shfmt
    black
    alejandra

    #Utils
    ripgrep
    fd
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
  xdg.configFile."nvim".source = "/home/azeroth/.dotfiles/nvim";
}
