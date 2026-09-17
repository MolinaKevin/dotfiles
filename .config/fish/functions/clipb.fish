function clipb
    if test (count $argv) -eq 0
        echo "Usage: clipb <file>"
        return 1
    end

    set file $argv[1]

    if test -f $file
        /bin/cat $file | xclip -selection clipboard
        echo "Content of $file copied to clipboard."
    else
        echo "$file does not exist."
        return 1
    end
end

