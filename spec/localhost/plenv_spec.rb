require 'spec_helper'
require 'shellwords'

if property["perl_version"] != 0 then
  describe file('/home/vagrant/.plenv/') do
    it { should be_directory }
    it { should be_owned_by 'vagrant' }
    it { should be_grouped_into 'vagrant' }
  end

  [property["perl_version"]].each do |perl_version|
    describe command("plenv versions | grep #{perl_version}") do
      let(:sudo_options) { '-u vagrant -i' }
      its(:stdout) { should match(/#{Regexp.escape(perl_version)}/) }
    end
  end

  describe command('perl -v') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:stdout) { should match /#{Regexp.escape(property["perl_version"])}/ }
  end

  describe command('plenv global') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:stdout) { should match property["perl_version"] }
  end

  describe file('/home/vagrant/.plenv/plugins/perl-build') do
    it { should be_directory }
  end

  describe file('/home/vagrant/.plenv/shims/carton') do
    it { should be_file }
  end

end
