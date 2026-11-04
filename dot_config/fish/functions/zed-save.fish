function zed-save --description "Copy Zed settings into chezmoi, minus ssh_connections"
    chezmoi execute-template '{{ $s := include (joinPath .chezmoi.homeDir ".config/zed/settings.json") | fromJsonc }}{{ $_ := unset $s "ssh_connections" }}{{ toPrettyJson "  " $s }}' >(chezmoi source-path)/.chezmoitemplates/zed-settings.json
    and echo "zed settings copied (ssh_connections excluded). Review with: chezmoi git diff"
end
