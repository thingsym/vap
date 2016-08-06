require 'spec_helper'
require 'shellwords'

if property["node_version"] != 0 then

  [property["node_version"]].each do |node_version|
    describe command("nodenv versions | grep #{node_version}") do
      let(:disable_sudo) { true }
      its(:stdout) { should match(/#{Regexp.escape(node_version)}/) }
    end
  end

  describe command('node -v') do
    let(:disable_sudo) { true }
    its(:stdout) { should match /#{Regexp.escape(property["node_version"])}/ }
  end

  describe command('nodenv global') do
    let(:disable_sudo) { true }
    its(:stdout) { should match property["node_version"] }
  end

  describe file('/home/vagrant/.bash_profile') do
    its(:content) { should match /export PATH=\$HOME\/\.nodenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(nodenv init \-\)"/ }
  end

  describe file('/home/vagrant/.bashrc') do
    its(:content) { should match /export PATH=\$HOME\/\.nodenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(nodenv init \-\)"/ }
  end

  describe file('/home/vagrant/.nodenv/plugins/node-build') do
    it { should be_directory }
  end

  describe file('/home/vagrant/.nodenv/plugins/nodenv-default-packages') do
    it { should be_directory }
  end

end
