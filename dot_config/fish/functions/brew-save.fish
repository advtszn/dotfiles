function brew-save --description "Regenerate ~/.Brewfile from what's installed and copy it into chezmoi"
    # VS Code extensions and npm globals are left out on purpose
    brew bundle dump --file ~/.Brewfile --force --no-vscode --no-npm; or return 1

    # local-path cargo installs (your own projects) can't be reinstalled from crates.io
    sed -i '' '/^cargo "rust-backend"$/d' ~/.Brewfile

    # third-party formulae are included once trusted: brew trust --formula <tap/name>
    chezmoi add ~/.Brewfile; and echo "Brewfile updated. Review with: chezmoi git diff"
end
