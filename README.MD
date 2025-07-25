# My Zsh Configuration

A clean, powerful, and modern Zsh setup with intelligent auto-completion, syntax highlighting, and fuzzy finding. Perfect for system administrators who want a productive terminal experience.

## Features

- **Smart Auto-suggestions** - Intelligent command suggestions based on history
- **Syntax Highlighting** - Real-time command validation and coloring
- **Fuzzy Finding** - Lightning-fast file and history search with FZF
- **Auto-pairing** - Automatic bracket, quote, and parenthesis completion
- **Starship Prompt** - Beautiful, informative, and lightning-fast prompt
- **Multi-distro Support** - Works on Ubuntu, Debian, Arch, Fedora, and Alpine
- **Clean Aliases** - Productive shortcuts for Git, Docker, and system commands

## Preview

```bash
🚀 ~/projects/my-app on  main [!?] via 🐍 v3.11.0 
❯ git s█
  git status  # Smart suggestion appears as you type
```

## What's Included

### Plugins
- **zsh-autosuggestions** - Fish-like auto suggestions
- **zsh-syntax-highlighting** - Syntax highlighting for commands
- **zsh-completions** - Additional completion definitions
- **zsh-autopair** - Auto-close brackets and quotes
- **FZF integration** - Fuzzy finder for files, history, and directories

### Tools
- **Starship** - Cross-shell prompt with Git integration
- **FZF** - Command-line fuzzy finder
- **Bat** - Cat clone with syntax highlighting
- **Tree** - Directory structure visualization

### Smart Aliases
```bash
# Git shortcuts
g     -> git
gs    -> git status
ga    -> git add
gc    -> git commit

# Navigation
..    -> cd ..
...   -> cd ../..
work  -> cd ~/workspace

# Docker shortcuts
dockls    -> docker container ls
dockprune -> docker system prune -a
```

## Quick Install

```bash
# Clone this repository
git clone https://github.com/Maaseh/zsh-dotfiles.git
cd zsh-dotfiles

# Run the installation script
chmod +x install.sh
sudo ./install.sh

# Restart your terminal or run:
source ~/.zshrc
```

## Manual Installation

If you prefer to install manually:

### 1. Install packages
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install zsh-autosuggestions zsh-syntax-highlighting fzf bat tree

# Arch Linux
sudo pacman -S zsh-autosuggestions zsh-syntax-highlighting fzf bat tree

# Fedora
sudo dnf install zsh fzf bat tree
```

### 2. Install Starship
```bash
curl -sS https://starship.rs/install.sh | sh
```

### 3. Copy configuration files
```bash
mkdir -p ~/.config/zsh
cp zsh/* ~/.config/zsh/
cp zsh/.zshenv ~/
```

### 4. Install auto-pairing plugin
```bash
git clone https://github.com/hlissner/zsh-autopair ~/.config/zsh/plugins/zsh-autopair
```

### 5. Change default shell
```bash
chsh -s $(which zsh)
```

## File Structure

```
~/.config/zsh/
├── .zshrc          # Main configuration
├── aliases.zsh     # Command aliases
├── exports.zsh     # Environment variables
├── functions.zsh   # Custom functions
├── plugins.zsh     # Plugin configurations
├── completions/    # Custom completions
└── plugins/
    └── zsh-autopair/
```

## Key Bindings

| Key Binding | Action |
|-------------|--------|
| `Ctrl + R` | Fuzzy search command history |
| `Ctrl + T` | Fuzzy find files |
| `Alt + C`  | Fuzzy change directory |
| `→` (Right Arrow) | Accept auto-suggestion |
| `Alt + F` | Accept one word of suggestion |

## Customization

### Change Colors
Edit `~/.config/zsh/plugins.zsh` to customize syntax highlighting colors:

```bash
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan,bold'
```

### Add Your Own Aliases
Edit `~/.config/zsh/aliases.zsh`:

```bash
# Add your custom aliases here
alias myproject="cd ~/path/to/project"
alias serve="python -m http.server 8000"
```

### Modify Starship Prompt
The Starship configuration is in `starship.toml`. Customize it to your liking!

## Contributing

Found a bug or want to suggest an improvement?

1. Fork this repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Starship](https://starship.rs/) - The beautiful prompt
- [FZF](https://github.com/junegunn/fzf) - The amazing fuzzy finder
- [Zsh Users](https://github.com/zsh-users) - For the incredible plugins
- The entire Zsh community for making the shell awesome

---

**Star this repo if it helped you!**

