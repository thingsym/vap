require 'spec_helper'
require 'shellwords'

if property["ssl"] then

  describe package('openssl') do
    it { should be_installed }
  end

end
