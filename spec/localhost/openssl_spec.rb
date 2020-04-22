require 'spec_helper'
require 'shellwords'

if property["ssl"] then

  describe package('openssl') do
    it { should be_installed }
  end

  describe command('openssl version') do
    its(:stdout) { should match /#{Regexp.escape('1.0.2f')}/ }
    its(:exit_status) { should eq 0 }
  end

  describe file("/etc/pki/tls/vap") do
    it { should be_directory }
  end

  describe file("/etc/pki/tls/vap/privkey.pem") do
    it { should be_file }
  end

  describe file("/etc/pki/tls/vap/csr.pem") do
    it { should be_file }
  end

  describe file("/etc/pki/tls/vap/crt.pem") do
    it { should be_file }
  end

end
