require 'spec_helper'
require 'shellwords'

# require "pp"
# pp property

describe user('root') do
  it { should exist }
end

describe user('vagrant') do
  it { should exist }
end

describe command('ansible --version') do
  its(:exit_status) { should eq 0 }
end

describe package('libselinux-python'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe selinux, :if => os[:family] == 'redhat' do
  it { should_not be_enforcing }
end

describe service('iptables'), :if => os[:family] == 'redhat' && os[:release] == '6' do
  it { should_not be_enabled }
  it { should_not be_running }
end

describe service('firewalld'), :if => os[:family] == 'redhat' && os[:release] == '7' do
  it { should_not be_enabled }
  it { should_not be_running }
end

describe package('ntp') do
  it { should be_installed }
end

describe service('ntpd'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe service('ntp'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running }
end

describe yumrepo('epel'), :if => os[:family] == 'redhat' do
  it { should exist }
end

describe yumrepo('ius'), :if => os[:family] == 'redhat' do
  it { should exist }
end

describe file('/home/vagrant/.bash_profile') do
  its(:content) { should match /export PATH=\/usr\/local\/bin:\/usr\/bin:\/bin:\/usr\/sbin:\/sbin:\/usr\/local\/sbin:\$PATH/ }
end

describe file('/home/vagrant/.bashrc') do
  its(:content) { should match /export PATH=\/usr\/local\/bin:\/usr\/bin:\/bin:\/usr\/sbin:\/sbin:\/usr\/local\/sbin:\$PATH/ }
end
