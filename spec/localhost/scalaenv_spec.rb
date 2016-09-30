require 'spec_helper'
require 'shellwords'

if property["scala_version"] != 0 && property["java_version"] != 0 then

  [property["scala_version"]].each do |scala_version|
    describe command("scalaenv versions | grep #{scala_version}") do
      let(:sudo_options) { '-u vagrant -i' }
      its(:stdout) { should match(/#{Regexp.escape(scala_version)}/) }
    end
  end

  # describe command('/home/vagrant/.scalaenv/shims/scala -version') do
  #   let(:sudo_options) { '-u vagrant -i' }
  #   its(:stdout) { should match /#{Regexp.escape(property["scala_version"])}/ }
  # end

  describe command('scalaenv global') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:stdout) { should match property["scala_version"] }
  end

  describe file('/home/vagrant/.bash_profile') do
    its(:content) { should match /export PATH=\$HOME\/\.scalaenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(scalaenv init \-\)"/ }
  end

  describe file('/home/vagrant/.bashrc') do
    its(:content) { should match /export PATH=\$HOME\/\.scalaenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(scalaenv init \-\)"/ }
  end

end