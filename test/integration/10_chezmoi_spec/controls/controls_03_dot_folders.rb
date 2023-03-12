control 'GPG directory' do
    title 'should be at the right place'
    
      describe directory("/home/vagrant/.gnupg") do
        it { should exist }
        its('owner') { should eq "vagrant" }
         its('mode') { should cmp '0700' }
      end
end

control 'Config directory' do
    title 'should be at the right place'
    
      describe directory("/home/vagrant/.config") do
        it { should exist }
        its('owner') { should eq "vagrant" }
         its('mode') { should cmp '0700' }
      end
end