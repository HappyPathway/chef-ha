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
  
    config.vm.define "precise64" do |precise|
      precise.vm.box = "ubuntu/precise64"
      # precise.vm.synced_folder "./cache/precise", "/mnt/alpha/", owner:"root", :mount_options => ["dmode=700,fmode=600"]
    end
  
    config.vm.define "trusty64" do |trusty|
      trusty.vm.box = "ubuntu/trusty64"
      # trusty.vm.synced_folder "./cache/trusty", "/mnt/alpha/", owner:"root", :mount_options => ["dmode=700,fmode=600"]
    end
  
    config.vm.define "xenial64" do |xenial|
      xenial.vm.box = "ubuntu/xenial64"
      # xenial.vm.synced_folder "./cache/xenial", "/mnt/alpha/", owner:"root", :mount_options => ["dmode=700,fmode=600"]
      xenial.vm.provision "shell", inline: "sudo apt-get install -y python python-dev"
    end

    config.vm.define "bionic64" do |xenial|
        xenial.vm.box = "ubuntu/bionic64"
        # xenial.vm.synced_folder "./cache/xenial", "/mnt/alpha/", owner:"root", :mount_options => ["dmode=700,fmode=600"]
        xenial.vm.provision "shell", inline: "sudo apt-get install -y python python-dev"
    end

    config.vm.provision "chef_solo" do |chef|
        chef.add_recipe "python"
        chef.add_recipe "chef-server"
        chef.version = "14.12.9"
    end
  end