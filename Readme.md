# Bootstrap Laravel with Vagrant

I plan to use this as my starting point for new Laravel projects. Its a work in progress, but currently supports:
 * Setting up a box with needed software (Apache, MySQL, PHP5 bleeding edge, xdebug, rvm(ruby) w/ 1.9.3, node/npm, grunt, bower, sass)
 * Downloads a fresh copy of Laravel if a composer.json file does not already exist
 * Deletes the .git folder for this project to set you up clean to start with a fresh git init
 * Setups the .gitignore file to include the bower_components and node_modules
 * Installs from the bower.json and package.json files (includes requirements to setup Live Reload, SASS, Uglify.. etc for production build with grunt --- Coming Soon)

# Get Started

### Download and Install Vagrant and VirtualBox `http://www.vagrantup.com/` and `https://www.virtualbox.org/`

### Clone this project as your own

    git clone https://github.com/michael-bender/laravel-vagrant-bootstrap.git MyProject

### Start Up Vagrant

    cd MyProject
    vagrant up

## Now get to building!

Navigate to `http://localhost:8080` and 'You have arrived.'

# Credits
Enlightenment and inspiration from https://github.com/JeffreyWay/Vagrant-Setup

## Coming Soon

* Live Reload by default
* Remote xDebug support
* Grunt configuration
    * SASS compilation
    * JS asset management similar to Yeoman
    * Sprite/Image creation
    * Deployment / Distribution Build