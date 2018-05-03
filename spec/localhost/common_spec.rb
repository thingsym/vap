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

describe command('apt-cache policy | grep ansible'), :if => os[:family] == 'debian' do
  its(:stdout) { should match /#{Regexp.escape('ansible')}/ }
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

describe package('chrony'), :if => os[:family] == 'redhat' && os[:release] == '7' do
  it { should be_installed }
end

describe service('chronyd'), :if => os[:family] == 'redhat' && os[:release] == '7' do
  it { should be_enabled }
  it { should be_running }
end

describe package('ntp'), :if => ( os[:family] == 'redhat' && os[:release] == '6' ) || os[:family] == 'debian' || os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe service('ntpd'), :if => os[:family] == 'redhat' && os[:release] == '6' do
  it { should be_enabled }
  it { should be_running }
end

describe service('ntp'), :if => os[:family] == 'debian' || ( os[:family] == 'ubuntu' && os[:release] == '16.04' ) do
  it { should be_enabled }
  it { should be_running }
end

describe service('ntpd'), :if => os[:family] == 'ubuntu' && os[:release] == '14.04' do
  it { should be_running }
end

describe service('ntp'), :if => os[:family] == 'ubuntu' && os[:release] == '14.04' do
  it { should be_enabled }
end

describe yumrepo('epel'), :if => os[:family] == 'redhat' do
  it { should exist }
end

describe yumrepo('ius'), :if => os[:family] == 'redhat' do
  it { should exist }
end

describe command('ansible --version') do
  its(:exit_status) { should eq 0 }
end

describe file('/home/vagrant/.bashrc_vap') do
  it { should be_file }
end

describe file('/home/vagrant/.bashrc_vap') do
  its(:content) { should match /export PATH=\/usr\/local\/bin:\/usr\/bin:\/bin:\/usr\/sbin:\/sbin:\/usr\/local\/sbin:\$PATH/ }
end

describe file('/home/vagrant/.bashrc'), :if => os[:family] == 'redhat' do
  its(:content) { should match /if \[ \-f ~\/\.bashrc_vap \]; then\n        \. ~\/\.bashrc_vap\nfi/ }
end

describe file('/home/vagrant/.profile'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
  its(:content) { should match /if \[ \-f ~\/\.bashrc_vap \]; then\n        \. ~\/\.bashrc_vap\nfi/ }
end

describe package('sysv-rc-conf'), :if => os[:family] == 'ubuntu' && os[:release] == '14.04' do
  it { should be_installed }
end

describe package('apt-transport-https'), :if => os[:family] == 'debian' do
  it { should be_installed }
end
