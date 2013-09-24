module VagrantPutty
  class Command < Vagrant.plugin("2", :command)

    def execute
		options = {}

		opts = OptionParser.new do |o|
		  o.banner = "Usage: vagrant putty"
		  o.separator ""
		end
		
		# Parse out the extra args to send to SSH, which is everything
        # after the "--"
        split_index = @argv.index("--")
        if split_index
          options[:ssh_args] = @argv.drop(split_index + 1)
          @argv              = @argv.take(split_index)
        end

        # Parse the options and return if we don't have any target.
        argv = parse_options(opts)
        return if !argv
		
		# Execute the actual SSH
		with_target_vms(argv, :single_target => true) do |vm|

			opts = {
			}

			#	ssh_connect(vm, opts)
			puts "!!!!!!!!!!!!!!!!!!!"
			puts vm.inspect	
			ssh_connect(vm,opts)
		end

		# Success, exit status 0
		0
   end

   def ssh_connect(vm, opts)
		@logger.debug("`exec` into ssh prompt")
		#vm.ssh.exec(opts)

		# Get the SSH information and cache it here
		
		 ssh_info = vm.ssh_info
         raise Vagrant::Errors::SSHNotReady if ssh_info.nil?
		
		putty_private_key_path =  vm.config.putty.putty_private_key_path if vm.config.putty && vm.config.putty.putty_private_key_path
		
		putty_key_path = nil
		if putty_private_key_path
			file = File.expand_path(putty_private_key_path, vm.env.root_path)
			if  File.file?(file)
				putty_key_path = file
			else
				puts  "putty_private_key_path not exist: "+putty_private_key_path
			end
		else
			file = File.expand_path("insecure_private_key.ppk", vm.env.home_path)
			if  File.file?(file)
				putty_key_path = file
			else
				puts "default putty_private_key_path not exist: " +file
			end		
			
		end
        
		if vm.config.putty && vm.config.putty.putty_path
			putty_path =  vm.config.putty.putty_path 
		else
			putty_path = "putty.exe"
		end

		if vm.config.putty && vm.config.putty.session
			putty_session =  vm.config.putty.session 
		else
			putty_session = nil
		end
		
		
		# Command line options
		command_options =["/C", "start" ,putty_path] 
		command_options +=["-ssh","-P", ssh_info[:port].to_s]

		command_options += ["-i", putty_key_path] if putty_key_path
			
		command_options += 	["-load", putty_session] if putty_session	
			
			
		if ssh_info[:forward_x11]
			# Both are required so that no warnings are shown regarding X11
			command_options += ["-X"]
		else
			command_options += ["-x"]
		end


		host_string = "#{ssh_info[:username]}@#{ssh_info[:host]}" 
		command_options << host_string

		# If there are extra options, then we append those
		command_options.concat(opts[:extra_args]) if opts[:extra_args]

		@logger.info("Invoking Putty: #{command_options.inspect}")
		unsafe_exec("cmd.exe", *command_options)
		
	    
	end
	
	def unsafe_exec(command, *args)
	# Create a list of things to rescue from. Since this is OS
	# specific, we need to do some defined? checks here to make
	# sure they exist.
	rescue_from = []
	rescue_from << Errno::EOPNOTSUPP if defined?(Errno::EOPNOTSUPP)
	rescue_from << Errno::E045 if defined?(Errno::E045)
	rescue_from << SystemCallError
	begin
	  Kernel.exec(command, *args)
	end
	
  end
	
  end
end