require 'spec_helper'
require 'shellwords'

if property["ruby_version"] != 0 then
  describe file('/home/vagrant/.rbenv/') do
    it { should be_directory }
    it { should be_owned_by 'vagrant' }
    it { should be_grouped_into 'vagrant' }
  end

  describe command('which rbenv') do
    let(:sudo_options) { '-u vagrant -i'}
    its(:exit_status) { should eq 0 }
  end

  describe command('which ruby') do
    let(:sudo_options) { '-u vagrant -i'}
    its(:exit_status) { should eq 0 }
  end

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

  describe package('openssl-devel'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe package('libyaml-devel'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe package('readline-devel'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe package('zlib-devel'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe package('libssl-dev'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('libyaml-dev'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('libreadline-dev'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('zlib1g-dev'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

end