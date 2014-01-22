# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "base"

    config.vm.box_url = "http://files.vagrantup.com/precise32.box"

    config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.network :forwarded_port, guest: 35729, host: 35729

    config.vm.provision "shell" do |s|
        s.path          = "vagrant_install.sh"
        s.privileged    = false
        s.args          = [
                "Acme", # Project Name
                "--prefer-dist mccool/laravel-auto-presenter:*", # Required Composer Dependencies
                "--prefer-dist way/generators:* phpunit/phpunit:3.7.27 mockery/mockery:0.9.*@dev" # Required Dev Composer Dependencies
        ]

    config.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777","fmode=666"]

    # Ubuntu fix for not using login shell: https://github.com/mitchellh/vagrant/issues/1673

    # If true, then any SSH connections made will enable agent forwarding.
    # Default value: false
    # config.ssh.forward_agent = true

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.
    # config.vm.synced_folder "../data", "/vagrant_data"
end