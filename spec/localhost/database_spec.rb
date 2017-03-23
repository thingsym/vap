require 'spec_helper'
require 'shellwords'

if property["database"] == 'mysql' then

  describe yumrepo('mysql56-community'), :if => os[:family] == 'redhat' do
    it { should exist }
  end

  describe package('mysql-community-server'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe package('MySQL-python'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe service('mysqld'), :if => os[:family] == 'redhat' do
    it { should be_enabled }
  end

  describe service('mysql'), :if => os[:family] == 'redhat' && os[:release] == '6' do
    it { should be_running }
  end

  describe service('mysqld'), :if => os[:family] == 'redhat' && os[:release] == '7' do
    it { should be_running }
  end

  describe package('mysql-server-5.5'), :if => os[:family] == 'debian' do
    it { should be_installed }
  end

  describe package('mysql-server-5.7'), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
    it { should be_installed }
  end

  describe package('mysql-server-5.6'), :if => os[:family] == 'ubuntu' && os[:release] == '14.04' do
    it { should be_installed }
  end

  describe package('python-mysqldb'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe service('mysql'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/my.cnf') do
    it { should be_file }
  end
elsif property["database"] == 'mariadb' then

  describe yumrepo('mariadb'), :if => os[:family] == 'redhat' do
    it { should exist }
  end

  describe package('MariaDB-server'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe service('mysql'), :if => os[:family] == 'redhat' && os[:release] == '6' do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('mariadb'), :if => os[:family] == 'redhat' && os[:release] == '7' do
    it { should be_enabled }
    it { should be_running }
  end

  describe package('mariadb-server'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('python-mysqldb'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe service('mariadb'), :if => os[:family] == 'debian' do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('mariadb'), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('mysql'), :if => os[:family] == 'ubuntu' && os[:release] == '14.04' do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/my.cnf') do
    it { should be_file }
  end
elsif property["database"] == 'percona' then

  describe yumrepo('percona-release-noarch'), :if => os[:family] == 'redhat' do
    it { should exist }
  end

  describe package('Percona-Server-server-56'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end

  describe service('mysql'), :if => os[:family] == 'redhat' && os[:release] == '6' do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('mysqld'), :if => os[:family] == 'redhat' && os[:release] == '7' do
    it { should be_enabled }
    it { should be_running }
  end

  describe package('percona-server-server-5.6'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('python-mysqldb'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe service('mysql'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/my.cnf'), :if => os[:family] == 'redhat' do
    it { should be_file }
  end

  describe file('/etc/mysql/my.cnf'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_file }
  end
end

if property["database"] == 'mysql' || property["database"] == 'mariadb' || property["database"] == 'percona' then
  describe port(3306) do
    it { should be_listening }
  end

  describe command("mysqlshow -u root -p#{property["db_root_password"]} mysql") do
    its(:stdout) { should match /Database: mysql/ }
  end

  describe command( "mysqladmin -u root -p#{property["db_root_password"]} ping" ) do
    its(:stdout) { should match /mysqld is alive/ }
  end

end
