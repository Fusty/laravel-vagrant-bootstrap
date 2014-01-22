#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y vim curl python-software-properties python g++ make
sudo add-apt-repository -y ppa:ondrej/php5
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get update

echo "--- Installing PHP-specific packages ---"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt mysql-server-5.5 php5-mysql git-core php5-xdebug nodejs unzip

echo "--- Configure PHP and xDebug ---"
sudo sed -i '$a xdebug.scream=1' /etc/php5/mods-available/xdebug.ini
sudo sed -i '$a xdebug.cli_color=1' /etc/php5/mods-available/xdebug.ini
sudo sed -i '$a xdebug.show_local_vars=1' /etc/php5/mods-available/xdebug.ini
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

echo "--- Installing and configuring grunt and bower globally ---"
sudo npm install -g grunt-cli
sudo npm install -g bower

echo "--- Install Composer ---"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo "--- Install Ruby through RVM ---"
\curl -L https://get.rvm.io | bash
source /home/vagrant/.rvm/scripts/rvm
rvm install 1.9.3
rvm use 1.9.3

echo "--- Add project specific gems ---"
gem install sass
gem install compass

echo "--- Install project's packages ---"
sudo chown -R vagrant:vagrant /home/vagrant/tmp

if [ -f /vagrant/composer.json ]
    then
        cd /vagrant
        composer update
fi

if [ ! -f /vagrant/composer.json ]
    then
        echo "--- Create a new Laravel Project ---"
        cd /home/vagrant
        wget https://github.com/laravel/laravel/archive/master.zip
        unzip master.zip
        cp -r /home/vagrant/laravel-master/* /vagrant/
        rm -rf /home/vagrant/laravel-master
        rm /home/vagrant/master.zip
        cd /vagrant
        composer install --prefer-dist
        composer require --prefer-dist mccool/laravel-auto-presenter:*
        composer require --dev --prefer-dist way/generators:* phpunit/phpunit:3.7.27 mockery/mockery:0.9.*@dev
        sed -i '$a /bower_components' .gitignore
        sed -i '$a /node_modules' .gitignore
        sed -i '$a /vendor' .gitignore
        sed -i '$a .idea' .gitignore
        sed -i '$a .vagrant' .gitignore
        sed -i '$a composer.phar' .gitignore
        sed -i '$a .env.local.php' .gitignore
        sed -i '$a .env.php' .gitignore
        sed -i '$a .DS_Store' .gitignore
        sed -i '$a Thumbs.db' .gitignore
fi

if [ -f /vagrant/package.json ]
    then
        cd /vagrant
        npm install
fi

if [ -f /vagrant/bower.json ]
    then
        cd /vagrant
        bower cache clean
        bower install
fi

echo "--- Laravel specific settings ---"
chmod -R 755 /vagrant/app/storage

echo "--- Configure Apache ---"
sudo a2enmod rewrite
sudo sed -i "s/AllowOverride None/AllowOverride All/" /etc/apache2/apache2.conf
sudo rm -rf /var/www
sudo ln -fs /vagrant/public /var/www
sudo service apache2 restart
