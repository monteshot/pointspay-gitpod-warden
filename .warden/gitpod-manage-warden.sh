clear_url=$(gp url | awk -F"//" {'print $2'}) && url=$url;
echo "Clear URL: $clear_url"
echo "Creating Warden directory"
mkdir -p /workspace/opt/warden
echo "Cloning Warden"
git clone -b main https://github.com/wardenenv/warden.git /workspace/opt/warden
cd $GITPOD_REPO_ROOTS
pwd
sudo ls -lah /home/gitpod/.warden
sudo chown -R gitpod:gitpod /home/gitpod/.warden/
sudo ls -lah /home/gitpod/.warden
echo "Creating Warden-related files(containers) under home directory"
warden svc up
echo "Starting project containers"
warden env up
echo "Setting up Warden"
sudo ls -lah /home/gitpod/.warden
sed -i s/WARDEN_SERVICE_DOMAIN=$clear_url//g /home/gitpod/.warden/.env
echo "WARDEN_SERVICE_DOMAIN=$clear_url" | tee -a /home/gitpod/.warden/.env
sed -i s/TRAEFIK_LISTEN=127.0.0.1//g /home/gitpod/.warden/.env
echo "TRAEFIK_LISTEN=127.0.0.1" | tee -a /home/gitpod/.warden/.env
sudo ls -lah /home/gitpod/.warden
echo "Setting up Warden user group and user ID inside container"
warden env exec php-fpm sudo groupmod -g 33333 www-data
warden env exec php-fpm sudo usermod -u 33333 -g 33333 www-data
warden env exec php-debug sudo groupmod -g 33333 www-data
warden env exec php-debug sudo usermod -u 33333 -g 33333 www-data
echo "Restarting Warden to apply changes"
warden env stop
warden env up
