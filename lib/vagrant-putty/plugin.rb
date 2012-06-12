require "vagrant"

module VagrantPutty
  module CommandPutty
    class Plugin < Vagrant.plugin("1")
      name "putty command"
      description <<-DESC
      PuTTY into the VM environment
      DESC

      command("putty") do
        require File.expand_path("../command", __FILE__)
        Command
      end
    end
  end
end