#after restating workspace old domain may be lost ..ws-105.. -> ..ws-106.. 
git -C /workspace/opt/warden/ reset --hard
git clone -b main https://github.com/wardenenv/warden.git /workspace/opt/warden
FILE_PATH="/workspace/opt/warden/commands/svc.cmd"
CHOWN_COMMAND="sudo chown -R gitpod:gitpod /home/gitpod/.warden/"

TRAefikYML="/home/gitpod/.warden/etc/traefik/traefik.yml"
DYNAMICDir="/home/gitpod/.warden/etc/traefik/dynamic.yml"

if [[ -f "$FILE_PATH" ]]; then
    sed -i '/sudo chown -R gitpod:gitpod \/home\/gitpod\/.warden\//d' "$FILE_PATH"
    sed -i '/assertDockerRunning/a\'"$CHOWN_COMMAND" "$FILE_PATH"

    sed -i '/sudo rm -rf \/home\/gitpod\/.warden\/etc\/traefik\//d' "$FILE_PATH"
    sed -i '/assertDockerRunning/a\'"if [ -d \"$TRAefikYML\" ]; then sudo rm -rf $TRAefikYML; fi" "$FILE_PATH"
    sed -i '/assertDockerRunning/a\'"if [ -d \"$DYNAMICDir\" ]; then sudo rm -rf $DYNAMICDir; fi" "$FILE_PATH"

    echo "Changes successfully applied."
else
    echo "File not found: $FILE_PATH"
fi
