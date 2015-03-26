
# If it looks like GA system, run composer
if File.exists?('/etc/gentoo-release')

    # prepare config files
    run "copy #{config.shared_path}/config/parameters.yml >> #{config.release_path}/app/config/parameters.yml"

end

