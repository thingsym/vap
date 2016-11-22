#!/usr/bin/env bash

set -e

usage_exit() {
  echo "[Error]: Not Found php version"
  echo "[Info]: phpenv.sh version 0.2.0"
  echo "[Info]: Usage: phpenv.sh <Version Number|-v x.x.x>"
  echo "[Info]: or Not Found Sub Commnad"
  echo "[Info]: Usage: phpenv.sh <-l|-i>"
  exit 1
}

if [ "$#" -eq 0 ]; then
  usage_exit
fi

while getopts "v:s:r:o:lih" OPT ; do
  case $OPT in
    v)  PHP_VERSION=$OPTARG ;;
    s)  SERVER=$OPTARG ;;
    l)  phpenv install -l; exit 0 ;;
    i)  phpenv versions; exit 0 ;;
    h)  usage_exit ;;
    \?) usage_exit ;;
  esac
done

shift $(( $OPTIND - 1 ))

if [ ! "$PHP_VERSION" ]; then
  PHP_VERSION=$1
fi

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

function global() {
  phpenv global $PHP_VERSION

  if [ $APACHE_ACTIVE -gt 0 ]; then
    if [ -d /etc/httpd/conf.d ]; then
      sudo chown vagrant:vagrant /etc/httpd/conf.d/

      if [[ $PHP_VERSION =~ ^5 ]]; then
        sed -i -e "s/^#LoadModule php5_module/LoadModule php5_module/" $APACHE_PHP_CONF
        sed -i -e "s/^LoadModule php7_module/#LoadModule php7_module/" $APACHE_PHP_CONF
        echo "[Info]: edit $APACHE_PHP_CONF"
        sudo chown vagrant:vagrant /etc/httpd/modules/libphp5.so
      elif [[ $PHP_VERSION =~ ^7 ]]; then
        sed -i -e "s/^LoadModule php5_module/#LoadModule php5_module/" $APACHE_PHP_CONF
        sed -i -e "s/^#LoadModule php7_module/LoadModule php7_module/" $APACHE_PHP_CONF
        echo "[Info]: edit $APACHE_PHP_CONF"
        sudo chown vagrant:vagrant /etc/httpd/modules/libphp7.so
      fi

      sudo chown root:root /etc/httpd/conf.d/
    fi

    if [ -d /etc/apache2/mods-available ]; then
      if [[ $PHP_VERSION =~ ^5 ]]; then
        [ -f /etc/apache2/mods-available/php7.load ] && sudo a2dismod php7
        [ -f /etc/apache2/mods-available/php5.load ] && sudo a2enmod php5
      elif [[ $PHP_VERSION =~ ^7 ]]; then
        [ -f /etc/apache2/mods-available/php5.load ] && sudo a2dismod php5
        [ -f /etc/apache2/mods-available/php7.load ] && sudo a2enmod php7
      fi
    fi

    phpenv apache-version $PHP_VERSION
  fi

  if [ $PHP_FPM_ACTIVE -gt 0 ]; then
    if type systemctl > /dev/null 2>&1; then
      sudo systemctl stop php-fpm
    elif type service > /dev/null 2>&1; then
      sudo service php-fpm stop
    fi

    if [ -f /home/vagrant/.phpenv/versions/$PHP_VERSION/sbin/php-fpm ] && [ -d /usr/sbin ]; then
      sudo cp /home/vagrant/.phpenv/versions/$PHP_VERSION/sbin/php-fpm /usr/sbin/php-fpm
      echo "[Info]: add php-fpm to /usr/sbin/"
      sudo chmod 755 /usr/sbin/php-fpm
    fi

    if [ "$DISTR" = "centos" ]; then
      if type systemctl > /dev/null 2>&1; then
        if [ -f "$PHP_FPM_SERVICE" ] && [ -d /usr/lib/systemd/system ]; then
          sudo cp $PHP_FPM_SERVICE /usr/lib/systemd/system/php-fpm.service
          echo "[Info]: add php-fpm.service to /usr/lib/systemd/system/"
          sudo systemctl daemon-reload
        fi
      elif type service > /dev/null 2>&1; then
        if [ -f "$PHP_FPM_INITD" ] && [ -d /etc/init.d ]; then
          sudo cp $PHP_FPM_INITD /etc/init.d/php-fpm
          echo "[Info]: add php-fpm.init.d to /etc/init.d/"
          sudo chmod 755 /etc/init.d/php-fpm
          sudo chkconfig --add php-fpm
        fi
      fi
    elif [ "$DISTR" = "debian" ] || [ "$DISTR" = "ubuntu" ]; then
      if type systemctl > /dev/null 2>&1; then
        if [ -f "$PHP_FPM_SERVICE" ] && [ -d /lib/systemd/system ]; then
          sudo cp $PHP_FPM_SERVICE /lib/systemd/system/php-fpm.service
          echo "[Info]: add php-fpm.service to /lib/systemd/system/"
          sudo systemctl daemon-reload
        fi
      elif type service > /dev/null 2>&1; then
        if [ -f "$PHP_FPM_INITD" ] && [ -d /etc/init.d ]; then
          sudo cp $PHP_FPM_INITD /etc/init.d/php-fpm
          echo "[Info]: add php-fpm.init.d to /etc/init.d/"
          sudo chmod 755 /etc/init.d/php-fpm
        fi
      fi
    fi

    if type systemctl > /dev/null 2>&1; then
      sudo systemctl start php-fpm
    elif type service > /dev/null 2>&1; then
      sudo service php-fpm start
    fi
  fi
}

function install() {
  if [ -d /etc/httpd/modules ]; then
    sudo chown vagrant:vagrant /etc/httpd/modules
    sudo chown vagrant:vagrant /etc/httpd/conf.d
  elif [ -d /usr/lib/apache2/modules ]; then
    sudo chown vagrant:vagrant /usr/lib/apache2/modules
    sudo chown vagrant:vagrant /etc/apache2/mods-available
    sudo chown vagrant:vagrant /etc/apache2/mods-enabled
    sudo chown vagrant:vagrant /var/lib/apache2
    sudo chown vagrant:vagrant /var/lib/apache2/module/enabled_by_admin
  fi

  phpenv install $PHP_VERSION /home/vagrant/.phpenv/versions/$PHP_VERSION

  if [ ! -f /var/log/php.log ]; then
    sudo touch /var/log/php.log
    sudo chmod 0666 /var/log/php.log
    echo "[Info]: add /var/log/php.log"
  fi

  if [ "$DISTR" = "centos" ] && [ -d /etc/httpd/conf.d ] && [ ! -f "$APACHE_PHP_CONF" ]; then
    echo -e "#LoadModule php5_module modules/libphp5.so\nLoadModule php7_module modules/libphp7.so\n\n<FilesMatch \.php$>\nSetHandler application/x-httpd-php\n</FilesMatch>\n\nDirectoryIndex index.php" > $APACHE_PHP_CONF
  elif ( [ "$DISTR" = "debian" ] || [ "$DISTR" = "ubuntu" ] ) && [ -d /etc/apache2/mods-available ] && [ ! -f "$APACHE_PHP_CONF" ]; then
    echo -e "<FilesMatch \.php$>\nSetHandler application/x-httpd-php\n</FilesMatch>\n\nDirectoryIndex index.php" > $APACHE_PHP_CONF
  fi

  if [ -d /etc/httpd/modules ]; then
    if [ -f /etc/httpd/modules/libphp5.so ] && [[ $PHP_VERSION =~ ^5 ]]; then
      cp /etc/httpd/modules/libphp5.so /home/vagrant/.phpenv/versions/$PHP_VERSION/libphp5.so
    fi

    if [ -f /etc/httpd/modules/libphp7.so ] && [[ $PHP_VERSION =~ ^7 ]]; then
      cp /etc/httpd/modules/libphp7.so /home/vagrant/.phpenv/versions/$PHP_VERSION/libphp7.so
    fi

    sudo chown root:root /etc/httpd/conf.d
    sudo chown root:root /etc/httpd/modules
  elif [ -d /usr/lib/apache2/modules ]; then
    if [ -f /usr/lib/apache2/modules/libphp5.so ] && [[ $PHP_VERSION =~ ^5 ]]; then
      cp /usr/lib/apache2/modules/libphp5.so /home/vagrant/.phpenv/versions/$PHP_VERSION/libphp5.so
    fi

    if [ -f /usr/lib/apache2/modules/libphp7.so ] && [[ $PHP_VERSION =~ ^7 ]]; then
      cp /usr/lib/apache2/modules/libphp7.so /home/vagrant/.phpenv/versions/$PHP_VERSION/libphp7.so
    fi

    sudo chown root:root /usr/lib/apache2/modules
    sudo chown root:root /etc/apache2/mods-available
    sudo chown root:root /etc/apache2/mods-enabled
    sudo chown root:root /var/lib/apache2
  fi

  if [ -f "$PHP_INI" ]; then
    sed -i -e "s/^error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/" $PHP_INI
    sed -i -e "s/^display_errors = Off/display_errors = On/" $PHP_INI
    sed -i -e "s/^post_max_size = 8M/post_max_size = 36M/" $PHP_INI
    sed -i -e "s/^upload_max_filesize = 2M/upload_max_filesize = 36M/" $PHP_INI
    sed -i -e "s/^;mbstring.language = Japanese/mbstring.language = neutral/" $PHP_INI
    sed -i -e "s/^;mbstring.internal_encoding =/mbstring.internal_encoding = UTF-8/" $PHP_INI
    sed -i -e "s/^;date.timezone =/date.timezone = UTC/" $PHP_INI
    sed -i -e 's/^;session.save_path = \"\/tmp\"/session.save_path = \"\/tmp\"/' $PHP_INI

    sed -i -e "s/^;opcache.memory_consumption=64/opcache.memory_consumption=128/" $PHP_INI
    sed -i -e "s/^;opcache.interned_strings_buffer=4/opcache.interned_strings_buffer=8/" $PHP_INI
    sed -i -e "s/^;opcache.max_accelerated_files=2000/opcache.max_accelerated_files=4000/" $PHP_INI
    sed -i -e "s/^;opcache.revalidate_freq=2/opcache.revalidate_freq=60/" $PHP_INI
    sed -i -e "s/^;opcache.fast_shutdown=0/opcache.fast_shutdown=1/" $PHP_INI
    # sed -i -e "s/^;opcache.enable_cli=0/opcache.enable_cli=1/" $PHP_INI
    # sed -i -e "s/^;opcache.enable=0/opcache.enable=1/" $PHP_INI
    echo "[Info]: edit $PHP_INI"
  fi

  if [ ! -d /var/log/php-fpm ]; then
    sudo mkdir /var/log/php-fpm
    echo "[Info]: add /var/log/php-fpm"
  fi

  if [ ! -f /var/log/php-fpm/error.log ]; then
    sudo touch /var/log/php-fpm/error.log
    sudo chmod 0666 /var/log/php-fpm/error.log
    echo "[Info]: add /var/log/php-fpm/error.log"
  fi

  if [ "$DISTR" = "centos" ]; then
    if id nginx >/dev/null 2>&1; then
      sudo chown nginx:nginx /var/log/php-fpm
    fi
  elif [ "$DISTR" = "debian" ] || [ "$DISTR" = "ubuntu" ]; then
    if [ -d /var/log/php-fpm ]; then
      sudo chown www-data:www-data /var/log/php-fpm
    fi
  fi

  if [ -f /tmp/php-build/source/$PHP_VERSION/sapi/fpm/php-fpm.service ]; then
    sudo cp /tmp/php-build/source/$PHP_VERSION/sapi/fpm/php-fpm.service $PHP_FPM_SERVICE
    sed -i -e "s/^PIDFile=\${prefix}\/var\/run\/php-fpm.pid/PIDFile=\/run\/php-fpm.pid/" $PHP_FPM_SERVICE
    sed -i -e "s/^ExecStart=\${exec_prefix}\/sbin\/php-fpm --nodaemonize --fpm-config \${prefix}\/etc\/php-fpm.conf/ExecStart=\/usr\/sbin\/php-fpm --nodaemonize --fpm-config \/home\/vagrant\/.phpenv\/versions\/$PHP_VERSION\/etc\/php-fpm.conf/" $PHP_FPM_SERVICE
    sed -i -e "11i PrivateTmp=true" $PHP_FPM_SERVICE
    echo "[Info]: edit $PHP_FPM_SERVICE"
  fi

  if [ -f /tmp/php-build/source/$PHP_VERSION/sapi/fpm/init.d.php-fpm ]; then
    sudo cp /tmp/php-build/source/$PHP_VERSION/sapi/fpm/init.d.php-fpm $PHP_FPM_INITD
  fi

  if [ -f $PHP_FPM_CONF.default ]; then
    sudo cp $PHP_FPM_CONF.default $PHP_FPM_CONF
    echo "[Info]: add php-fpm.conf"

    sed -i -e "s/^;pid = run\/php-fpm.pid/pid = run\/php-fpm.pid/" $PHP_FPM_CONF
    sed -i -e "s/^;error_log = log\/php-fpm.log/error_log = \/var\/log\/php-fpm\/error.log/" $PHP_FPM_CONF
    sed -i -e "s/^;daemonize = yes/daemonize = yes/" $PHP_FPM_CONF
    echo "[Info]: edit $PHP_FPM_CONF [global]"

    if [ "$DISTR" = "centos" ]; then
      sed -i -e "s/^user = nobody/user = nginx/" $PHP_FPM_CONF
      sed -i -e "s/^group = nobody/group = nginx/" $PHP_FPM_CONF
      sed -i -e "s/^;listen.owner = nobody/listen.owner = nginx/" $PHP_FPM_CONF
      sed -i -e "s/^;listen.group = nobody/listen.group = nginx/" $PHP_FPM_CONF
    elif [ "$DISTR" = "debian" ] || [ "$DISTR" = "ubuntu" ]; then
      sed -i -e "s/^user = nobody/user = www-data/" $PHP_FPM_CONF
      sed -i -e "s/^group = nobody/group = www-data/" $PHP_FPM_CONF
      sed -i -e "s/^;listen.owner = nobody/listen.owner = www-data/" $PHP_FPM_CONF
      sed -i -e "s/^;listen.group = nobody/listen.group = www-data/" $PHP_FPM_CONF
    fi
    sed -i -e "s/^listen = 127.0.0.1:9000/listen = \/var\/run\/php-fcgi.pid/" $PHP_FPM_CONF
    sed -i -e "s/^;listen.mode = 0660/listen.mode = 0660/" $PHP_FPM_CONF
    sed -i -e "s/^;listen.allowed_clients = 127.0.0.1/listen.allowed_clients = 127.0.0.1/" $PHP_FPM_CONF
    echo "[Info]: edit $PHP_FPM_CONF [www]"
  fi

  if [ -f $PHP_FPM_WWW_CONF.default ]; then
    sudo cp $PHP_FPM_WWW_CONF.default $PHP_FPM_WWW_CONF
    echo "[Info]: add $PHP_FPM_WWW_CONF"

    if [ "$DISTR" = "centos" ]; then
      sed -i -e "s/^user = nobody/user = nginx/" $PHP_FPM_WWW_CONF
      sed -i -e "s/^group = nobody/group = nginx/" $PHP_FPM_WWW_CONF
      sed -i -e "s/^;listen.owner = nobody/listen.owner = nginx/" $PHP_FPM_WWW_CONF
      sed -i -e "s/^;listen.group = nobody/listen.group = nginx/" $PHP_FPM_WWW_CONF
    elif [ "$DISTR" = "debian" ] || [ "$DISTR" = "ubuntu" ]; then
      sed -i -e "s/^user = nobody/user = www-data/" $PHP_FPM_WWW_CONF
      sed -i -e "s/^group = nobody/group = www-data/" $PHP_FPM_WWW_CONF
      sed -i -e "s/^;listen.owner = nobody/listen.owner = www-data/" $PHP_FPM_WWW_CONF
      sed -i -e "s/^;listen.group = nobody/listen.group = www-data/" $PHP_FPM_WWW_CONF
    fi
    sed -i -e "s/^listen = 127.0.0.1:9000/listen = \/var\/run\/php-fcgi.pid/" $PHP_FPM_WWW_CONF
    sed -i -e "s/^;listen.mode = 0660/listen.mode = 0660/" $PHP_FPM_WWW_CONF
    sed -i -e "s/^;listen.allowed_clients = 127.0.0.1/listen.allowed_clients = 127.0.0.1/" $PHP_FPM_WWW_CONF
    echo "[Info]: edit $PHP_FPM_WWW_CONF"
  fi

  if [ $PHP_FPM_ACTIVE -eq 0 ]; then
    if [ -f /home/vagrant/.phpenv/versions/$PHP_VERSION/sbin/php-fpm ] && [ -d /usr/sbin ]; then
      sudo cp /home/vagrant/.phpenv/versions/$PHP_VERSION/sbin/php-fpm /usr/sbin/php-fpm
      echo "[Info]: add php-fpm to /usr/sbin/"
      sudo chmod 755 /usr/sbin/php-fpm
    fi

    if [ "$DISTR" = "centos" ]; then
      if type systemctl > /dev/null 2>&1; then
        if [ -f "$PHP_FPM_SERVICE" ] && [ -d /usr/lib/systemd/system ]; then
          sudo cp $PHP_FPM_SERVICE /usr/lib/systemd/system/php-fpm.service
          echo "[Info]: add php-fpm.service to /usr/lib/systemd/system/"
          sudo systemctl daemon-reload
        fi
      elif type service > /dev/null 2>&1; then
        if [ -f "$PHP_FPM_INITD" ] && [ -d /etc/init.d ]; then
          sudo cp $PHP_FPM_INITD /etc/init.d/php-fpm
          echo "[Info]: add php-fpm.init.d to /etc/init.d/"
          sudo chmod 755 /etc/init.d/php-fpm
          sudo chkconfig --add php-fpm
        fi
      fi
    elif [ "$DISTR" = "debian" ] || [ "$DISTR" = "ubuntu" ]; then
      if type systemctl > /dev/null 2>&1; then
        if [ -f "$PHP_FPM_SERVICE" ] && [ -d /lib/systemd/system ]; then
          sudo cp $PHP_FPM_SERVICE /lib/systemd/system/php-fpm.service
          echo "[Info]: add php-fpm.service to /lib/systemd/system/"
          sudo systemctl daemon-reload
        fi
      elif type service > /dev/null 2>&1; then
        if [ -f "$PHP_FPM_INITD" ] && [ -d /etc/init.d ]; then
          sudo cp $PHP_FPM_INITD /etc/init.d/php-fpm
          echo "[Info]: add php-fpm.init.d to /etc/init.d/"
          sudo chmod 755 /etc/init.d/php-fpm
        fi
      fi
    fi
  fi

  phpenv rehash
}

if [ "$DISTR" = "centos" ]; then
  APACHE_ACTIVE=`ps -ef | grep httpd | grep -v grep | wc -l`
  APACHE_PHP_CONF="/etc/httpd/conf.d/php.conf"
elif [ "$DISTR" = "debian" ] || [ "$DISTR" = "ubuntu" ]; then
  APACHE_ACTIVE=`ps -ef | grep apache2 | grep -v grep | wc -l`
  if [[ $PHP_VERSION =~ ^5 ]]; then
    APACHE_PHP_CONF="/etc/apache2/mods-available/php5.conf"
  elif [[ $PHP_VERSION =~ ^7 ]]; then
    APACHE_PHP_CONF="/etc/apache2/mods-available/php7.conf"
  fi
fi

PHP_FPM_ACTIVE=`ps -ef | grep php-fpm | grep -v grep | wc -l`

PHP_INI="/home/vagrant/.phpenv/versions/$PHP_VERSION/etc/php.ini"
PHP_FPM_CONF="/home/vagrant/.phpenv/versions/$PHP_VERSION/etc/php-fpm.conf"
PHP_FPM_WWW_CONF="/home/vagrant/.phpenv/versions/$PHP_VERSION/etc/php-fpm.d/www.conf"
PHP_FPM_SERVICE="/home/vagrant/.phpenv/versions/$PHP_VERSION/etc/php-fpm.service"
PHP_FPM_INITD="/home/vagrant/.phpenv/versions/$PHP_VERSION/etc/php-fpm.init.d"

if [ -e /home/vagrant/.phpenv/versions/$PHP_VERSION ]; then
  global
else
  install
  global
fi

exit 0