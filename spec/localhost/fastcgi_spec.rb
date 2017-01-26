require 'spec_helper'
require 'shellwords'

if property["fastcgi"] == 'php-fpm' then

  describe file('/var/log/php-fpm'), :if => os[:family] == 'redhat' do
    it { should be_directory }
    it { should be_owned_by 'nginx' }
    it { should be_grouped_into 'nginx' }
  end

  describe file('/var/log/php-fpm'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_directory }
    it { should be_owned_by 'www-data' }
    it { should be_grouped_into 'www-data' }
  end

  describe file('/usr/sbin/php-fpm') do
    it { should be_file }
    it { should be_mode 755 }
  end

  describe file('/etc/init.d/php-fpm'), :if => os[:family] == 'redhat' && os[:release] == '6' do
    it { should be_file }
    it { should be_mode 755 }
  end

  describe file('/usr/lib/systemd/system/php-fpm.service'), :if => os[:family] == 'redhat' && os[:release] == '7' do
    it { should be_file }
  end

  describe file('/lib/systemd/system/php-fpm.service'), :if => os[:family] == 'debian' do
    it { should be_file }
  end

  describe file('/lib/systemd/system/php-fpm.service'), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
    it { should be_file }
  end

  describe file('/etc/init.d/php-fpm'), :if => os[:family] == 'ubuntu' && os[:release] == '14.04' do
    it { should be_file }
  end

  describe file('/etc/sysconfig/php-fpm'), :if => os[:family] == 'redhat' && os[:release] == '7' do
    it { should be_file }
  end

  describe command('php-fpm -v') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
  end

  describe service('php-fpm') do
    it { should be_enabled }
    it { should be_running }
  end

end
