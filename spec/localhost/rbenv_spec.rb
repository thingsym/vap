require 'spec_helper'
require 'shellwords'

if property["ruby_version"] != 0 then

  [property["ruby_version"]].each do |ruby_version|
    describe command("rbenv versions | grep #{ruby_version}") do
      let(:sudo_options) { '-u vagrant -i' }
      its(:stdout) { should match(/#{Regexp.escape(ruby_version)}/) }
    end
  end

  describe command('ruby -v') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:stdout) { should match /#{Regexp.escape(property["ruby_version"])}/ }
  end

  describe command('rbenv global') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:stdout) { should match property["ruby_version"] }
  end

  describe file('/home/vagrant/.bash_profile') do
    its(:content) { should match /export PATH=\$HOME\/\.rbenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(rbenv init \-\)"/ }
  end

  describe file('/home/vagrant/.bashrc') do
    its(:content) { should match /export PATH=\$HOME\/\.rbenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(rbenv init \-\)"/ }
  end

  describe file('/home/vagrant/.rbenv/plugins/ruby-build') do
    it { should be_directory }
  end

  describe file('/home/vagrant/.rbenv/plugins/rbenv-gem-rehash') do
    it { should be_directory }
  end

  describe file('/home/vagrant/.rbenv/plugins/rbenv-default-gems') do
    it { should be_directory }
  end

  describe file('/home/vagrant/.rbenv/plugins/rbenv-bundler') do
    it { should be_directory }
  end

  # describe command('bundler --version') do
  #   let(:sudo_options) { '-u vagrant -i' }
  #   its(:exit_status) { should eq 0 }
  # end

  describe package('gcc') do
    it { should be_installed }
  end

  describe package('cmake') do
    it { should be_installed }
  end

  describe package('openssl-devel') do
    it { should be_installed }
  end

  describe package('libyaml-devel') do
    it { should be_installed }
  end

  describe package('readline-devel') do
    it { should be_installed }
  end

  describe package('zlib-devel') do
    it { should be_installed }
  end

end