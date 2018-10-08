require 'spec_helper'
require 'shellwords'

if property["perl_version"] != 0 then
  describe file('/home/vagrant/.plenv/') do
    it { should be_directory }
    it { should be_owned_by 'vagrant' }
    it { should be_grouped_into 'vagrant' }
  end

  describe command('which plenv') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.plenv\/bin\/plenv/) }
  end

  describe command('which perl') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.plenv\/shims\/perl/) }
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

  describe file('/home/vagrant/.bashrc_vap') do
    its(:content) { should match /export PATH=\$HOME\/\.plenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(plenv init \-\)"/ }
  end

  describe file('/home/vagrant/.plenv/plugins/perl-build') do
    it { should be_directory }
  end

  describe command('which cpanm') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.plenv\/shims\/cpanm/) }
  end

  describe command('cpanm -v') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
  end

  describe command('which carton') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.plenv\/shims\/carton/) }
  end

  describe command('carton -v') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
  end

  describe command('which start_server') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
  end

end
