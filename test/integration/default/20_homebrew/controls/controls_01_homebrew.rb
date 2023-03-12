control 'Hombrew' do
    title 'should be installed'
    
    describe.one do
        describe command('/home/linuxbrew/.linuxbrew/bin/brew') do
            it { should exist }
        end

        #describe describe command('/home/vagrant/.local/bin/brew') do
        #    it { should exist }
        #end
    end

end
