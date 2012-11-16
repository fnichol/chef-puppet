# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'berkshelf/vagrant'

def oc_box_url(name)
  "https://opscode-vm.s3.amazonaws.com/vagrant/boxes/#{name}.box"
end

Vagrant::Config.run do |config|
  config.vm.box     = "opscode-ubuntu-12.04"
  config.vm.box_url = oc_box_url(config.vm.box)

  config.vm.provision :chef_solo do |chef|
    chef.run_list = [
      "recipe[puppet::master]"
    ]

    chef.json = {
    }
  end
end
