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

* [Oracle VM VirtualBox](https://www.virtualbox.org) >= 5.2
* [Vagrant](https://www.vagrantup.com) >= 2.1
* [Ansible](https://www.ansible.com) >= 2.4

#### Vagrant plugin (optional)

* [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
* [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)
* [vagrant-serverspec](https://github.com/jvoorhis/vagrant-serverspec)

## Usage

### 1. Install Virtualbox

Download the VirtualBox form [www.virtualbox.org](https://www.virtualbox.org) and install.

### 2. Install Vagrant

Download the Vagrant form [www.vagrantup.com](https://www.vagrantup.com) and install.

### 3. Install Vagrant plugin

Install the Vagrant plugin on the terminal as necessary.

	vagrant plugin install vagrant-hostsupdater
	vagrant plugin install vagrant-vbguest
	vagrant plugin install vagrant-serverspec

### 4. Download Ansible playbooks of VAP

Download a Vagrantfile and Ansible playbooks from the following link.

[Download Zip format file](https://github.com/thingsym/vap/archive/master.zip)

### 5. Launch a virtual environment

	cd vap-x.x.x
	vagrant up

If you don't have a Box at first, begins from the download of Box. After provisioning, you can launch a Programming environment.

### 6. Access to the website

Access to the website **http://vap.local/**, if the server is running.


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
	forwarded_port        = false

	synced_folder_type    = 'virtualbox' # virtualbox|nfs|rsync|smb
	vbguest_auto_update   = true

	ansible_install_mode  = :default    # :default|:pip
	ansible_version       = 'latest'    # only :pip required

* `vm_box` (required) name of Vagrant Box (default: `centos/7`)
* `vm_box_version` (required) version of Vagrant Box (default: `>= 0`)
* `vm_ip` (required) private IP address (default: `192.168.59.63`)
* `vm_hostname` (required) hostname (default: `vap.local`)
* `vm_document_root` (required) document root path (default: `/var/www/html`)
	* auto create `html` directory and synchronized
* `public_ip` IP address of bridged connection (default: `''`)
* `forwarded_port` enable forwarded port (default: `false` / value: `true` | `false`)
* `synced_folder_type` the type of synced folder (default: `virtualbox` / value: `virtualbox` | `nfs` | `rsync` | `smb`)
* `vbguest_auto_update` update VirtualBox Guest Additions (default: `true` / value: `true` | `false`)
* `ansible_install_mode` (required) the way to install Ansible (default: `:default` / value: `:default` | `:pip`)
* `ansible_version` version of Ansible to install (default: `latest`)

### Provisioning configuration file (YAML)

Provisioning configuration file is **group_vars/all.yml**.

In YAML format, you can set server, database and Programming environment. And can enable the develop and deploy tools.

	## Server & Database Settings ##

	server             : none   # none|apache|nginx|h2o
	fastcgi            : none   # none|php-fpm
	database           : none   # none|mysql|mariadb|percona

	db_root_password   : admin

	## Programming languages Settings ##
	# If the version is set to 0, the programming language does not install

	python_version     : 3.6.4       # 3.6.4
	ruby_version       : 2.4.3       # 2.4.3
	php_version        : 7.2.1       # 7.2.1
	perl_version       : 5.26.1      # 5.26.1
	node_version       : 8.9.4       # 8.9.4
	go_version         : 1.9.2       # 1.9.2
	java_version       : 1.8         # 1.8
	scala_version      : 2.11.12     # 2.11.12 (require java)

	## Develop & Deploy Settings ##

	ssl                : true    # true|false
	phpmyadmin         : false   # true|false (require PHP and database)

	## That's all, stop setting. Let's vagrant up!! ##

#### Server & Database Settings ##

* `server` (required) name of web server (default: `none` / value: `none` | `apache` | `nginx` | `h2o` )
* `fastcgi` name of fastCGI (default: `none` / value: `none` | `php-fpm`)
* `database` (required) name of databese (default: `none` / value: `none` | `mysql` | `mariadb` | `percona`)

#### Programming languages Settings ##

* `ruby_version` version of Ruby (default: `2.4.3`)
* `python_version` version of Python (default: `3.6.4`)
* `php_version` version of PHP (default: `7.2.1`)
* `perl_version` version of Perl (default: `5.26.1`)
* `node_version` version of Node.js (default: `8.9.4`)
* `go_version` version of Go (default: `1.9.2`)
* `java_version` version of Java (default: `1.8`)
* `scala_version` version of Scala (default: `2.11.12`) require Java

If the version is set to 0, the programming language does not installation

#### Develop & Deploy Settings ##

* `ssl` activate ssl (default: `true` / value: `true` | `false`)
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

* CentOS 7
* CentOS 6
* Debian 9 Stretch
* Debian 8 Jessie
* Ubuntu 16.04 Xenial
* Ubuntu 14.04 Trusty

To download Vagrant Box, you can search from [Discover Vagrant Boxes](https://app.vagrantup.com/boxes/search?provider=virtualbox).

## Specification

### Server (Selectable)

* [Apache](http://httpd.apache.org)
* [nginx](http://nginx.org)
* [H2O](https://h2o.examp1e.net/)

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
	* [packagist.jp repository](https://packagist.jp/)
	* [prestissimo](https://github.com/hirak/prestissimo)
* [Perl](https://www.perl.org/)
	* via [plenv](https://github.com/tokuhirom/plenv)
	* [Perl-Build](https://github.com/tokuhirom/Perl-Build)
	* [cpanm](https://github.com/miyagawa/cpanminus)
	* [Server::Starter](http://search.cpan.org/~kazuho/Server-Starter/)
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

* [OpenSSL](https://www.openssl.org)
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
* ssh-config.j2

## Contribution

### Patches and Bug Fixes

Small patches and bug reports can be submitted a issue tracker in Github. Forking on Github is another good way. You can send a pull request.

1. Fork [VAP](https://github.com/thingsym/vap) from GitHub repository
2. Create a feature branch: git checkout -b my-new-feature
3. Commit your changes: git commit -am 'Add some feature'
4. Push to the branch: git push origin my-new-feature
5. Create new Pull Request

## Changelog

* version 0.2.9 - 2018.05.27
	* add option synced_folder_type with Vagrant Settings
* version 0.2.8 - 2018.05.14
	* fix mysql.my.cnf.j2
	* fix *env path
* version 0.2.7 - 2018.05.03
	* change user/group from www-data to vagrant with debian
	* add debian/stretch64 to vm_box
	* fix vbguest_auto_update
	* change official Vagrant box to official distributor
	* install the latest version of ansible with debian
	* change from yum claen all to yum makecache fast
	* fix mysql.sock path
	* add debconf-utils
	* fix mysql/mariadb/percona tasks
	* fix reset database tasks
	* enable Apache2 module proxy_fcgi
	* enable swap space with only Ubuntu
	* revert SELinux with only CentOS7
	* add .bashrc_vap
	* add handlers
	* improve phpenv.sh version 0.4.0
	* remove mount_options
	* add type option into config.vm.synced_folder
	* change nginx user
	* remove CityFan repo
	* remove bash settings into .bash_profile, integrate into .bashrc
	* using 'become' and 'become_user' rather than running sudo
	* fix ruby build env
	* add python build env
* version 0.2.6 - 2018.03.11
	* add chrony with centos 7
	* add fastcgi to h2o
	* fix php installation via phpenv.sh
	* improve phpenv.sh version 0.3.0
	* fix mod_php
	* add fastcgi to apache
	* add mod_proxy_fcgi for centos 6
	* change server user
	* fix fastcgi_pass
	* remove cache_valid_time
	* fix openjdk-8-jdk installation with Debian
	* fix common role with CentOS 7
	* change multiple conditions of the when statement to as a list
	* add php-cgi symbolic link
* version 0.2.5 - 2018.02.03
	* fix ssl path
	* fix self Certification Authority
	* add pyenv-virtualenv
	* add Server::Starter
	* fix opcach disable
	* fix apt-get update
	* fix AllowOverride with apache
* version 0.2.4 - 2017.07.27
	* fix vb.customize for improve VirutalBox performance
	* remove vagrant-cachier plugin
* version 0.2.3 - 2017.06.23
	* set permission to synced_folder html
	* fix reset
	* fix certificate file name for h2o
	* bump up Ruby version number to 2.4.1
	* add CityFan repository for libcurl, only CentOS 6
* version 0.2.2 - 2017.04.24
	* add forwarded_port for Browsersync
	* replace with openssl-1.0.2k
	* fix opcach disable
	* add apt-transport-https for debian
	* add yarn
	* add h2o HTTP server
	* fix sendfile off
* version 0.2.1 - 2017.03.24
	* add custom ~/.ssh/config
	* fix phpmyadmin task
	* add my.cnf for each database
	* fix JDK
	* using YAML dictionaries in tasks
* version 0.2.0 - 2017.01.26
	* fix openssl, add vap.crt and server.crt
	* support Debian and Ubuntu
	* add develop-tools
* version 0.1.3 - 2016.10.15
	* fix tests
	* fix the inline script to get the major version number
	* fix sudo user
	* fix shebang
* version 0.1.2 - 2016.09.10
	* fix node version
	* add jenv and scalaenv
	* add Java (OpenJDK)
	* add prestissimo
	* add custom php.conf.j2 and php-build.default_configure_options.j2
	* fix file name
* version 0.1.1 - 2016.08.09
	* rename to default-node-packages.j2 from default_node_packages.j2
	* add synced_folder /vagrant
	* add vagrant-vbguest plugin
	* fix mariadb yum repository
	* fix rbenv, plenv, pyenv and phpenv
	* add nodenv and goenv
	* remove RepoForge repository
	* change to package module from yum module
* version 0.1.0 - 2016.06.22
	* initial release

## License

VAP is distributed under [GPLv3](https://www.gnu.org/licenses/gpl-3.0.html).

## Author

[thingsym](https://github.com/thingsym)

Copyright (c) 2016-2018 thingsym
