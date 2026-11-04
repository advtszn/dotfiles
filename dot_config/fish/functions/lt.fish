function lt
    lsd --tree \
        --depth 2 \
        --icon=never \
        --group-dirs first \
        --date '+%b %d %H:%M' \
        $argv
end
