require 'spec_helper'
require 'shellwords'

if property["database"] == 'mysql' then

  describe command('mysqld -V'), :if => os[:family] == 'redhat' || os[:family] == 'debian' || (os[:family] == 'ubuntu' && os[:release] == '14.04') do
    its(:stdout) { should match /#{Regexp.escape('5.6')}/ }
  end

  describe command('mysqld -V'), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
    its(:stdout) { should match /#{Regexp.escape('5.7')}/ }
  end

  describe package('mysql-community-server') do
    it { should be_installed }
  end

  describe yumrepo('mysql56-community'), :if => os[:family] == 'redhat' do
    it { should exist }
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

  describe command('apt-cache policy | grep mysql-5.6'), :if => os[:family] == 'debian' || (os[:family] == 'ubuntu' && os[:release] == '14.04') do
    its(:stdout) { should match /#{Regexp.escape('mysql-5.6')}/ }
  end

  describe command('apt-cache policy | grep mysql-5.7'), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
    its(:stdout) { should match /#{Regexp.escape('mysql-5.7')}/ }
  end

  describe package('python-mysqldb'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe service('mysql'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/var/lib/mysql/mysql.sock') do
    it { should be_socket }
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
  end

  describe file('/etc/my.cnf') do
    it { should be_file }
  end
elsif property["database"] == 'mariadb' then

  describe command('mysql -V'), :if => os[:family] == 'redhat' || os[:family] == 'debian' || (os[:family] == 'ubuntu' && os[:release] == '16.04') do
    its(:stdout) { should match /#{Regexp.escape('10.1')}/ }
  end

  describe command('mysqld -V'), :if => os[:family] == 'ubuntu' && os[:release] == '14.04' do
    its(:stdout) { should match /#{Regexp.escape('10.1')}/ }
  end

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

  describe package('mariadb-server-10.1'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
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

  describe file('/var/lib/mysql/mysql.sock'), :if => os[:family] == 'redhat' do
    it { should be_socket }
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
  end

  describe file('/var/run/mysqld/mysqld.sock'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_socket }
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
  end

  describe file('/etc/my.cnf') do
    it { should be_file }
  end
elsif property["database"] == 'percona' then

  describe command('mysqld -V') do
    its(:stdout) { should match /#{Regexp.escape('5.6')}/ }
  end

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

  describe file('/var/lib/mysql/mysql.sock'), :if => os[:family] == 'redhat' do
    it { should be_socket }
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
  end

  describe file('/var/run/mysqld/mysqld.sock'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_socket }
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
  end

  describe file('/etc/my.cnf') do
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

  describe file('/var/log/mysql') do
    it { should be_directory }
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
  end
end
