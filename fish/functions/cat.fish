function cat
    # Fallback if glow isn't installed
        if not type -q glow
                command cat $argv
                return
        end
    
        # Only intercept: cat <single markdown file>
        if test (count $argv) -eq 1
                and test -f $argv[1]
                and string match -qr '\.(md|markdown)$' $argv[1]
        
                glow $argv[1]
                return
        end
    
        # Everything else: pure cat
        command cat $argv
end
