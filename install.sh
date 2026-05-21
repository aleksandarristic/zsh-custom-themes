#!/usr/bin/env zsh
# Usage:
#   Install/update all themes:
#     curl -fsSL https://raw.githubusercontent.com/aleksandarristic/zsh-custom-themes/main/install.sh | zsh
#
#   Install/update a specific theme:
#     curl -fsSL https://raw.githubusercontent.com/aleksandarristic/zsh-custom-themes/main/install.sh | zsh -s -- leka

set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/aleksandarristic/zsh-custom-themes/main"
THEMES_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes"
ALL_THEMES=(leka)

red()   { printf '\033[31m%s\033[0m\n' "$*"; }
green() { printf '\033[32m%s\033[0m\n' "$*"; }
bold()  { printf '\033[1m%s\033[0m\n'  "$*"; }

if [[ ! -d "${ZSH:-$HOME/.oh-my-zsh}" ]]; then
  red "oh-my-zsh not found. Install it first: https://ohmyz.sh"
  exit 1
fi

mkdir -p "$THEMES_DIR"

if (( $# > 0 )); then
  themes=("$@")
else
  themes=("${ALL_THEMES[@]}")
fi

for theme in "${themes[@]}"; do
  dest="$THEMES_DIR/${theme}.zsh-theme"
  url="$REPO_RAW/themes/${theme}.zsh-theme"
  if curl -fsSL "$url" -o "$dest"; then
    green "Installed ${theme} -> $dest"
  else
    red "Failed to download theme '${theme}' (url: $url)"
    exit 1
  fi
done

echo
bold "Done. To activate a theme, set in ~/.zshrc:"
echo "  ZSH_THEME=\"<theme-name>\""
echo "Then reload: exec zsh"
