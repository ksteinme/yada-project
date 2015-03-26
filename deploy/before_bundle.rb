if File.exists?('/etc/debian_version')
    # prepare config files
    run "copy #{config.shared_path}/config/parameters.yml >> #{config.release_path}/app/config/parameters.yml"

    # timezone
    sudo "echo 'date.timezone = America/Chicago' > /etc/php5/cli/conf.d/timezone.ini"
    sudo "echo 'date.timezone = America/Chicago' > /etc/php5/fpm/conf.d/timezone.ini"
end

# If it looks like GA system, run composer
if File.exists?('/etc/gentoo-release')
    sudo "echo 'date.timezone = America/Chicago' > /etc/php/cgi-php5.4/ext-active/timezone.ini"
    sudo "echo 'date.timezone = America/Chicago' > /etc/php/cli-php5.4/ext-active/timezone.ini"
    sudo "echo 'date.timezone = America/Chicago' > /etc/php/fpm-php5.4/ext-active/timezone.ini"
    
    # prepare config files
    run "copy #{config.shared_path}/config/parameters.yml >> #{config.release_path}/app/config/parameters.yml.live"

    composerFlag = '--dev'
    if config.framework_env == 'production'
        composerFlag = '--no-dev'
    end

    runs_php = false
    if ['app_master', 'app', 'solo'].include?(config.current_role)
        runs_php = true
    end
    if 'util' == config.current_role && config.current_name.match(/^worker_/)
        runs_php = true
    end

    if runs_php
        sudo "/usr/bin/composer self-update"
        run "/usr/bin/composer install --no-interaction --working-dir #{config.release_path} #{composerFlag}"
    end
end
