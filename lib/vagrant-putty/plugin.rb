require "vagrant"

module VagrantPutty
    class Plugin < Vagrant.plugin("2")
      name "putty command"
      description <<-DESC
      The `putty` command allows you to SSH in to your running virtual machine.
      DESC
	
	  config ("putty") do  
        require_relative "config"
        Config
      end
	  
      command("putty") do
        require File.expand_path("../command", __FILE__)
        Command
      end
	  
	end
end