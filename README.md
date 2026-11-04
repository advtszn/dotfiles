# dotfiles

Managed with [chezmoi](https://www.chezmoi.io/). Pre-commit hook runs gitleaks.

New machine:

    brew install chezmoi gitleaks
    chezmoi init --apply <github-user>

Daily use:

    chezmoi re-add          # pull in edits made directly to managed files
    chezmoi add <file>      # start tracking a new file
    chezmoi cd              # open a shell in this repo, then git commit/push

Homebrew packages live in `~/.Brewfile` and are installed on apply.
After installing or removing packages, run `brew-save` (fish) to refresh it.
