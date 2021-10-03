require 'spec_helper'
require 'shellwords'

if property["scala_version"] != 0 && property["java_version"] != 0 then
  describe file('/home/vagrant/.scalaenv/') do
    it { should be_directory }
    it { should be_owned_by 'vagrant' }
    it { should be_grouped_into 'vagrant' }
  end

  describe command('which scalaenv') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.scalaenv\/bin\/scalaenv/) }
  end

  describe command('which scala') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.scalaenv\/shims\/scala/) }
  end

  [property["scala_version"]].each do |scala_version|
    describe command("scalaenv versions | grep #{scala_version}") do
      let(:sudo_options) { '-u vagrant -i' }
      its(:stdout) { should match(/#{Regexp.escape(scala_version)}/) }
    end
  end

  describe command('scala -version') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:stderr) { should match /#{Regexp.escape(property["scala_version"])}/ }
  end

  describe command('scalaenv global') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:stdout) { should match property["scala_version"] }
  end

  describe file('/home/vagrant/.bashrc_alias') do
    its(:content) { should match /export PATH=\$HOME\/\.scalaenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(scalaenv init \-\)"/ }
  end

end
