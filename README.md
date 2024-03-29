# VAP (Vagrant Ansible Programming languages)

**VAP (Vagrant Ansible Programming languages)** is Ansible playbooks for website developer and programmer.

## Features

### 1. OS Distribution Compatibility

**VAP** support **CentOS**, **Debian** and **Ubuntu** Boxes.

### 2. Build Server and Database environment

**VAP** will build server from **Apache** or **nginx** or **H2O**, and build database from **MySQL**, **MariaDB** or **Percona MySQL**.

On all web servers, FastCGI configuration is possible. Build PHP execution environment from **PHP-FPM** (FastCGI Process Manager).

By default, the server and the databese is installed in the default settings. Also you can edit configuration files.

### 3. Build Programming environment

**VAP** will build a Programming languages that specifies the version.

* [Ruby](https://www.ruby-lang.org/)
* [Python](https://www.python.org/)
* [PHP](https://secure.php.net)
* [Perl](https://www.perl.org/)
* [Node.js](http://nodejs.org)
* [Go](https://golang.org/)
* [Java (OpenJDK)](http://openjdk.java.net/)
* [Scala](http://www.scala-lang.org/)

### 4. Develop & Deploy Tools

You can install the develop tools or the deploy tools by usage. See Specification for list of installed tools.

## Requirements

* [Oracle VM VirtualBox](https://www.virtualbox.org) >= 6.1
* [Vagrant](https://www.vagrantup.com) >= 2.2
* [Ansible](https://www.ansible.com) >= 2.9

#### Optional

* [mkcert](https://github.com/FiloSottile/mkcert)

#### Vagrant plugin (optional)

* [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
* [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)
* [vagrant-serverspec](https://github.com/jvoorhis/vagrant-serverspec)

## Usage

### 1. Install Virtualbox

Download the VirtualBox form [www.virtualbox.org](https://www.virtualbox.org) and install.

### 2. Install Vagrant

Download the Vagrant form [www.vagrantup.com](https://www.vagrantup.com) and install.

### 3. Download Ansible playbooks of VAP

Download a Vagrantfile and Ansible playbooks from the following link.

[Download Zip format file](https://github.com/thingsym/vap/archive/master.zip)

### 4. Generate SSL certificate files using mkcert

Install mkcert. See [https://github.com/FiloSottile/mkcert](https://github.com/FiloSottile/mkcert)

	cd vaw-x.x.x
	mkcert -install
	mkdir mkcert
	cd mkcert
	mkcert -cert-file cert.pem -key-file privkey.pem <vm_hostname>

### 5. Launch a virtual environment

	cd vap-x.x.x
	vagrant up

If you don't have a Box at first, begins from the download of Box. After provisioning, you can launch a Programming environment.

Note: Passwordless for Vagrant::Hostsupdater. See [Suppressing prompts for elevating privileges
](https://github.com/agiledivider/vagrant-hostsupdater#suppressing-prompts-for-elevating-privileges)

### 6. Access to the website

Access to the website **http://vap.local/**, if the server is running.

### 7. Access to a Vagrant machine via SSH

	vagrant ssh

Or using ssh config.

	vagrant ssh-config > ssh_config.cache
	ssh -F ssh_config.cache default

## Default configuration Variables

ID and password for the initial setting is as follows. Can be set in the provisioning configuration file.

#### Database

* ROOT USER `root`
* ROOT PASSWORD `admin`
* HOST `localhost`

## Customize Options
You can build a variety of environment that edit the configuration file of VAP.

There are two configuration files you can customize.

Run `vagrant up` or `vagrant provision`, after editing the configuration file.

### Vagrant configuration file (Ruby)

Vagrant configuration file is **Vagrantfile**.

Vagrantfile will set the vagrant Box, private IP address, hostname and the document root.

If you launch multiple environments, change the name of the directory. you should rewrite `vm_ip` and` vm_hostname`. Note not to overlap with other environments.

You can accesse from a terminal in the same LAN to use the public network to Vagrant virtual environment. To use public networks, set IP address for bridged connection to `public_ip`. In that case, recommended that configure the same IP address to `vm_hostname`.

You can choose the ansible install mode, the default or the pip.

The default is to install Ansible from the operating system package manager, via yum or apt.
The pip is to install Ansible from the Python package manager. In this case, you can install a specific version of Ansible.

	## Vagrant Settings ##

	vm_box                = 'centos/7'
	vm_box_version        = '>= 0'
	vm_ip                 = '192.168.59.63'
	vm_hostname           = 'vap.local'
	vm_document_root      = '/var/www/html'

	public_ip             = ''

	forwarded_port        = []

	vbguest_auto_update   = true
	synced_folder_type    = 'virtualbox' # virtualbox|nfs|rsync|smb

	ansible_install_mode  = :default    # :default|:pip
	ansible_version       = 'latest'    # only :pip required

	vagrant_plugins       = [
		'vagrant-hostsupdater',
		'vagrant-vbguest',
		'vagrant-serverspec'
	]

* `vm_box` (required) name of Vagrant Box (default: `centos/7`)
* `vm_box_version` (required) version of Vagrant Box (default: `>= 0`)
* `vm_ip` (required) private IP address (default: `192.168.59.63`)
* `vm_hostname` (required) hostname (default: `vap.local`)
* `vm_document_root` (required) document root path (default: `/var/www/html`)
	* auto create `html` directory and synchronized
* `public_ip` IP address of bridged connection (default: `''`)
* `forwarded_port` list of ports that you want to transfer (default: `[]`)
* `vbguest_auto_update` whether to update VirtualBox Guest Additions (default: `true` / value: `true` | `false`)
* `synced_folder_type` the type of synced folder (default: `virtualbox` / value: `virtualbox` | `nfs` | `rsync` | `smb`)
* `ansible_install_mode` (required) the way to install Ansible (default: `:default` / value: `:default` | `:pip`)
* `ansible_version` version of Ansible to install (default: `latest`)
* `vagrant_plugins` install vagrant plugins

### Provisioning configuration file (YAML)

Provisioning configuration file is **group_vars/all.yml**.

In YAML format, you can set server, database and Programming environment. And can enable the develop and deploy tools.

	## Server & Database Settings ##

	server             : none   # none|apache|nginx|h2o|litespeed
	fastcgi            : none   # none|php-fpm
	database           : none   # none|mysql|mariadb|percona

	db_root_password   : admin

	## Programming languages Settings ##
	# If the version is set to 0, the programming language does not install

	python_version     : 3.9.2       # 3.9.2
	ruby_version       : 2.7.2       # 2.7.2
	php_version        : 7.4.14      # 7.4.14
	perl_version       : 5.32.0      # 5.32.0
	node_version       : 14.15.3     # 14.15.3
	go_version         : 1.15.6      # 1.15.6
	java_version       : 1.8         # 1.8
	scala_version      : 2.11.12     # 2.11.12 (require java)

	## Develop & Deploy Settings ##

	ssl                : true    # true|false
	docker             : false   # true|false
	phpmyadmin         : false   # true|false (require PHP and database)

	## That's all, stop setting. Let's vagrant up!! ##

#### Server & Database Settings ##

* `server` (required) name of web server (default: `none` / value: `none` | `apache` | `nginx` | `h2o` | `litespeed` )
* `fastcgi` name of fastCGI (default: `none` / value: `none` | `php-fpm`)
* `database` (required) name of databese (default: `none` / value: `none` | `mysql` | `mariadb` | `percona`)

#### Programming languages Settings ##

* `python_version` version of Python (default: `3.9.2`)
* `ruby_version` version of Ruby (default: `2.7.2`)
* `php_version` version of PHP (default: `7.4.14`)
* `perl_version` version of Perl (default: `5.32.0`)
* `node_version` version of Node.js (default: `14.15.3`)
* `go_version` version of Go (default: `1.15.6`)
* `java_version` version of Java (default: `1.8`)
* `scala_version` version of Scala (default: `2.11.12`) require Java

If the version is set to 0, the programming language does not installation

#### Develop & Deploy Settings ##

* `ssl` activate ssl (default: `true` / value: `true` | `false`)
* `docker` docker installed (default: `false` / value: `true` | `false`)
* `phpmyadmin` activate phpMyAdmin (default: `false` / value: `true` | `false`)

## Directory Layout

Directory structure of VAP is as follows.

This directory synchronize to the guest OS side `/vagrant`. `html` creates automatically and synchronize to `vm_document_root`.

### Full Layout

* command (stores shell script)
* config (stores Custom Config)
* config.sample (sample Custom Config)
* group_vars (stores the provisioning configuration file of Ansible)
	* all.yml (provisioning configuration file)
* hosts
	* local (inventory file)
* html (synchronize to the Document Root. create automatically at `vagrant up`, if it does not exist.)
* mkcert (stores SSL certificate files)
* Rakefile (Rakefile of ServerSpec)
* README.md
* roles (stores Ansible playbook of each role)
* site.yml (Ansible playbook core file)
* spec (stores ServerSpec spec file)
	* localhost
	* spec_helper.rb
* Vagrantfile (Vagrant configuration file)

### Minimum Layout

VAP will be built in the directory structure of the following minimum unit.

* group_vars (stores the provisioning configuration file of Ansible)
	* all.yml (provisioning configuration file)
* html (synchronize to the Document Root. create automatically at `vagrant up`, if it does not exist.)
* roles (stores Ansible playbook of each role)
* site.yml (Ansible playbook core file)
* Vagrantfile (Vagrant configuration file)

## Vagrant Boxs

**VAP** supports VirtualBox for providers of Vagrant. Operating system supported CentOS, Debian and Ubuntu Boxes. OS architecture supported x86_64. Details are as follows:

### CentOS

* CentOS 8 (Deprecated ended 2021-12-31)
* CentOS 7
* CentOS 6 (Deprecated ended 2020-11-30)

### Debian

* Debian 10.0
* Debian 9.0
* Debian 8.0 (Deprecated ended 2020-06-30)

### Ubuntu

* Ubuntu 20.04
* Ubuntu 18.04
* Ubuntu 16.04
* Ubuntu 14.04

To download Vagrant Box, you can search from [Discover Vagrant Boxes](https://app.vagrantup.com/boxes/search?provider=virtualbox).

## Specification

### Server (Selectable)

* [Apache](http://httpd.apache.org)
* [nginx](http://nginx.org)
* [H2O](https://h2o.examp1e.net/)
* [LiteSpeed](https://www.litespeedtech.com)

### FastCGI (Selectable, Only nginx)

* [PHP-FPM](http://php-fpm.org) (FastCGI Process Manager)

### Database (Selectable)

* [MariaDB](https://mariadb.org)
* [MySQL](http://www.mysql.com)
* [Percona MySQL](http://www.percona.com/software/percona-server)

### Programming languages

* [Ruby](https://www.ruby-lang.org/)
	* via [rbenv](https://github.com/rbenv/rbenv)
	* [ruby-build](https://github.com/rbenv/ruby-build)
	* [rbenv-default-gems](https://github.com/rbenv/rbenv-default-gems)
* [Python](https://www.python.org/)
	* via [pyenv](https://github.com/yyuu/pyenv)
	* [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv)
* [PHP](https://secure.php.net)
	* via [phpenv](https://github.com/madumlao/phpenv)
	* [php-build](https://github.com/php-build/php-build)
	* [phpenv-composer](https://github.com/ngyuki/phpenv-composer)
	* [phpenv-apache-version](https://github.com/thingsym/phpenv-apache-version)
* [Perl](https://www.perl.org/)
	* via [plenv](https://github.com/tokuhirom/plenv)
	* [Perl-Build](https://github.com/tokuhirom/Perl-Build)
	* [cpanm](https://metacpan.org/release/App-cpanminus)
	* [cpm](https://metacpan.org/release/App-cpm)
	* [Server::Starter](https://metacpan.org/release/Server-Starter)
* [Node.js](http://nodejs.org)
	* via [nodenv](https://github.com/nodenv/nodenv)
	* [node-build](https://github.com/nodenv/node-build)
	* [nodenv-default-packages](https://github.com/nodenv/nodenv-default-packages)
	* [Yarn](https://yarnpkg.com/en/)
* [Go](https://golang.org/)
	* via [goenv](https://github.com/wfarr/goenv)
* [Java (OpenJDK)](http://openjdk.java.net/)
	* via [jenv](http://www.jenv.be/)
* [Scala](http://www.scala-lang.org/)
	* via [scalaenv](https://github.com/mazgi/scalaenv)

### Develop & Deploy Tools (Activatable)

* [Docker](https://www.docker.com)
* [phpMyAdmin](https://www.phpmyadmin.net)

### Pre-installing
* [Git](http://git-scm.com)
* [gibo](https://github.com/simonwhitaker/gibo)

### Helper command

* after_provision.sh
* before_provision.sh
* phpenv.sh
* plenv.sh
* pyenv.sh
* rbenv.sh

## Helper command

**VAP** offers a useful scripts. Just run the script on a terminal. Multiple versions installation of Python, Ruby, PHP and Perl, you can switch the execution environment.

### pyenv.sh

`pyenv.sh` will prepare the specified version of Python execution environment.

	/vagrant/command/pyenv.sh 3.5.1

### rbenv.sh

`rbenv.sh` will prepare the specified version of Ruby execution environment.

	/vagrant/command/rbenv.sh 2.2.0
	/vagrant/command/rbenv.sh mruby-1.1.0

### phpenv.sh

`phpenv.sh` will prepare the specified version of PHP execution environment. You can install the specified version of PHP. Switching the PHP version. And then restart Apache or PHP-FPM by switching the server configuration environment.

	/vagrant/command/phpenv.sh -v 7.2.1 -m php-fpm -s unix

	# help
	/vagrant/command/phpenv.sh -h

### plenv.sh

`plenv.sh` will prepare the specified version of Perl execution environment.

	/vagrant/command/plenv.sh 5.19.11

## Custom Config

You can edit the configuration files.
When you add tuning configuration files in the directory `config`, tuning configuration files are placed at provisioning time.

As follows editable configuration files.

* apache2.000-default.conf.j2
* apache2.conf.j2
* apache2.default-ssl.conf.j2
* apache2.envvars.j2
* default-node-packages.j2
* default-ruby-gems.j2
* h2o.conf.j2
* httpd.conf.centos6.j2
* httpd.conf.centos7.j2
* httpd.www.conf.centos7.j2
* mariadb.my.cnf.j2
* mysql.my.cnf.j2
* nginx.conf.j2
* nginx.www.conf.j2
* percona.my.cnf.j2
* php-build.default_configure_options.j2
* php-fpm.conf (for phpenv.sh)
* php-fpm.www.conf (for phpenv.sh)
* php.ini (for phpenv.sh)
* ssh-config.j2

## Trouble shooting

### Vagrant can't mount to /mnt when vagrant up.

The following `umount /mnt` error message is displayed.

```
The following SSH command responded with a non-zero exit status.
Vagrant assumes that this means the command failed!

umount /mnt

Stdout from the command:


Stderr from the command:

umount: /mnt: not mounted
```

It may happens if the kernel version of OS used in vagrant box does not match the requirements.

The solution is to update the kernel and provision again. It may also be resolved by updating the vagrant box.

1. Access to a guest via SSH.

```
vagrant ssh
```

2. Update the kernel into guest OS.

#### Debian or Ubuntu

```
sudo apt-get -y install linux-image-amd64 linux-headers-amd64
```

#### CentOS

```
sudo yum -y update kernel kernel-devel kernel-headers kernel-tools kernel-tools-libs

exit
```

3. Provision again on the host.

```
vagrant reload
```

## Contribution

### Patches and Bug Fixes

Small patches and bug reports can be submitted a issue tracker in Github. Forking on Github is another good way. You can send a pull request.

1. Fork [VAP](https://github.com/thingsym/vap) from GitHub repository
2. Create a feature branch: git checkout -b my-new-feature
3. Commit your changes: git commit -am 'Add some feature'
4. Push to the branch: git push origin my-new-feature
5. Create new Pull Request

## Changelog

See CHANGELOG.md

## License

VAP is distributed under [GPLv3](https://www.gnu.org/licenses/gpl-3.0.html).

## Author

[thingsym](https://github.com/thingsym)

Copyright (c) 2016-2020 thingsym
