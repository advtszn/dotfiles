# Homebrew first, so later conf.d files (fnm, cargo, uv…) can still prepend ahead of it
/opt/homebrew/bin/brew shellenv fish | source
