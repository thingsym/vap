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

describe package('python-pip') do
  it { should be_installed }
end

describe package('pkg-config'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('curl') do
  it { should be_installed }
end
