# Shell Aliases

This is a collection of aliases, which can be used in your shell.

I'm using ZSH, but it could also be used in BASH or SH.

---

## Fuzzy find history

You know about using ctrl+r to search in history, what if we could fuzzy find
what command we needed and then execute it?

Requirments is fzf. So please install the tool, with the package manager you are
using.

Add the snippet below to .zshrc or bashrc, source your shell and then you should
be able to fuzzy find:

```bash
fuzzy_history() {
    history | awk '{$1=$2=$3=""; print $0}' | sort -u | fzf | {
        IFS= read -r cmd
        if [ -n "$cmd" ]; then
            echo "\$ $cmd" # Echo the command
            eval "$cmd"
        fi
    }
}
alias fh="fuzzy_history"
```

---

## Fuzzy find git commit history

Same as before but with colors and you can now search in commits.

Requirments is fzf. So please install the tool, with the package manager you are
using.

Add the snippet below to .zshrc or bashrc, source your shell and then you should
be able to fuzzy find:

```bash
alias fg='git log --graph --color=always --abbrev-commit --date=relative --format="%C(auto)%h%d %C(blue)%ad %C(yellow)%s %C(green)[%an]" --all | fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort --header="Press CTRL-S to toggle sort"'
```

To use it, simply navigate to a git folder and use the alias.

---
