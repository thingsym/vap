# -*- mode: ruby -*-
# vi: set ft=ruby :

## Vagrant Settings ##

vm_box                = 'hansode/centos-7.1.1503-x86_64'
# vm_box                = 'hansode/centos-6.7-x86_64'
vm_ip                 = '192.168.59.63'
vm_box_version        = '>= 0'
vm_hostname           = 'vap.local'
vm_document_root      = '/var/www/html'

public_ip             = ''

vbguest_auto_update = false

## That's all, stop setting. ##

provision = <<-EOT
  if [ -e /etc/os-release ]; then
    MAJOR=$(awk '/VERSION_ID=/' /etc/os-release | sed 's/VERSION_ID=//' | sed 's/"//g' | sed -E 's/\.[0-9]{2}//g')
  elif [ -e /etc/redhat-release ]; then
    MAJOR=$(awk '{print $3}' /etc/redhat-release | sed -E 's/\.[0-9]+//g')
  fi
  echo $MAJOR > /etc/yum/vars/releasever

  yum clean all
  yum -y install epel-release
EOT

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = vm_box
  config.vm.box_version = vm_box_version

  config.vm.network :private_network, ip: vm_ip
  config.vm.hostname = vm_hostname

  if public_ip != ''
    config.vm.network :public_network, ip: public_ip
  end

  config.vm.synced_folder '.', '/vagrant', :create => 'true'
  config.vm.synced_folder 'html/', vm_document_root, :create => 'true'

  config.ssh.forward_agent = true

  if Vagrant.has_plugin?("vagrant-hostsupdater")
    config.hostsupdater.remove_on_suspend = true
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = vbguest_auto_update
  end

  config.vm.provider "virtualbox" do |vb|
    # vb.gui = true
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize [
      "modifyvm", :id,
      "--memory", "1536",
      '--natdnshostresolver1', 'on',
      '--natdnsproxy1', 'on',
    ]
  end

  config.vm.provision :shell, :inline => provision

  config.vm.provision "ansible_local" do |ansible|
    ansible.version = 'latest'
    ansible.inventory_path = 'hosts/local'
    ansible.playbook = 'site.yml'
    ansible.verbose = 'v'
    ansible.extra_vars = {
      HOSTNAME: vm_hostname,
      DOCUMENT_ROOT: vm_document_root
    }
  end

  if File.exist?("Rakefile")
    if Vagrant.has_plugin?("vagrant-serverspec")
      config.vm.provision :serverspec do |spec|
        spec.pattern = "spec/localhost/*_spec.rb"
      end
    end
  end

end
