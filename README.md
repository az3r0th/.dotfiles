# Dotfiles

This repository contains my personal dotfiles managed with GNU Stow.

## Prerequisites

- GNU Stow
- Git
- Nix (for home-manager and nix-darwin configurations)

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Install individual configurations using stow:
   ```bash
   # Install everything
   stow */
   
   # Or install specific packages
   stow zsh          # Shell configuration
   stow nvim         # Neovim editor
   stow tmux         # Terminal multiplexer
   stow lazygit      # Git TUI
   stow k9s          # Kubernetes TUI
   stow nix          # Nix package manager
   stow home-manager # Nix home-manager
   stow nix-darwin   # Nix for macOS
   ```

## Package Structure

- `zsh/` - ZSH shell configuration
- `nvim/` - Neovim configuration
- `tmux/` - Tmux configuration
- `lazygit/` - Lazygit configuration
- `k9s/` - K9s Kubernetes TUI configuration
- `nix/` - Nix package manager configuration
- `home-manager/` - Nix home-manager configuration
- `nix-darwin/` - Nix configuration for macOS

Each package directory mirrors the structure of your home directory, making it easy for stow to create the appropriate symlinks. The general structure for each package is:

```
package_name/
└── .config/
    └── package_name/
        └── configuration files
```

## Updating

To update the configurations:

1. Make changes to the files in the respective package directories
2. Commit and push your changes
3. On other machines, pull the changes and restow if needed:
   ```bash
   cd ~/.dotfiles
   git pull
   stow -R */  # Restow everything
   ```

## Notes

- For Nix-based configurations (home-manager, nix-darwin), you may need to run additional commands after stowing:
  ```bash
  home-manager switch  # For home-manager
  darwin-rebuild switch  # For nix-darwin
  ``` 