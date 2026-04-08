# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box_check_update = false

  config.vm.define "control-node" do |control|
    control.vm.box = "bento/ubuntu-22.04"
    control.vm.hostname = "control-node"
    control.vm.network :private_network, ip: "192.168.56.10"

    control.vm.provider "virtualbox" do |vb|
      vb.name = "control-node"
      vb.memory = 1024
      vb.cpus = 2
    end

    # Sync repository so Terraform and Ansible assets are available from the control node.
    control.vm.synced_folder ".", "/home/vagrant/parcial2cloud"
    
    control.vm.provision "shell", path: "control-node/bootstrap-control.sh"
  end
end
