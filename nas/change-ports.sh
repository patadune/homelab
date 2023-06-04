#! /bin/bash
# Script-source and discussion: https://gist.github.com/hjbotha/f64ef2e0cd1e8ba5ec526dcd6e937dd7

# Developed for DSM 6 - 7.0.1. Not tested on other versions.
# run as root at boot through Control Panel -> Task Scheduler

# Ports to free - blocked by nginx on Synology
DEFAULT_HTTP_PORT=80
DEFAULT_HTTPS_PORT=443

# New ports to set instead
CUSTOM_HTTP_PORT=5080  # DO NOT USE 5000
CUSTOM_HTTPS_PORT=5443 # DO NOT USE 5001

echo "Replacing port $DEFAULT_HTTP_PORT with $CUSTOM_HTTP_PORT"
echo -e "Replacing port $DEFAULT_HTTPS_PORT with $CUSTOM_HTTPS_PORT\n"

# Replace ports as desired in mustache config files
sed -i "s/^\([ \t]\+listen[ \t]\+[]:[]*\)$DEFAULT_HTTP_PORT\([^0-9]\)/\1$CUSTOM_HTTP_PORT\2/" /usr/syno/share/nginx/*.mustache
sed -i "s/^\([ \t]\+listen[ \t]\+[]:[]*\)$DEFAULT_HTTPS_PORT\([^0-9]\)/\1$CUSTOM_HTTPS_PORT\2/" /usr/syno/share/nginx/*.mustache

echo -e "\n[ ] Restarting Nginx..."
if grep -q 'majorversion="7"' "/etc.defaults/VERSION"; then
    nginx -s reload
    echo "[✔] Nginx reloaded!"
else
    if which synoservicecfg; then
        synoservicecfg --restart nginx
    else
        synosystemctl restart nginx
    fi
    echo "[✔] Nginx restarted!"
fi
