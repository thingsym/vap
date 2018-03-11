require 'spec_helper'
require 'shellwords'

if property["server"] == 'apache' then

  describe package('httpd'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe package('httpd-devel'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe service('httpd'), :if => os[:family] == 'redhat' do
    it { should be_enabled }
    it { should be_running }
  end

  describe command("ps -C httpd -o user") do
    its(:stdout) { should match /vagrant/ }
  end

  describe file('/etc/httpd/conf/httpd.conf'), :if => os[:family] == 'redhat' do
    it { should be_file }
  end

  describe file('/etc/httpd/conf.d/www.conf'), :if => os[:family] == 'redhat' && os[:release] == '7' do
    it { should be_file }
  end

  describe package('apache2'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('apache2-dev'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe service('apache2'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/apache2/apache2.conf'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_file }
  end

  describe file('/etc/apache2/apache2.conf'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_file }
  end

  describe file('/etc/apache2/sites-available/000-default.conf'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_file }
  end

  describe file('/etc/apache2/sites-available/default-ssl.conf'), :if => ( os[:family] == 'debian' || os[:family] == 'ubuntu' ) && property["ssl"] do
    it { should be_file }
  end

elsif property["server"] == 'nginx' then

  describe yumrepo('nginx'), :if => os[:family] == 'redhat' do
    it { should exist }
  end

  describe package('nginx') do
    it { should be_installed }
  end

  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end

  describe command("ps -C nginx -o user") do
    its(:stdout) { should match /vagrant/ }
  end

  describe file('/etc/nginx/nginx.conf') do
    it { should be_file }
  end

  describe file('/etc/nginx/conf.d/www.conf') do
    it { should be_file }
  end

elsif property["server"] == 'h2o' then

  describe yumrepo('bintray-tatsushid-h2o-rpm'), :if => os[:family] == 'redhat' do
    it { should exist }
  end

  describe package('h2o') do
    it { should be_installed }
  end

  describe service('h2o') do
    it { should be_enabled }
    it { should be_running }
  end

  describe command("ps -C h2o -o user") do
    its(:stdout) { should match /vagrant/ }
  end

  describe file('/etc/h2o/h2o.conf') do
    it { should be_file }
  end

  describe file('/var/run/h2o') do
    it { should be_directory }
  end

end

if property["server"] != 'none' then
  describe port(80) do
    it { should be_listening }
  end

  if property["ssl"] then
    describe port(443) do
      it { should be_listening }
    end
  end
end
