function gc
    set repo $argv[1]
    set dir $argv[2]

    if test (count $argv) -lt 1
        echo "usage: gc username/repo [folder]"
        return 1
    end

    if string match -q "http*" $repo
        git clone $repo $dir
    else
        git clone https://github.com/$repo.git $dir
    end
end
