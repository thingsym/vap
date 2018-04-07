require 'spec_helper'
require 'shellwords'

if property["python_version"] != 0 then
  describe file('/home/vagrant/.pyenv/') do
    it { should be_directory }
    it { should be_owned_by 'vagrant' }
    it { should be_grouped_into 'vagrant' }
  end

  describe command('which pyenv') do
    let(:sudo_options) { '-u vagrant -i'}
    its(:exit_status) { should eq 0 }
  end

  describe command('which python') do
    let(:sudo_options) { '-u vagrant -i'}
    its(:exit_status) { should eq 0 }
  end

  [property["python_version"]].each do |python_version|
    describe command("pyenv versions | grep #{python_version}") do
      let(:sudo_options) { '-u vagrant -i' }
      its(:stdout) { should match(/#{Regexp.escape(python_version)}/) }
    end
  end

  describe command('python -V') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:stdout) { should match /#{Regexp.escape(property["python_version"])}/ }
  end

  describe command('pyenv global') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:stdout) { should match property["python_version"] }
  end

  describe file('/home/vagrant/.bashrc') do
    its(:content) { should match /export PATH=\$HOME\/\.pyenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(pyenv init \-\)"/ }
  end


  describe package('zlib-devel'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe package('bzip2'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe package('readline-devel'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe package('sqlite'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe package('sqlite-devel'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe package('openssl-devel'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe package('xz'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe package('xz-devel'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe package('make'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('build-essential'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('libssl-dev'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('zlib1g-dev'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('libbz2-dev'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('libreadline-dev'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('libsqlite3-dev'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('wget'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('curl'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('llvm'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('libncurses5-dev'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('libncursesw5-dev'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('xz-utils'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('tk-dev'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

end
