#!/bin/bash

clear_url=$(gp url | awk -F"//" {'print $2'}) && url=$url;
cp -v $GITPOD_REPO_ROOTS/.warden/.gitpod.env $GITPOD_REPO_ROOTS/.env

# Path to .env
file_path="$GITPOD_REPO_ROOTS/.env"
echo $file_path
# Str for modifying
site1="clear\.magento2\.loc"

# If file exist
if [ -f "$file_path" ]; then
    # Modifying the file
    sed -i "s|$site1|80-$clear_url|" "$file_path"
    echo "Modifying complete(.env)."
else
    echo "File $file_path not found."
    exit 1
fi

SSH_POSSIBLE_CORRUPTED_DIRECTORY="$HOME/.ssh/"
sudo rm -rf $SSH_POSSIBLE_CORRUPTED_DIRECTORY
mkdir -p $SSH_POSSIBLE_CORRUPTED_DIRECTORY
chmod -R 700 $SSH_POSSIBLE_CORRUPTED_DIRECTORY
ssh-keygen -t ed25519 -N "password" -C "mock key" -f /home/gitpod/.ssh/id_rsa
ssh-keyscan -p 23 $STORAGEBOX_HOST >> ~/.ssh/known_hosts

git -C $GITPOD_REPO_ROOTS checkout -- $FILE_PATH

FILE_PATH="$GITPOD_REPO_ROOTS/.warden/warden-env.yml"
TLS_DECLARATION='      - "traefik.http.routers.${WARDEN_ENV_NAME}-nginx.tls=false"'

if [[ -f "$FILE_PATH" ]]; then
    sed -i 's/      - "traefik.http.routers.${WARDEN_ENV_NAME}-nginx.tls=true"/'"$TLS_DECLARATION"'/' "$FILE_PATH"
    echo "Changes successfully applied."
else
    echo "File not found: $FILE_PATH"
fi

FILE_PATH="$GITPOD_REPO_ROOTS/.warden/warden-env.yml"
TLS_DECLARATION='      - "traefik.http.routers.${WARDEN_ENV_NAME}-phpmyadmin.tls=false"'

if [[ -f "$FILE_PATH" ]]; then
    sed -i 's/      - "traefik.http.routers.${WARDEN_ENV_NAME}-phpmyadmin.tls=true"/'"$TLS_DECLARATION"'/' "$FILE_PATH"
    echo "Changes successfully applied."
else
    echo "File not found: $FILE_PATH"
fi
