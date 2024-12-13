#!/bin/bash

# Checking right permissions ...
if [ "$(id -u)" -ne 0 ]; then
    echo "Permission denied. Please run this script as root or with sudo."
    exit 1
fi

# fixing the issue when running scripts with sudo ...
INVOKING_USER=${SUDO_USER:-$(logname)}

echo "Creating a log file Please wait..."
sleep 1
LOG_FILE="/var/log/monitor_system.log"
# CONTENT_LOG_FILE="[Service]
# ExecStart=/usr/bin/python3 /home/$INVOKING_USER/acba/resource-monitoring.py
# StandardOutput=append:/var/log/monitor_system.log
# StandardError=append:/var/log/monitor_system.log"
# echo "$CONTENT_LOG_FILE" > "$LOG_FILE"

# creating log file ...
if [ ! -f "$LOG_FILE" ]; then
    echo "Creating log file at $LOG_FILE..."
    touch "$LOG_FILE"
    if [ $? -ne 0 ]; then
        echo "Failed to create $LOG_FILE. Check permissions."
        exit 1
    fi
else
    echo "Log file $LOG_FILE already exists."
fi

# Set permissions and ownership
chmod 664 "$LOG_FILE"
if [ $? -ne 0 ]; then
    echo "Failed to set permissions on $LOG_FILE."
    exit 1
fi

chown "$INVOKING_USER:$INVOKING_USER" "$LOG_FILE"
if [ $? -ne 0 ]; then
    echo "Failed to set ownership on $LOG_FILE."
    exit 1
fi

echo "Log file is ready at $LOG_FILE with proper permissions and ownership."

### Creating monitoring service ###
echo "Creating monitoring service Please wait..."
sleep 1
echo ".................."
sleep 1
echo ".................."

SERVICE_FILE="/etc/systemd/system/resource-monitor.service"
SCRIPT_SOURCE="/home/$INVOKING_USER/acba/resource-monitoring.py"
# echo "$INVOKING_USER" # to be deleted
SCRIPT_DEST="/opt/resource-monitoring/resource-monitoring.py"
CONTENT="[Unit]
Description=System Resource Monitor Service
After=network.target

[Service]
ExecStart=/usr/bin/python3 /opt/resource-monitoring/resource-monitoring.py
WorkingDirectory=/opt/resource-monitoring
Restart=always
RestartSec=10
User=$INVOKING_USER
Environment=\"PYTHONUNBUFFERED=1\"

[Install]
WantedBy=multi-user.target"

# Creating target dir...
if [ ! -d "/opt/resource-monitoring" ]; then
    mkdir -p /opt/resource-monitoring || { echo "Failed to create /opt/resource-monitoring"; exit 1; }
    echo "Created directory /opt/resource-monitoring"
fi

# Moving to /opt/resource-monitoring...
if [ -f "$SCRIPT_SOURCE" ]; then
    mv "$SCRIPT_SOURCE" "$SCRIPT_DEST" || { echo "Failed to move script"; exit 1; }
    # echo "Moved $SCRIPT_SOURCE to $SCRIPT_DEST"
else
    echo "Source script $SCRIPT_SOURCE not found. Exiting."
    exit 1
fi

# Set the correct permissions on the target directory and script
chmod 755 /opt/resource-monitoring
chmod 744 "$SCRIPT_DEST"
chown -R "$INVOKING_USER:$INVOKING_USER" /opt/resource-monitoring || { echo "Failed to set permissions"; exit 1; }

# Note: Create or overwrite don't append
echo "$CONTENT" > "$SERVICE_FILE" || { echo "Failed to create service file"; exit 1; }
sleep 1
echo "Created service file at $SERVICE_FILE"

# Check creation...
if [ $? -eq 0 ]; then
    echo "Service file created at $SERVICE_FILE"
else
    echo "Failed to create the service file"
    exit 1
fi

systemctl daemon-reload
systemctl enable resource-monitor.service
systemctl start resource-monitor.service || { echo "Failed to start service"; exit 1; }
sleep 1
echo "#########################################"
echo "Service has been started. Use the following command to check its status: "
echo "sudo systemctl status resource-monitor.service"
echo "#########################################"
echo "For uninstalling the service simply run: "
echo "sudo ./uninstall.sh"

