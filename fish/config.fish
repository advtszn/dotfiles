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
fish_add_path $HOME/flutter/bin


# dns.toys
alias dy="dig +short $argv @dns.toys"

# git aliases

alias gd="git diff"
alias gs="git status"
alias gl="git log"
alias gaa="git add -A"
alias gst="git stash"
alias gsa="git stash apply"

export  CLAUDE_CODE_MAX_OUTPUT_TOKENS=256000

# MegaLLM Configuration
export MEGALLM_API_KEY="sk-mega-215e2809ac15ef5dd1b9dc382ff1a26f4894e76e4a20af28e3ee0092cb10873c"



# MegaLLM Configuration
export ANTHROPIC_BASE_URL="https://ai.megallm.io"

# MegaLLM Configuration
export ANTHROPIC_API_KEY="sk-mega-215e2809ac15ef5dd1b9dc382ff1a26f4894e76e4a20af28e3ee0092cb10873c"
