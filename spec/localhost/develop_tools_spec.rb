require 'spec_helper'
require 'shellwords'

describe package('patch') do
  it { should be_installed }
end

describe package('yum-utils'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('build-essential'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('software-properties-common'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('python2-pip'), :if => os[:family] == 'redhat' && os[:release] == '7' do
  it { should be_installed }
end

describe package('python-pip'), :if => os[:family] == 'redhat' && os[:release] == '6' do
  it { should be_installed }
end

describe package('python-pip'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('pkg-config'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('debconf-utils'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('curl') do
  it { should be_installed }
end

describe package('libcurl'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('libcurl-devel'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('jq') do
  it { should be_installed }
end
