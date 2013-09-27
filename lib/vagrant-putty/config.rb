module VagrantPutty
	class Config < Vagrant.plugin("2", :config)
	  attr_accessor :putty_private_key_path 
	  attr_accessor :putty_path
	  attr_accessor :putty_session
	  
	  
		def initialize
			@putty_private_key_path             = UNSET_VALUE
			@putty_path							= UNSET_VALUE
			@putty_session							= UNSET_VALUE		
		end

		  def finalize!
			@putty_private_key_path             = nil if @putty_private_key_path == UNSET_VALUE
			@putty_path            				= nil if @putty_path == UNSET_VALUE
			@putty_session             				= nil if @putty_session == UNSET_VALUE
			
		  end

		  def validate(machine)
			errors = _detected_errors
			if @putty_private_key_path && \
			  !File.file?(File.expand_path(@putty_private_key_path, machine.env.root_path))
			  errors << I18n.t("vagrant.config.ssh.private_key_missing", :path => @putty_private_key_path)
			end

			errors
		  end
	end
end