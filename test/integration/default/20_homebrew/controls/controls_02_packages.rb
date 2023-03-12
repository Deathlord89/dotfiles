control 'Essential packages' do
    #impact 7.0
    title 'should be installed'
    
    #env_brew_path = '/home/linuxbrew/.linuxbrew/bin/'
    env_brew_apps = %w[chezmoi fish]

    env_brew_apps.each do |env_brew_app|
      #describe command(File.join(env_brew_path, env_brew_apps)) do
      describe command("/home/linuxbrew/.linuxbrew/bin/#{env_brew_app}") do
        it { should exist }
      end
    end


end