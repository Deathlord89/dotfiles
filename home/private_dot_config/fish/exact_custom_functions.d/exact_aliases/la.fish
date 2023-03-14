function la --description 'List contents of directory, including hidden files in directory.'
    if command -sq exa
        exa -lagh --icons --git -t modified $argv
    else
        ls -lah $argv
    end
end