control 'Chezmoi' do
    title 'should be installed'
    
    describe.one do
        describe command('/home/linuxbrew/.linuxbrew/bin/chezmoi') do
            it { should exist }
        end
        describe command('/home/vagrant/.local/bin/chezmoi') do
            it { should exist }
        end
    end

    describe file('/home/vagrant/.config/chezmoi/chezmoi.toml') do
        it { should exist }
        its('owner') { should eq "vagrant" }
    end

end
