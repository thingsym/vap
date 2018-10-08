require 'spec_helper'
require 'shellwords'

describe package('git') do
  it { should be_installed }
end

describe command('which git') do
  let(:sudo_options) { '-u vagrant -i' }
  its(:exit_status) { should eq 0 }
end