# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
    config.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 2
    end

    config.vm.define "chef1" do |bionic|
        bionic.vm.box = "ubuntu/bionic64"
        # xenial.vm.synced_folder "./cache/xenial", "/mnt/alpha/", owner:"root", :mount_options => ["dmode=700,fmode=600"]
        bionic.vm.provision "shell", inline: "sudo apt-get install -y python python-dev"
        bionic.vm.provision "chef_solo" do |chef|
          chef.add_recipe "chef-server"
          chef.version = "14.12.9"
      end
    end
    config.vm.define "chef2" do |bionic|
      bionic.vm.box = "ubuntu/bionic64"
      # xenial.vm.synced_folder "./cache/xenial", "/mnt/alpha/", owner:"root", :mount_options => ["dmode=700,fmode=600"]
      bionic.vm.provision "shell", inline: "sudo apt-get install -y python python-dev"
    end
  end