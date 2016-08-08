# VAP (Vagrant Ansible Programming languages)

**VAP (Vagrant Ansible Programming languages)** is Ansible playbooks for website developer and programmer.

## Features

### 1. Build Server and Database environment

**VAP** will build server from **Apache** or **nginx**, and build database from **MySQL**, **MariaDB** or **Percona MySQL**.

Server nginx is a FastCGI configuration as a reverse proxy. And building a PHP execution environment from **PHP-FPM** (FastCGI Process Manager).

By default, the server and the databese is installed in the default settings. Also you can edit configuration files.

### 2. Build Programming environment

**VAP** will build a Programming languages that specifies the version.

### 3. Develop & Deploy Tools

You can install the develop tools or the deploy tools by usage. See Specification for list of installed tools.

## Requirements

* [Virtualbox](https://www.virtualbox.org)
* [Vagrant](https://www.vagrantup.com) >= 1.8.4
* [Ansible](https://www.ansible.com) >= 2.1.0.0
* [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater) optional (Vagrant plugin)
* [vagrant-cachier](http://fgrehm.viewdocs.io/vagrant-cachier) optional (Vagrant plugin)
optional (Vagrant plugin)
* [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)
* [vagrant-serverspec](https://github.com/jvoorhis/vagrant-serverspec) optional (Vagrant plugin)

## Usage

### 1. Install Virtualbox

Download the VirtualBox form [www.virtualbox.org](https://www.virtualbox.org) and install.


### 2. Install Vagrant

Download the Vagrant form [www.vagrantup.com](https://www.vagrantup.com) and install.

### 3. Install Vagrant plugin

Install the Vagrant plugin on the terminal as necessary.

	vagrant plugin install vagrant-hostsupdater
	vagrant plugin install vagrant-cachier
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

* ROOT PASSWORD `admin`
* HOST `localhost`

## Customize Options
You can build a variety of environment that edit the configuration file of VAP.

There are two configuration files you can customize.

Run `vagrant up` or `vagrant provision`, after editing the configuration file.

### Vagrant configuration file (Ruby)

Vagrant configuration file is **Vagrantfile**.

Vagrantfile will set the vagrant Box, private IP address, hostname and the document root.

If you launch multiple environments, change the name of the directory. Should rewrite `vm_ip` and` vm_hostname`. Note not to overlap with other environments.

You can accesse from a terminal in the same LAN to use the public network to Vagrant virtual environment. To use public networks, set IP address for bridged connection to `public_ip`. In that case, recommended that configure the same IP address to `vm_hostname`.

	## Vagrant Settings ##

	vm_box                = 'hansode/centos-7.1.1503-x86_64'
	vm_ip                 = '192.168.59.63'
	vm_box_version        = '>= 0'
	vm_hostname           = 'vap.local'
	vm_document_root      = '/var/www/html'

	public_ip             = ''

	vbguest_auto_update = false

* `vm_box` (required) name of Vagrant Box (default: `hansode/centos-7.1.1503-x86_64`)
* `vm_box_version` (required) version of Vagrant Box (default: `>= 0`)
* `vm_ip` (required) private IP address (default: `192.168.59.63`)
* `vm_hostname` (required) hostname (default: `vap.local`)
* `vm_document_root` (required) document root path (default: `/var/www/html`)
	* auto create `html` directory and synchronized
* `public_ip` IP address of bridged connection (default: ``)
* `vbguest_auto_update` update VirtualBox Guest Additions (default: false / value: true | false)

### Provisioning configuration file (YAML)

Provisioning configuration file is **group_vars/all.yml**.

In YAML format, you can set server, database and Programming environment. And can enable the develop and deploy tools.

	## Server & Database Settings ##

	server             : 'none'   # none|apache|nginx
	fastcgi            : 'none'   # none|php-fpm
	database           : 'none'   # none|mysql|mariadb|percona

	db_root_password   : 'admin'

	## Programming languages Settings ##
	# If the version is set to 0, the programming language does not install

	ruby_version       : 2.3.1       # 2.3.1
	python_version     : 3.5.1       # 3.5.1
	php_version        : 7.0.7       # 7.0.7
	perl_version       : 5.25.1      # 5.25.1
	node_version       : 0.11.2      # 0.11.2
	go_version         : 1.6.3       # 1.6.3

	## Develop & Deploy Settings ##

	ssl                : false   # true|false
	phpmyadmin         : false   # true|false

	## That's all, stop setting. Let's vagrant up!! ##

#### Server & Database Settings ##

* `server` (required) name of web server (default: `none` / value: `none` | `apache` | `nginx`)
* `fastcgi` name of fastCGI (default: `none` / value: `none` | `php-fpm`)
	* `fastcgi` is possible only `server 'nginx'`
* `database` (required) name of databese (default: `none` / value: `none` | `mysql` | `mariadb` | `percona`)


#### Programming languages Settings ##

* `ruby_version` version of Ruby (default: `2.3.1`)
* `python_version` version of Python (default: `3.5.1`)
* `php_version` version of PHP (default: `7.0.7`)
* `perl_version` version of Perl (default: `5.25.1`)
* `node_version` version of Node.js (default: `0.11.2`)
* `go_version` version of Go (default: `1.6.3`)

If the version is set to 0, the programming language does not installation

#### Develop & Deploy Settings ##

* `ssl` activate ssl (default: `false` / value: `true` | `false`)
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
* readme-ja.md
* readme.md
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

## Vagrant Box

Vagrant Box is probably compatible with centos-7.x x86_64 and centos-6.x x86_64.

## Specification

### Server (Selectable)

* [Apache](http://httpd.apache.org)
* [nginx](http://nginx.org)

### FastCGI (Selectable, Only nginx)

* [PHP-FPM](http://php-fpm.org) (FastCGI Process Manager)

### Database (Selectable)

* [MySQL](http://www.mysql.com)
* [MariaDB](https://mariadb.org)
* [Percona MySQL](http://www.percona.com/software/percona-server)

### Programming languages

* Ruby (build via rbenv)
* Python (build via pyenv)
* PHP (build via phpenv)
* Perl (build via plenv)
* Node.js (build via nodenv)
* Go (build via goenv)

### Develop & Deploy Tools (Activatable)

* [OpenSSL](https://www.openssl.org)
* [phpMyAdmin](https://www.phpmyadmin.net)

### Pre-installing
* [Git](http://git-scm.com)
* [gibo](https://github.com/simonwhitaker/gibo)

### Helper command

* after_provision.sh
* before_provision.sh
* rbenv.sh
* pyenv.sh
* phpenv.sh
* plenv.sh

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

	/vagrant/command/phpenv.sh 5.6.21

### plenv.sh

`plenv.sh` will prepare the specified version of Perl execution environment.

	/vagrant/command/plenv.sh 5.19.11

## Custom Config

When you add a tuning configuration file that you edited in the directory `config`, place it at the time of provisioning.
As follows editable configuration files.

* default-node-packages.j2
* default-ruby-gems.j2
* httpd.conf.centos6.j2
* httpd.conf.centos7.j2
* httpd.www.conf.centos7.j2
* my.cnf.j2
* nginx.conf.j2
* nginx.www.conf.j2
* php-build.default_configure_options.j2
* php.conf.j2

## Contribute

Small patches and bug reports can be submitted a issue tracker in Github. Forking on Github is another good way. You can send a pull request.

If you would like to contribute, here are some notes and guidlines.

* All development happens on the **develop** branch, so it is always the most up-to-date
* The **master** branch only contains tagged releases
* If you are going to be submitting a pull request, please submit your pull request to the **develop** branch
* See about [forking](https://help.github.com/articles/fork-a-repo/) and [pull requests](https://help.github.com/articles/using-pull-requests/)

## Changelog

* version 0.1.0 - 2016.06.22
	* initial release

## License

VAP is distributed under GPLv3.

Copyright (c) 2016 thingsym
