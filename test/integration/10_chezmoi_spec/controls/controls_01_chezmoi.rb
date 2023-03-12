control 'Chezmoi package' do
    title 'should be installed'
    
    describe.one do
        describe command('/home/linuxbrew/.linuxbrew/bin/chezmoi') do
            it { should exist }
        end
        describe command('/home/vagrant/.local/bin/chezmoi') do
            it { should exist }
        end
    end
end
control 'Chezmoi config files' do
    title 'should be at the right place'
    
    describe file('/home/vagrant/.config/chezmoi/chezmoi.toml') do
        it { should exist }
        its('owner') { should eq "vagrant" }
    end
end
