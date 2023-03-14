# git
if type -q git
  abbr g 'git'
  abbr ga 'git add .'
  abbr gaa 'git add --all'
  abbr gc 'git commit'
  abbr gcm 'git commit -m'
  abbr gst 'git status'
  abbr gp 'git push'
  abbr gpl 'git pull'
  abbr gl 'git log'
  abbr gd 'git diff'
  abbr gr 'git restore .'
end

# chezmoi
if type -q chezmoi
  abbr c 'chezmoi'
  abbr ca 'chezmoi apply'
  abbr cu 'chezmoi update'
  abbr ce 'chezmoi edit --apply'
  abbr cs 'chezmoi status'
  abbr cc 'chezmoi cd'
end

# docker-compose
if type -q docker-compose
  abbr docup 'docker-compose up -d'
  abbr docdn 'docker-compose down'
  abbr docl 'docker-compose logs'
  abbr doclf 'docker-compose logs -f'
  abbr docpull 'docker-compose pull'
end