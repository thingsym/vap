require 'spec_helper'
require 'shellwords'

describe file('/usr/bin/gibo') do
	it { should be_file }
	it { should be_mode 755 }
end
