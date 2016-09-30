require 'spec_helper'
require 'shellwords'

if property["java_version"] != 0 then

  [property["java_version"]].each do |java_version|
    describe command("jenv versions | grep #{java_version}") do
      let(:sudo_options) { '-u vagrant -i' }
      its(:stdout) { should match(/#{java_version}/) }
    end
  end

  describe command('jenv global') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:stdout) { should match /#{property["java_version"]}/ }
  end

  describe file('/home/vagrant/.bash_profile') do
    its(:content) { should match /export PATH=\$HOME\/\.jenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(jenv init \-\)"/ }
  end

  describe file('/home/vagrant/.bashrc') do
    its(:content) { should match /export PATH=\$HOME\/\.jenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(jenv init \-\)"/ }
  end

end