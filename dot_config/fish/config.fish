# ── PATH ──────────────────────────────────────────────
# fish_add_path skips entries already present, so nested shells don't duplicate
set -gx BUN_INSTALL $HOME/.bun
set -gx PNPM_HOME $HOME/Library/pnpm
fish_add_path $BUN_INSTALL/bin $PNPM_HOME/bin $HOME/.local/bin $HOME/go/bin $HOME/.grok/bin $HOME/.opencode/bin

if status is-interactive
    starship init fish | source

    function lfcd
        set tmp (mktemp)
        lf -last-dir-path="$tmp" $argv
        if test -f "$tmp"
            set dir (command cat "$tmp")
            rm -f "$tmp"
            test -d "$dir"; and cd "$dir"
        end
    end

    # dns.toys
    alias dy 'dig +short @dns.toys'

    alias claude 'claude --dangerously-skip-permissions'

    # ── git ──
    abbr -a gd git diff
    abbr -a gs git status
    abbr -a gl git log
    abbr -a gaa git add -A
    abbr -a gst git stash
    abbr -a gsa git stash apply
    abbr -a gck git checkout
    abbr -a gcm git commit
    abbr -a gp git push
    abbr -a gpl git pull

    # ── js ──
    abbr -a bnd bun dev
    abbr -a brb bun run build
    abbr -a pnd pnpm dev

    # ── tmuxinator ──
    abbr -a mux tmuxinator
    abbr -a muxc tmuxinator copy
    abbr -a muxd tmuxinator delete
    abbr -a muxe tmuxinator edit
    abbr -a muxl tmuxinator list
    abbr -a muxn tmuxinator new
    abbr -a muxs tmuxinator start

    abbr -a z zed
end
