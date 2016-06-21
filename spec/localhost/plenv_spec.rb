require 'spec_helper'
require 'shellwords'

if property["perl_version"] != 0 then

  [property["perl_version"]].each do |perl_version|
    describe command("plenv versions | grep #{perl_version}") do
      let(:disable_sudo) { true }
      its(:stdout) { should match(/#{Regexp.escape(perl_version)}/) }
    end
  end

  describe command('plenv global') do
    let(:disable_sudo) { true }
    its(:stdout) { should match property["perl_version"] }
  end

  describe file('/home/vagrant/.plenv/plugins/perl-build') do
    it { should be_directory }
  end

  describe package('/home/vagrant/.plenv/shims/Carton') do
    # it { should be_installed.by('cpanm') }
  end

end
