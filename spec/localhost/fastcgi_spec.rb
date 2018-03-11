require 'spec_helper'
require 'shellwords'

if property["fastcgi"] == 'php-fpm' then

  describe file('/var/run/php-fpm') do
    it { should be_directory }
    it { should be_owned_by 'vagrant' }
    it { should be_grouped_into 'vagrant' }
  end

  describe file('/var/log/php-fpm') do
    it { should be_directory }
    it { should be_owned_by 'vagrant' }
    it { should be_grouped_into 'vagrant' }
  end

  describe file('/usr/sbin/php-fpm') do
    it { should be_file }
    it { should be_mode 755 }
  end

  if os[:family] == 'redhat' && os[:release] =~ /^6/
      describe file('/etc/init.d/php-fpm') do
        it { should be_file }
        it { should be_mode 755 }
      end
  end

  if os[:family] == 'redhat' && os[:release] =~ /^7/
      describe file('/usr/lib/systemd/system/php-fpm.service') do
        it { should be_file }
      end

      describe file('/etc/sysconfig/php-fpm') do
        it { should be_file }
      end

      describe file('/etc/tmpfiles.d/php-fpm.conf') do
        it { should be_file }
      end
  end

  describe command('php-fpm -v') do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
  end

  describe service('php-fpm') do
    it { should be_enabled }
    it { should be_running }
  end

  if os[:family] == 'redhat' && os[:release] =~ /^6/ && property["server"] == 'apache'
    describe port(9000) do
      it { should be_listening }
    end
  else
    describe file('/var/run/php-fpm/php-fcgi.pid') do
      it { should be_socket }
      it { should be_owned_by 'vagrant' }
      it { should be_grouped_into 'vagrant' }
    end
  end

  describe command("ps -C php-fpm -o user") do
    its(:stdout) { should match /vagrant/ }
  end

elsif property["fastcgi"] == 'hhvm' then

  describe file('/var/log/hhvm/') do
   it { should be_directory }
   it { should be_owned_by 'vagrant' }
   it { should be_grouped_into 'vagrant' }
  end

  describe yumrepo('hop5'), :if => os[:release] =~ /^6/ do
    it { should exist }
  end

  describe package('hhvm') do
    it { should be_installed }
  end

  describe service('hhvm') do
    it { should be_enabled }
    it { should be_running }
  end

  describe command("ps -C hhvm -o user") do
    its(:stdout) { should match /vagrant/ }
  end

  describe file('/etc/hhvm/server.ini') do
    it { should be_file }
  end

  describe file('/etc/init.d/hhvm'), :if => os[:release] =~ /^6/ do
    it { should be_file }
  end

  describe file('/usr/lib/systemd/system/hhvm.service'), :if => os[:release] =~ /^7/ do
    it { should be_file }
  end

  describe file('/var/run/hhvm/hhvm.sock') do
    it { should be_socket }
    it { should be_owned_by 'vagrant' }
    it { should be_grouped_into 'vagrant' }
  end

end
