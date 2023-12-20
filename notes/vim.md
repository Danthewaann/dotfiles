# Vim/Neovim

## Commands

From: https://stackoverflow.com/a/18877483

Regex replace with an mathematical expression

```vim
:%s/".*ID": \zs\(\d\+\)/\=50 + submatch(1)/
```
