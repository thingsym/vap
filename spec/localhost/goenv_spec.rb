require 'spec_helper'
require 'shellwords'

if property["go_version"] != 0 then
  describe file('/home/vagrant/.goenv/') do
    it { should be_directory }
    it { should be_owned_by 'vagrant' }
    it { should be_grouped_into 'vagrant' }
  end

  describe command('which goenv') do
    let(:sudo_options) { '-u vagrant -i'}
    its(:exit_status) { should eq 0 }
  end

  describe command('which go') do
    let(:sudo_options) { '-u vagrant -i'}
    its(:exit_status) { should eq 0 }
  end

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

  describe file('/home/vagrant/.bashrc_vap') do
    its(:content) { should match /export PATH=\$HOME\/\.goenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(goenv init \-\)"/ }
  end

end