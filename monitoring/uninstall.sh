#!/bin/bash

sudo systemctl stop resource-monitor.service
sudo systemctl disable resource-monitor.service
sudo rm /etc/systemd/system/resource-monitor.service
sudo rm -rf /opt/resource_monitor
sudo rm /var/log/monitor_system.log
sudo systemctl daemon-reload
