function ll --description 'List contents of directory.'
    if command -sq exa
        exa -lgh --icons --git -t modified $argv
    else
        ls -lh $argv
    end
end