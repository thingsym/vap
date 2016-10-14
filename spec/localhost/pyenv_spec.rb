require 'spec_helper'
require 'shellwords'

if property["python_version"] != 0 then
  describe file('/home/vagrant/.pyenv/') do
    it { should be_directory }
    it { should be_owned_by 'vagrant' }
    it { should be_grouped_into 'vagrant' }
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

  describe file('/home/vagrant/.bash_profile') do
    its(:content) { should match /export PATH=\$HOME\/\.pyenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(pyenv init \-\)"/ }
  end

  describe file('/home/vagrant/.bashrc') do
    its(:content) { should match /export PATH=\$HOME\/\.pyenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(pyenv init \-\)"/ }
  end

end