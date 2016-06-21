require 'spec_helper'
require 'shellwords'

if property["python_version"] != 0 then

  [property["python_version"]].each do |python_version|
    describe command("pyenv versions | grep #{python_version}") do
      let(:disable_sudo) { true }
      its(:stdout) { should match(/#{Regexp.escape(python_version)}/) }
    end
  end

  describe command('python -V') do
    let(:disable_sudo) { true }
    its(:stdout) { should match /#{Regexp.escape(property["python_version"])}/ }
  end

  describe command('pyenv global') do
    let(:disable_sudo) { true }
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