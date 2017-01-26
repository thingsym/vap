require 'spec_helper'
require 'shellwords'

describe file('/usr/bin/gibo') do
	it { should be_file }
	it { should be_mode 755 }
end

describe command('which gibo') do
  let(:sudo_options) { '-u vagrant -i'}
  its(:exit_status) { should eq 0 }
end