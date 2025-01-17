if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Created by `pipx` on 2025-01-15 17:39:07
set PATH $PATH /Users/mstark/.local/bin
set -gx PATH ~/.local/bin $PATH

#Theme	
set -gx TERM xterm-256color

#fzf.fish configure keybindings
bind \co _fzf_search_directory



eval "$(/opt/homebrew/bin/brew shellenv)"
