execute 'Configure mail part 1' do
    command "
        sed -i \
        '
            s/^mailhub=mail/mailhub=smtp-relay.gmail.com:587/;
            s/^#rewriteDomain=/rewriteDomain=officesupply.com/;
        ' \
    /etc/ssmtp/ssmtp.conf"
    not_if "grep smtp-relay.gmail.com:587 /etc/ssmtp/ssmtp.conf"
end

execute 'Configure mail part 2' do
    command "(echo hostname=cron@officesupply.com; echo UseSTARTTLS=YES) >> /etc/ssmtp/ssmtp.conf"
    not_if "grep UseSTARTTLS=YES /etc/ssmtp/ssmtp.conf"
end

execute 'Configure mail for cron' do
    command "sed -i 's/MAILTO=root/MAILTO=cron@officesupply.com/' /etc/crontab"
    not_if "grep MAILTO=cron@officesupply.com /etc/crontab"
end
