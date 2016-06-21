require 'spec_helper'
require 'shellwords'

if property["fastcgi"] == 'php-fpm' then

  describe file('/var/run/php-fpm') do
    it { should be_directory }
    it { should be_owned_by 'nginx' }
    it { should be_grouped_into 'nginx' }
  end

  describe file('/var/log/php-fpm') do
    it { should be_directory }
    it { should be_owned_by 'nobody' }
    it { should be_grouped_into 'nobody' }
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

end
