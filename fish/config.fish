if status is-interactive
    # Commands to run in interactive sessions can go here
end

function lfcd
    set tmp (mktemp)
    lf -last-dir-path="$tmp" $argv
    if test -f "$tmp"
        set dir (cat "$tmp")
        rm -f "$tmp"
        if test -d "$dir"
            cd "$dir"
        end
    end
end


starship init fish | source

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
fish_add_path $HOME/.local/bin

# pnpm
set -gx PNPM_HOME "/Users/advait/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end


fish_add_path /Users/advait/go/bin

# dns.toys
alias dy="dig +short $argv @dns.toys"

# git aliases

alias gd="git diff"
alias gs="git status"
alias gl="git log"
alias gaa="git add -A"
alias gc="git clone"
alias gst="git stash"
alias gsa="git stash apply"

# MegaLLM Configuration
export MEGALLM_API_KEY="sk-mega-019bbd3ba59fe171cdd826c24d13a062df4e50a5aec33bd77efeb8f68f5e6808"

# MegaLLM Configuration
export ANTHROPIC_BASE_URL="https://ai.megallm.io"

# MegaLLM Configuration
export ANTHROPIC_API_KEY="sk-mega-019bbd3ba59fe171cdd826c24d13a062df4e50a5aec33bd77efeb8f68f5e6808"
