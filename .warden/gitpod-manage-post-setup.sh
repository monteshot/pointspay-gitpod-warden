#!/bin/bash

clear_url=$(gp url | awk -F"//" {'print $2'}) && url=$url;


# Path to env.php
file_path="$GITPOD_REPO_ROOTS/app/etc/env.php"
echo $file_path
# Str for modifying
site1="clear\.magento2\.loc"

# If file exist
if [ -f "$file_path" ]; then

    sed -i "s|$site1|443-$clear_url|" "$file_path"
    echo "Modifying complete(env.php)."
    warden env exec php-fpm php bin/magento a:c:i
    warden env exec php-fpm php bin/magento mo:d Magento_TwoFactorAuth Magento_AdminAdobeImsTwoFactorAuth
    warden env exec -e COMPOSER_AUTH="$AUTH_JSON" php-fpm composer config repositories.perspective composer https://pointspay.repo.composer.perspective.net.ua -v
    warden env exec -e COMPOSER_AUTH="$AUTH_JSON" php-fpm composer require pointspay/module-pointspay:"*" -v
    warden env exec php-fpm php bin/magento s:up
    warden env exec php-fpm php bin/magento cache:enable
    warden env exec php-fpm php bin/magento d:m:se developer
    warden env exec php-fpm php bin/magento setup:perf:generate-fixtures /var/www/html/setup/performance-toolkit/profiles/ce/small.xml
    warden env exec php-fpm php bin/magento cache:flush
    warden env exec php-fpm php bin/magento cron:install
    warden env exec php-fpm php bin/magento cron:run
    warden env exec php-fpm php bin/magento a:c:i
    wget https://files.magerun.net/n98-magerun2.phar
    chmod +x ./n98-magerun2.phar
else
    echo "File $file_path not found."
    exit 1
fi

