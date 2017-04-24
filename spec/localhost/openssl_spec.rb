require 'spec_helper'
require 'shellwords'

if property["ssl"] then

  describe package('openssl') do
    it { should be_installed }
  end

  describe command('openssl version') do
    its(:stdout) { should match /#{Regexp.escape('1.0.2k')}/ }
    its(:exit_status) { should eq 0 }
  end

  describe file("/etc/pki/tls/vap") do
    it { should be_directory }
  end

  describe file("/etc/pki/tls/vap/vap.key") do
    it { should be_file }
  end

  describe file("/etc/pki/tls/vap/vap.csr") do
    it { should be_file }
  end

  describe file("/etc/pki/tls/vap/vap.crt") do
    it { should be_file }
  end


  describe file('/usr/lib/ssl') do
    it { should be_directory }
  end

  describe file("/usr/lib/ssl/server.key") do
    it { should be_file }
  end

  describe file("/usr/lib/ssl/server.csr") do
    it { should be_file }
  end

  describe file('/etc/pki/tls/openssl.cnf'), :if => os[:family] == 'redhat' do
    its(:content) { should match /\.\/demoCA/ }
  end

  describe file("/usr/lib/ssl/server.crt") do
    it { should be_file }
  end

  describe file('/usr/lib/ssl/demoCA/private') do
    it { should be_directory }
  end

  describe file('/usr/lib/ssl/demoCA/crl') do
    it { should be_directory }
  end

  describe file('/usr/lib/ssl/demoCA/certs') do
    it { should be_directory }
  end

  describe file('/usr/lib/ssl/demoCA/newcerts') do
    it { should be_directory }
  end

  describe file('/usr/lib/ssl/demoCA/serial') do
    it { should be_file }
    its(:content) { should match /02/ }
    it { should be_mode 644 }
  end

  describe file('/usr/lib/ssl/demoCA/index.txt') do
    it { should be_file }
    it { should be_mode 644 }
  end

end
