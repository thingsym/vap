# Changelog

## [0.3.9] - 2020.01.29

- fix IUS repository url

## [0.3.8] - 2019.11.20

- bump up node version
- fix php config with phpenv.sh
- fix IUS repository url

## [0.3.7] - 2019.09.26

- bump up php version
- fix php-build.default_configure_options
- add litespeed server
- add Zstandard compression algorithm

## [0.3.6] - 2019.07.19

- fix task description
- add choice of openssl installation, source or package
- add .editorconfig
- fix kernel parameter
- fix IUS repository url

## [0.3.5] - 2019.05.07

- improve to add forwarded_port using array
- bump up git version 2 or later
- fix http2 config
- enable switch between prefork and event with apache
- bump up Apache version 2.4
- improve version specification with openssl

## [0.3.4] - 2019.03.12

- bump up programming language versions
- modify kernel parameters
- remove hhvm
- add CHANGELOG.md

## [0.3.3] - 2018.10.08

- add peco
- add jq
- fix tests

## [0.3.2] - 2018.09.03

- fix default version with programming languages
- bump up ruby version 2.5.1
- bump up Node version 8.11.4

## [0.3.1] - 2018.07.09

- improve phpenv.sh version 0.4.1
- add command switch_config to phpenv.sh
- fix usage of phpenv.sh
- fix gibo command
- add MySQL 8.0 task

## [0.3.0] - 2018.06.11

- add other versions database tasks
- bump up MariaDB 10.3, MySQL 5.7, Percona 5.7

## [0.2.9] - 2018.05.27

- add option synced_folder_type with Vagrant Settings

## [0.2.8] - 2018.05.14

- fix mysql.my.cnf.j2
- fix *env path

## [0.2.7] - 2018.05.03

- change user/group from www-data to vagrant with debian
- add debian/stretch64 to vm_box
- fix vbguest_auto_update
- change official Vagrant box to official distributor
- install the latest version of ansible with debian
- change from yum claen all to yum makecache fast
- fix mysql.sock path
- add debconf-utils
- fix mysql/mariadb/percona tasks
- fix reset database tasks
- enable Apache2 module proxy_fcgi
- enable swap space with only Ubuntu
- revert SELinux with only CentOS7
- add .bashrc_vap
- add handlers
- improve phpenv.sh version 0.4.0
- remove mount_options
- add type option into config.vm.synced_folder
- change nginx user
- remove CityFan repo
- remove bash settings into .bash_profile, integrate into .bashrc
- using 'become' and 'become_user' rather than running sudo
- fix ruby build env
- add python build env

## [0.2.6] - 2018.03.11

- add chrony with centos 7
- add fastcgi to h2o
- fix php installation via phpenv.sh
- improve phpenv.sh version 0.3.0
- fix mod_php
- add fastcgi to apache
- add mod_proxy_fcgi for centos 6
- change server user
- fix fastcgi_pass
- remove cache_valid_time
- fix openjdk-8-jdk installation with Debian
- fix common role with CentOS 7
- change multiple conditions of the when statement to as a list
- add php-cgi symbolic link

## [0.2.5] - 2018.02.03

- fix ssl path
- fix self Certification Authority
- add pyenv-virtualenv
- add Server::Starter
- fix opcach disable
- fix apt-get update
- fix AllowOverride with apache

## [0.2.4] - 2017.07.27

- fix vb.customize for improve VirutalBox performance
- remove vagrant-cachier plugin

## [0.2.3] - 2017.06.23

- set permission to synced_folder html
- fix reset
- fix certificate file name for h2o
- bump up Ruby version number to 2.4.1
- add CityFan repository for libcurl, only CentOS 6

## [0.2.2] - 2017.04.24

- add forwarded_port for Browsersync
- replace with openssl-1.0.2k
- fix opcach disable
- add apt-transport-https for debian
- add yarn
- add h2o HTTP server
- fix sendfile off

## [0.2.1] - 2017.03.24

- add custom ~/.ssh/config
- fix phpmyadmin task
- add my.cnf for each database
- fix JDK
- using YAML dictionaries in tasks

## [0.2.0] - 2017.01.26

- fix openssl, add vap.crt and server.crt
- support Debian and Ubuntu
- add develop-tools

## [0.1.3] - 2016.10.15

- fix tests
- fix the inline script to get the major version number
- fix sudo user
- fix shebang

## [0.1.2] - 2016.09.10

- fix node version
- add jenv and scalaenv
- add Java (OpenJDK)
- add prestissimo
- add custom php.conf.j2 and php-build.default_configure_options.j2
- fix file name

## [0.1.1] - 2016.08.09

- rename to default-node-packages.j2 from default_node_packages.j2
- add synced_folder /vagrant
- add vagrant-vbguest plugin
- fix mariadb yum repository
- fix rbenv, plenv, pyenv and phpenv
- add nodenv and goenv
- remove RepoForge repository
- change to package module from yum module

## [0.1.0] - 2016.06.22

- initial release
