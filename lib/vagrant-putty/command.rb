require 'optparse'
require 'log4r'

require 'vagrant/util/file_mode'
require 'vagrant/util/platform'

module VagrantPutty
    class CommandPutty < Vagrant::Command::Base    
	
	def execute
		options = {}

		opts = OptionParser.new do |opts|
		  opts.banner = "Usage: vagrant putty [vm-name]"

		  opts.separator ""
		end

		# Parse the options and return if we don't have any target.
		argv = parse_options(opts)
		return if !argv

		# Parse out the extra args to send to SSH, which is everything
		# after the "--"
		ssh_args = ARGV.drop_while { |i| i != "--" }
		ssh_args = ssh_args[1..-1]
		options[:ssh_args] = ssh_args

		# If the remaining arguments ARE the SSH arguments, then just
		# clear it out. This happens because optparse returns what is
		# after the "--" as remaining ARGV, and Vagrant can think it is
		# a multi-vm name (wrong!)
		argv = [] if argv == ssh_args

		# Execute the actual SSH
		with_target_vms(argv, :single_target => true) do |vm|
		  # Basic checks that are required for proper SSH
		  raise Vagrant::Errors::VMNotCreatedError if !vm.created?
		  raise Vagrant::Errors::VMInaccessible if !vm.state == :inaccessible
		  raise Vagrant::Errors::VMNotRunningError if vm.state != :running

			opts = {
			}

			ssh_connect(vm, opts)
		  
		end

		# Success, exit status 0
		0
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

	def ssh_connect(vm, opts)
		@logger.debug("`exec` into ssh prompt")
		#vm.ssh.exec(opts)

		# Get the SSH information and cache it here
		ssh_info = vm.ssh.info()
	    putty_key_path = vm.config.putty.putty_private_key_path if vm.config.putty
        ssh_info[:putty_key_path] = File.expand_path(putty_key_path, vm.env.root_path) if putty_key_path

		options = {}
		options[:host] = ssh_info[:host]
		options[:port] = ssh_info[:port]
		options[:username] = ssh_info[:username]
		options[:private_key_path] = ssh_info[:private_key_path]
		options[:putty_key_path] = ssh_info[:putty_key_path]

		# Command line options
		command_options =["/C", "start" ,"putty.exe"] 
		command_options +=["-ssh","-P", options[:port].to_s]

		command_options += ["-i", options[:putty_key_path]] if options[:putty_key_path]

		# If there are extra options, then we append those
		command_options.concat(opts[:extra_args]) if opts[:extra_args]

		if ssh_info[:forward_x11]
			# Both are required so that no warnings are shown regarding X11
			command_options += ["-X"]
		else
			command_options += ["-x"]
		end

		host_string = options[:host]
		host_string = "#{options[:username]}@#{host_string}" 
		command_options << host_string
		@logger.info("Invoking SSH: #{command_options.inspect}")
		unsafe_exec("cmd.exe", *command_options)
	end
  
  
  
  Vagrant.commands.register(:putty) { CommandPutty }
  end
end
