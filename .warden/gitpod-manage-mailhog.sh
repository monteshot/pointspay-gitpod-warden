#!/bin/bash

clear_url=$(gp url | awk -F"//" '{print $2}')

if [ -z "$clear_url" ]; then
    echo "Cannot fetch clear_url variable."
    exit 1
fi

# Path to docker-compose.yml
file_path="/workspace/opt/warden/docker/docker-compose.yml"

# Marker of search
search_string="routers.mailhog.rule"

# Final str for replace process
replace_string="      - traefik.http.routers.mailhog.rule=Host(\`8025-$clear_url\`)"

# Str to commenting out
tls_line="- traefik.http.routers.mailhog.tls=true"

# If file exist
if [ -f "$file_path" ]; then
    # Commenting the line with "tls=true"
    sed -i "s|$tls_line|\# $tls_line|g" "$file_path"

    # Modifying the file
     sed -i "s|.*$search_string.*|$replace_string|g" "$file_path"
    echo "Changes applied(docker-compose.yml)."
else
    echo "File $file_path not found."
    exit 1
fi

# Mailhog custom port
INSERT_LINE="- \"\${TRAEFIK_LISTEN:-127.0.0.1}:8025:443\""
sed -i "/- \"\${TRAEFIK_LISTEN:-127.0.0.1}:443:443\"/a $INSERT_LINE" /workspace/opt/warden/docker/docker-compose.yml
INSERT_LINE="- \"\${TRAEFIK_LISTEN:-127.0.0.1}:8025:443\""
INSERT_LINE_WITH_TABS="      $INSERT_LINE"
sed -i "s/$INSERT_LINE/$INSERT_LINE_WITH_TABS/" /workspace/opt/warden/docker/docker-compose.yml


