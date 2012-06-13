class PuttyConfig < Vagrant::Config::Base
  attr_accessor :putty_private_key_path  
end

Vagrant.config_keys.register(:putty) { PuttyConfig }