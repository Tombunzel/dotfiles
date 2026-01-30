if not status is-interactive
    # exit if not running interactively
    exit
end

# -------------------------------------
# --- 1. Core Environment and Setup ---
# -------------------------------------

eval "$(/opt/homebrew/bin/brew shellenv)"

# Basic environment variables
set -gx EDITOR nvim
set -gx TERM xterm-256color
set fish_greeting ""

# -------------------------------------
# --- 1.1 Clear universal variables ---
# ---   (Migration for Fish 4.3+)   ---
# -------------------------------------

# 1. Wipe the old universal keybinding variable
set --erase --universal fish_key_bindings

# 2. Wipe the old universal color variables
set --universal --names | grep '^fish_color_' | xargs set --erase --universal 2>/dev/null or true
set --universal --names | grep '^fish_pager_color_' | xargs set --erase --universal 2>/dev/null or true

# ---------------------------------------------
# --- 2. Tool Configuration (fzf, NVM, Go, etc) ---
# ---------------------------------------------

# fzf configuration
set -x FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude build --exclude dist'
fzf --fish | source

# NVM (Node Version Manager)
set -x NVM_DIR $HOME/.nvm

# Go
set -g GOPATH $HOME/go

# bun
set --export BUN_INSTALL "$HOME/.bun"

# -------------------------------------
# --- 3. PATH Management          ---
# -------------------------------------
# All PATHs are prepended here using the correct fish syntax.
# Duplicates from the original file have been removed.

set -gx PATH $HOME/bin $PATH
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $GOPATH/bin $PATH
set -gx PATH $BUN_INSTALL/bin $PATH
set -gx PATH /opt/homebrew/opt/libpq/bin $PATH # For postgresql clients
set -gx PATH ./node_modules/.bin $PATH # Project-local node binaries

# -------------------------------------
# --- 4. Aliases                    ---
# -------------------------------------

alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g git
command -qv nvim && alias vim nvim
alias killadobe='pkill -f "Adobe|Creative|CCXProcess|Core Sync|IPC Broker" && echo "💥 Adobe processes killed."'

# -------------------------------------
# --- 5. Theme & Prompt             ---
# -------------------------------------

# Theme settings
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# Syntax Highlighting Colors (Migrated from Fish 4.3 auto-config)
set --global fish_color_autosuggestion brblack
set --global fish_color_cancel -r
set --global fish_color_command normal
set --global fish_color_comment red
set --global fish_color_cwd green
set --global fish_color_cwd_root red
set --global fish_color_end green
set --global fish_color_error brred
set --global fish_color_escape brcyan
set --global fish_color_history_current --bold
set --global fish_color_host normal
set --global fish_color_host_remote yellow
set --global fish_color_normal normal
set --global fish_color_operator brcyan
set --global fish_color_param cyan
set --global fish_color_quote yellow
set --global fish_color_redirection cyan --bold
set --global fish_color_search_match white --background=brblack
set --global fish_color_selection white --bold --background=brblack
set --global fish_color_status red
set --global fish_color_user brgreen
set --global fish_color_valid_path --underline
set --global fish_pager_color_completion normal
set --global fish_pager_color_description yellow -i
set --global fish_pager_color_prefix normal --bold --underline
set --global fish_pager_color_progress brwhite --background=cyan
set --global fish_pager_color_selected_background -r

# -----------------------------------------------------------
# --- 6. Sourced Configurations (OS-specific, local, prompt) --
# -----------------------------------------------------------

# OS-specific settings
switch (uname)
    case Darwin
        source (dirname (status --current-filename))/config-osx.fish
    case Linux
        source (dirname (status --current-filename))/config-linux.fish
    case '*'
        # Fallback for other systems, e.g., Windows
        # source (dirname (status --current-filename))/config-windows.fish
end

set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end

starship init fish | source

function __my_fzf_file_finder
    fzf --height=40% --layout=reverse | read -l selected_file

    if test -n "$selected_file"
        commandline --insert " $selected_file"
    end

    commandline --function repaint
end

function fish_user_key_bindings
    bind \cT __my_fzf_file_finder
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tombunzel/Downloads/google-cloud-sdk/path.fish.inc' ]
    . '/Users/tombunzel/Downloads/google-cloud-sdk/path.fish.inc'
end
