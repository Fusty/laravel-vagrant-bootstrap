#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y vim curl python-software-properties python g++ make
sudo add-apt-repository -y ppa:ondrej/php5
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get update

echo "--- Installing PHP-specific packages ---"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
sudo apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt mysql-server-5.5 php5-mysql php5-readline git-core php5-xdebug unzip

echo "--- Configure PHP and xDebug ---"
sudo sed -i '$a xdebug.scream=1' /etc/php5/mods-available/xdebug.ini
sudo sed -i '$a xdebug.cli_color=1' /etc/php5/mods-available/xdebug.ini
sudo sed -i '$a xdebug.show_local_vars=1' /etc/php5/mods-available/xdebug.ini
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
sudo sed -i "s/disable_functions = .*/disable_functions = /" /etc/php5/cli/php.ini

echo "--- Install Composer ---"
if ! hash composer 2>/dev/null; then
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
fi

echo "--- Install Ruby through RVM ---"
if ! hash rvm 2>/dev/null; then
    \curl -L https://get.rvm.io | bash
    source /home/vagrant/.rvm/scripts/rvm
    rvm install 1.9.3
    rvm use 1.9.3

    echo "--- Add project specific gems ---"
    gem install sass
    gem install compass
fi

echo "--- Install project's packages ---"
mkdir /home/vagrant/tmp
sudo chown -R vagrant:vagrant /home/vagrant/tmp

if [ -f /vagrant/composer.lock ]
    then
        cd /vagrant
        composer install
fi

if [ ! -f /vagrant/composer.lock ]
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
        composer require $2
        composer require --dev $3
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

        if [ ! -d "/vagrant/app/$1" ]
            then
                mkdir /vagrant/app/$1
                sed -i 's/"autoload": {/"autoload": { "psr-4":{"'$1'\\\\":"app\/"},/' /vagrant/composer.json
        fi

        echo "--- Setup local configuration and database ---"
        mysql -uroot -proot -e "CREATE DATABASE ${1,,}"
        mkdir /vagrant/app/config/local
        cp /vagrant/app/config/database.php /vagrant/app/config/local
        sed -i "s/'database',/'${1,,}',/" /vagrant/app/config/local/database.php
        sed -i "s/'password'  => '',/'password'  => 'root',/" /vagrant/app/config/local/database.php
        sed -i "s/your-machine-name/${HOSTNAME}/" /vagrant/bootstrap/start.php
fi

if [ -f "/vagrant/package.json" ] && [ ! -d "/vagrant/node_modules" ]
    then
        if ! hash npm 2>/dev/null; then
            echo "--- Installing and configuring nodejs ---"
            sudo apt-get install -y nodejs
        fi
        cd /vagrant
        npm install
fi

if [ -f "/vagrant/bower.json" ] && [ ! -d "/vagrant/bower_components" ]
    then
        if ! hash npm 2>/dev/null; then
            echo "--- Installing and configuring nodejs ---"
            sudo apt-get install -y nodejs
        fi

        if ! hash bower 2>/dev/null; then
            echo "--- Installing and configuring bower globally ---"
            sudo npm install -g bower
        fi

        cd /vagrant
        bower cache clean
        bower install
fi

if [ -f "/vagrant/gulpfile.js" ]
    then
        if ! hash npm 2>/dev/null; then
            echo "--- Installing and configuring nodejs ---"
            sudo apt-get install -y nodejs
        fi

        if ! hash gulp 2>/dev/null; then
            echo "--- Installing and configuring gulp globally ---"
            sudo npm install -g gulp
        fi
fi

if [ -f "/vagrant/main.scss" ]
    then
        mkdir /vagrant/app/assets
        mkdir /vagrant/app/assets/sass
        mv /vagrant/main.scss /vagrant/app/assets/sass/
fi

echo "--- Laravel specific settings ---"
chmod -R 755 /vagrant/app/storage
cd /vagrant
php artisan optimize

echo "--- Configure Apache ---"
sudo a2enmod rewrite
sudo sed -i "s/AllowOverride None/AllowOverride All/" /etc/apache2/apache2.conf
sudo rm -rf /var/www
sudo ln -fs /vagrant/public /var/www
sudo service apache2 restart

if [ -f "/vagrant/gulpfile.js" ]; then
    cd /vagrant
    gulp
fi