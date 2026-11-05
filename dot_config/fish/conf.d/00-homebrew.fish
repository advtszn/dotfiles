# Homebrew first, so later conf.d files (cargo, uv…) can still prepend ahead of it
test -x /opt/homebrew/bin/brew; and /opt/homebrew/bin/brew shellenv fish | source
