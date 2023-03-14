function ls --description 'List contents of directory.'
    if command -sq exa
        exa $argv
    else
        ls $argv
    end
end