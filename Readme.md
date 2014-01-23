# Bootstrap Laravel in Vagrant

This project is a way to get up and running with a new Laravel project quickly using
Vagrant as the server.

### Vagrant Box Includes
- Cutting edge PHP and common modules along with MySQL
- Composer
- Ruby 1.9.3 via RVM (sass and compass gems included)
- Git
- Laravel installed from master (https://github.com/laravel/laravel/archive/master.zip)
- Laravel local configuration and default database created based on project name
- Nodejs install of package.json file exists
- Bower install if bower.json file exists

### Configurable Settings
The Vagrantfile has a few command line args around line 19 that allow you to set:
- Project Name (default: Acme): This must be a single word with a captial first letter. This will create a domain specific folder in your laravel /app directory and add it to composer.json as psr-4 autoloaded.
- Composer Requirements: This will be appended to a call to composer after install to add additional packages you may commonly use.
- Composer Dev Requirements: This will be appended to a call to composer --dev after install to add additional packages you may commonly use for development.
- bower.json: Feel free to delete or edit this file which will be installed during provisioning.
- package.json: Feel free to delete or edit this file which will be installed during provisioning.

## Get Started
### Download and Install Vagrant and VirtualBox

    http://www.vagrantup.com/
    https://www.virtualbox.org/

### Clone this project as your own

    git clone https://github.com/michael-bender/laravel-vagrant-bootstrap.git MyProject

### Start Up Vagrant

    cd MyProject
    vagrant up

### Now get to building!

Navigate to `http://localhost:8080` and 'You have arrived.'

## Basic Usage

### MySQL

    username: root
    password: root

    Connect via SSH
    Name: localhost
    MySQL Host: 127.0.0.1
    Username: root
    Password: root
    Database: [INSERT YOUR PROJECT NAME IN LOWERCASE, DEFAULT is acme]
    Port: 3306
    SSH Host: 127.0.0.1
    SSH User: vagrant
    SSH Key: ~/.vagrant.d/insecure_private_key
    SSH Port: 2222

### SSH

You can ssh into the development server using `vagrant ssh`. From here navigate to `/vagrant`
which is a shared directory between the VM and your host machine so you can open and edit these
files on your computer but they will update in the VM also.

You will run your `composer`, `php artisan`, `npm`, `bower`, etc... commands from the server after you have
`vagrant ssh` into `/vagrant` directory.

## Git Clean up

You'll probably want to delete the .git directory and re-initialize the project as your own with `git init`.
You should be safe with the provided .gitignore to just start building and committing. Team member should be able to clone
your project from here on out and still run vagrant up to get the same results for developing on your project.

## Credits
Enlightenment and inspiration from https://github.com/JeffreyWay/Vagrant-Setup

## Coming Soon

* Live Reload by default
* Remote xDebug support
* Gulp build process for
    * SASS compilation
    * JS asset management similar to Yeoman
    * Sprite/Image creation
    * Deployment / Distribution Build
