function brew-save --description "Regenerate ~/.Brewfile from what's installed and copy it into chezmoi"
    # VS Code extensions and npm globals are left out on purpose
    brew bundle dump --file ~/.Brewfile --force --no-vscode --no-npm; or return 1

    # local-path cargo installs (your own projects) can't be reinstalled from crates.io
    sed -i '' '/^cargo "rust-backend"$/d' ~/.Brewfile

    # dump skips formulae from taps Homebrew doesn't trust, so list them explicitly
    printf '%s\n' \
        '' \
        '# Third-party taps (brew bundle dump omits these)' \
        'brew "advtszn/tap/rook", trusted: true' \
        'brew "kriuchkov/tap/tock", trusted: true' \
        'brew "libsql/sqld/sqld", trusted: true' \
        'brew "mongodb/brew/mongodb-community", trusted: true' \
        'brew "mongodb/brew/mongodb-database-tools", trusted: true' \
        'brew "nats-io/nats-tools/nats", trusted: true' \
        'brew "tursodatabase/tap/turso", trusted: true' >>~/.Brewfile

    chezmoi add ~/.Brewfile; and echo "Brewfile updated. Review with: chezmoi git diff"
end
