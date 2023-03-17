control 'Dotfiles' do
    title 'should be at the right place'
    
    env_config_files = %w[
      asdfrc
      bashrc
      default-gems
      gemrc
      gitconfig
      gitignore_global
      ]
    
    env_config_files.each do |env_config_file|
      describe file("/home/vagrant/.#{env_config_file}") do
        it { should exist }
        its('owner') { should eq "vagrant" }
      end

    end

end
