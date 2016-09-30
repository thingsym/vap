require 'spec_helper'
require 'shellwords'

if property["go_version"] != 0 then

  [property["go_version"]].each do |go_version|
    describe command("goenv versions | grep #{go_version}") do
      let(:sudo_options) { '-u vagrant -i' }
      its(:stdout) { should match /#{Regexp.escape(go_version)}/ }
    end
  end

  describe command('go version') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:stdout) { should match /#{Regexp.escape(property["go_version"])}/ }
  end

  describe command('goenv version') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:stdout) { should match property["go_version"] }
  end

  describe file('/home/vagrant/.bash_profile') do
    its(:content) { should match /export PATH=\$HOME\/\.goenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(goenv init \-\)"/ }
  end

  describe file('/home/vagrant/.bashrc') do
    its(:content) { should match /export PATH=\$HOME\/\.goenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(goenv init \-\)"/ }
  end

end