if File.exists?('/etc/debian_version')
	# prepare config files
	run "copy #{config.shared_path}/config/api-keys.yml >> #	{config.release_path}/application/config/properties.yml"
end