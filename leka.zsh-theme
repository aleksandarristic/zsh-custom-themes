# leka.zsh-theme — two-line prompt extending robbyrussell
#
# Color palette: dark-gray time, lime-green user, white @, dark-purple host,
# bright-lime cwd, blue git delimiters, red branch, yellow dirty, green/red ➜.
# Host switches to bold white on SSH so remote sessions are visually loud.
#
# Line 1: time  user@host  cwd (git-root-relative when in a repo)  git-info
# Line 2: ➜  (red on non-zero exit, green on success)
#
# Install:
#   cp leka.zsh-theme ~/.oh-my-zsh/custom/themes/leka.zsh-theme
#   set ZSH_THEME="leka" in ~/.zshrc
#   exec zsh

# ---- user@host colors -----------------------------------------------------
# user: lime green, @: white, host: dark purple locally / bold white on SSH.
if [[ -n "$SSH_CONNECTION" || -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
  _leka_user_color="%F{120}"
  _leka_at_color="%F{7}"
  _leka_host_color="%B%F{white}"
else
  _leka_user_color="%F{120}"
  _leka_at_color="%F{7}"
  _leka_host_color="%F{128}"
fi

# ---- cwd: git-root-relative when in a repo --------------------------------
# Outside a repo: ~/full/path
# Inside a repo:  repo-name ⟨path/inside/repo⟩
_leka_cwd() {
  local git_root repo_name rel
  git_root=$(command git rev-parse --show-toplevel 2>/dev/null)
  if [[ -z "$git_root" ]]; then
    print -rn -- "%F{118}%~%f"
    return
  fi
  repo_name=${git_root:t}
  rel=${PWD#$git_root}
  rel=${rel#/}

  # Build gray prefix: parent dir of repo root, with $HOME collapsed to ~
  local prefix=${git_root:h}
  prefix=${prefix/#${HOME}/\~}
  local gray_prefix
  [[ "$prefix" == "/" ]] && gray_prefix="/" || gray_prefix="${prefix}/"

  local out="%F{245}${gray_prefix}%f%F{120}${repo_name}%f"
  [[ -n "$rel" ]] && out+=" %B%F{blue}⟨%f%b%F{118}${rel}%f%B%F{blue}⟩%f%b"
  print -rn -- "$out"
}

# ---- git info -------------------------------------------------------------
# Format: git:(branch) ✗ +N ~N ?N ↑N ↓N
# Branch red, delimiters bold blue, dirty ✗ yellow — robbyrussell classic.
# Counts kept for utility: +staged (green), ~modified (yellow), ?untracked (red).
_leka_git() {
  local branch status_output
  branch=$(command git symbolic-ref --short HEAD 2>/dev/null) \
    || branch=$(command git rev-parse --short HEAD 2>/dev/null) \
    || return

  status_output=$(command git status --porcelain=v1 -b 2>/dev/null)

  local ahead=0 behind=0
  if [[ -n "$status_output" ]]; then
    local header=${status_output%%$'\n'*}
    [[ $header =~ 'ahead ([0-9]+)' ]]  && ahead=$match[1]
    [[ $header =~ 'behind ([0-9]+)' ]] && behind=$match[1]
  fi

  local staged=0 modified=0 untracked=0 dirty=0
  if [[ -n "$status_output" ]]; then
    local line
    while IFS= read -r line; do
      [[ "$line" == '##'* || -z "$line" ]] && continue
      local x=${line[1]} y=${line[2]}
      [[ "$x$y" == '??' ]] && { (( untracked++ )); continue }
      [[ "$x" != ' ' && "$x" != '?' ]] && (( staged++ ))
      [[ "$y" != ' ' && "$y" != '?' ]] && (( modified++ ))
    done <<< "$status_output"
  fi
  (( dirty = staged + modified + untracked ))

  # git:(branch) — bold blue parens, red branch.
  local out=" %B%F{blue}git:(%f%b%F{red}${branch}%f%B%F{blue})%f%b"
  (( dirty > 0 ))     && out+=" %F{yellow}✗%f"
  (( staged > 0 ))    && out+=" %F{green}+${staged}%f"
  (( modified > 0 ))  && out+=" %F{yellow}~${modified}%f"
  (( untracked > 0 )) && out+=" %F{red}?${untracked}%f"
  (( ahead > 0 ))     && out+=" %F{cyan}↑${ahead}%f"
  (( behind > 0 ))    && out+=" %F{cyan}↓${behind}%f"

  print -rn -- "$out"
}

# ---- assemble the prompt --------------------------------------------------
setopt PROMPT_SUBST

PROMPT='┌─ %F{240}%D{%H:%M:%S}%f ${_leka_user_color}%n%f${_leka_at_color}@%f${_leka_host_color}%m%f%b  $(_leka_cwd)$(_leka_git)
└─ %(?:%F{green}➜%f :%F{red}➜%f ) '

RPROMPT=''
