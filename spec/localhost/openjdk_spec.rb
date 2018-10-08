require 'spec_helper'
require 'shellwords'

if property["java_version"] != 0 then

  describe command('which java') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
  end

  describe command('java -version') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:stderr) { should match /#{Regexp.escape(property["java_version"].to_s)}/ }
  end

end