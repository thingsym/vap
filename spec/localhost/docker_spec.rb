require 'spec_helper'
require 'shellwords'

# require "pp"
# pp property


if property["docker"] then

  describe service('docker') do
    it { should be_running }
  end

  describe yumrepo('docker-ce-stable'), :if => os[:family] == 'redhat' do
    it { should exist }
  end

  describe package('docker-ce') do
    it { should be_installed }
  end

  describe package('docker-ce-cli') do
    it { should be_installed }
  end

  describe package('containerd.io') do
    it { should be_installed }
  end

  describe file('/var/run/docker.sock') do
    it { should be_socket }
  end

  describe command('which docker') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
  end

  describe command('which docker-compose') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
  end

end
