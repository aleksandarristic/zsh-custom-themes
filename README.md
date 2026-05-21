# zsh-custom-themes

A collection of custom oh-my-zsh themes.

## Themes

### [leka](themes/leka.zsh-theme)

Two-line prompt extending robbyrussell with git-root-relative paths, detailed git status counts, and visually distinct SSH sessions.

<details>
<summary>Prompt layout & details</summary>

```
┌─ 14:32:01 username@hostname  ~/projects/myrepo ⟨src/components⟩  git:(main) ✗ +1 ~2 ?1 ↑3
└─ ➜
```

**Line 1 segments**

| Segment | Description |
|---|---|
| `14:32:01` | Current time (dark gray) |
| `username` | Current user (lime green) |
| `@hostname` | Host (dark purple; bold white on SSH) |
| path | Outside a repo: `~/full/path`. Inside a repo: gray parent + green repo name + `⟨path/inside⟩` |
| `git:(branch)` | Current branch (blue delimiters, red branch name) |
| `✗` | Dirty working tree (yellow) |
| `+N ~N ?N` | Staged / modified / untracked counts |
| `↑N ↓N` | Commits ahead / behind remote (cyan) |

**Line 2:** `➜` — green on success, red on non-zero exit.

</details>

## Installation

**Install or update all themes:**

```zsh
curl -fsSL https://raw.githubusercontent.com/aleksandarristic/zsh-custom-themes/main/install.sh | zsh
```

**Install or update a specific theme:**

```zsh
curl -fsSL https://raw.githubusercontent.com/aleksandarristic/zsh-custom-themes/main/install.sh | zsh -s -- leka
```

Then set the theme in `~/.zshrc`:

```zsh
ZSH_THEME="leka"
```

Reload:

```zsh
exec zsh
```

### Manual install

```zsh
cp themes/leka.zsh-theme ~/.oh-my-zsh/custom/themes/
```

## Requirements

- [oh-my-zsh](https://ohmyz.sh)
- Terminal with 256-color support
- Font that renders `➜ ⟨ ⟩ ✗ ↑ ↓`
