# -*- mode: ruby -*-
# vi: set ft=ruby :

## Vagrant Settings ##

vm_box                = 'bento/centos-7.2'
# vm_box                = 'bento/centos-6.7'
# vm_box                = 'bento/debian-8.6' # jessie
# vm_box                = 'bento/ubuntu-16.04' # Xenial Xerus
# vm_box                = 'bento/ubuntu-14.04' # Trusty Tahr

vm_ip                 = '192.168.59.63'
vm_box_version        = '>= 0'
vm_hostname           = 'vap.local'
vm_document_root      = '/var/www/html'

public_ip             = ''

vbguest_auto_update = false

## That's all, stop setting. ##

provision = <<-EOT
  set -e
  if [ -e /etc/os-release ]; then
    DISTR=$(awk '/PRETTY_NAME=/' /etc/os-release | sed 's/PRETTY_NAME=//' | sed 's/"//g' | awk '{print $1}' | tr '[:upper:]' '[:lower:]')
    if [ -e /etc/redhat-release ]; then
      VERSION=$(awk '{print $4}' /etc/redhat-release)
    elif [ "$DISTR" = "debian" ] && [ -e /etc/debian_version ]; then
      VERSION=$(awk '{print $1}' /etc/debian_version)
    else
      VERSION=$(awk '/VERSION_ID=/' /etc/os-release | sed 's/VERSION_ID=//' | sed 's/"//g')
    fi
    MAJOR=$(awk '/VERSION_ID=/' /etc/os-release | sed 's/VERSION_ID=//' | sed 's/"//g' | sed -E 's/\.[0-9]{2}//g')
    if [ -e /etc/lsb-release ]; then
      RELEASE=$(awk '/DISTRIB_CODENAME=/' /etc/lsb-release | sed 's/DISTRIB_CODENAME=//' | sed 's/"//g' | tr '[:upper:]' '[:lower:]')
    else
      RELEASE=$(awk '/PRETTY_NAME=/' /etc/os-release | sed 's/"//g' | awk '{print $4}' | sed 's/[()]//g' | tr '[:upper:]' '[:lower:]')
    fi
  elif [ -e /etc/redhat-release ]; then
    DISTR=$(awk '{print $1}' /etc/redhat-release | tr '[:upper:]' '[:lower:]')
    VERSION=$(awk '{print $3}' /etc/redhat-release)
    MAJOR=$(awk '{print $3}' /etc/redhat-release | sed -E 's/\.[0-9]+//g')
    RELEASE=$(awk '{print $4}' /etc/redhat-release | sed 's/[()]//g' | tr '[:upper:]' '[:lower:]')
  fi
  ARCH=$(uname -m)
  BITS=$(uname -m | sed 's/x86_//;s/amd//;s/i[3-6]86/32/')

  echo '[OS Info]'
  echo 'DISTRIBUTE:' $DISTR
  echo 'ARCHITECTURE:' $ARCH
  echo 'BITS:' $BITS
  echo 'RELEASE:' $RELEASE
  echo 'VERSION:' $VERSION
  echo 'MAJOR:' $MAJOR

  if [ "$DISTR" = "centos" ]; then
    echo $MAJOR > /etc/yum/vars/releasever
    yum clean all
    yum -y install epel-release
  fi

  if [ "$DISTR" = "debian" ] && [ "$RELEASE" = "jessie" ]; then
    echo 'deb http://ftp.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/backports.list
    apt-get update
    if [ #{ansible_install_mode} = "default" ]; then
      apt-get -y install -t jessie-backports ansible
    fi
  fi
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
      "--cableconnected1", "on",
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
