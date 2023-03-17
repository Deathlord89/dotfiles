control 'Essential packages' do
    #impact 7.0
    title 'should be installed'
    
    env_brew_apps = %w[
      asdf
      bat
      chezmoi
      exa
      fd
      fish
      gpg
      ranger
      starship
      xclip
    ]

    env_brew_apps.each do |env_brew_app|
      describe command("/home/linuxbrew/.linuxbrew/bin/#{env_brew_app}") do
        it { should exist }
      end
    end

end