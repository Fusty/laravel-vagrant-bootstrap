#!/usr/bin/env bash

echo "--- Good morning, master. Let's get to work. Installing now. ---"

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- MySQL time ---"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

echo "--- Installing base packages ---"
sudo apt-get install -y vim curl python-software-properties python g++ make

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- We want the bleeding edge of PHP, right master? ---"
sudo add-apt-repository -y ppa:ondrej/php5
sudo add-apt-repository -y ppa:chris-lea/node.js

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- Installing PHP-specific packages ---"
sudo apt-get install -y php5 apache2 libapache2-mod-php5 ls -alphp5-curl php5-gd php5-mcrypt mysql-server-5.5 php5-mysql git-core

echo "--- Installing and configuring Xdebug ---"
sudo apt-get install -y php5-xdebug

echo "--- Installing and configuring nodjs and npm --- "
sudo apt-get install -y nodejs

echo "--- Installing and configuring grunt and bower globally ---"
sudo npm install -g grunt-cli
sudo npm install -g bower


sed -i '$a xdebug.scream=1' /etc/php5/mods-available/xdebug.ini
sed -i '$a xdebug.cli_color=1' /etc/php5/mods-available/xdebug.ini
sed -i '$a xdebug.show_local_vars=1' /etc/php5/mods-available/xdebug.ini


echo "--- Enabling mod-rewrite ---"
sudo a2enmod rewrite




echo "--- What developer codes without errors turned on? Not you, master. ---"
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

sudo sed -i "s/AllowOverride None/AllowOverride All/" /etc/apache2/apache2.conf

echo "--- Restarting Apache ---"
sudo service apache2 restart

echo "--- Composer is the future. But you knew that, did you master? Nice job. ---"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Install Ruby
sudo \curl -L https://get.rvm.io | bash
source /home/vagrant/.rvm/scripts/rvm
rvm install 1.9.3
rvm use 1.9.3

# Laravel stuff here, if you want

echo "--- Make a new Laravel project ---"
composer create-project laravel/laravel laravel
cd /home/vagrant/laravel
tar pcf - .| (cd /vagrant/; tar pxf -)

echo "--- Install node packages ---"
cd /vagrant
sudo chown -R vagrant:vagrant /home/vagrant/tmp
npm install

echo "--- Install bower packages ---"
cd /vagrant
bower install

echo "--- Update .gitignore ---"
sed -i '$a /bower_components' .gitignore
sed -i '$a /node_modules' .gitignore

echo "--- Setting document root ---"
sudo rm -rf /var/www
sudo ln -fs /vagrant/public /var/www


echo "--- All set to go! Would you like to play a game? ---"
