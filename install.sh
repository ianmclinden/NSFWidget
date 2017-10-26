#!/bin/bash

#  install.sh
#  Install NSFWidget. Must be run as root.

# Permission check
if ! [ $(id -u) = 0 ]; then
   echo "This script must be run as root" 
   exit 1
fi

ONBOOT=1
while test $# -gt 0; do
    case "$1" in
        -h|--help)
            echo "$.install.sh - NSFWidget installer"
            echo " "
            echo "$.install.sh [-h|--help] [--noboot]"
            echo " "
            echo "options:"
            echo "-h, --help       show brief help"
            echo "--noboot         specify an action to use"
            exit 0
            ;;
        --noboot)
            ONBOOT=0
            shift
            ;;
        *)
            echo "! Bad argument, ${1}"
            echo "try $.install.sh --help"
            exit 0
            ;;
    esac
done

#  Install python dependencies
echo "- Installing python library dependencies"
python -m pip install fourletterphat
python -m pip install yahoo-finance

#  Copy files && change permissions
NSFW_DIR=/etc/nsfw
echo "- Copying files"

mkdir -p $NSFW_DIR

chmod a+x nsfw.py
cp nsfw.py $NSFW_DIR
echo "  * nsfw.py copied to ${NSFW_DIR}/nsfw.py"

chmod a+r stocks.conf
cp stocks.conf $NSFW_DIR
echo "  * stocks.conf copied to ${NSFW_DIR}/stocks.conf"

# Create nsfw.service file
SERVICE_FILE=/etc/systemd/system/nsfw.service
echo "[Unit]" >> $SERVICE_FILE
echo "Description=NSFW" >> $SERVICE_FILE
echo "Wants=network-online.target" >> $SERVICE_FILE
echo "After=network.target network-online.target" >> $SERVICE_FILE
echo "" >> $SERVICE_FILE
echo "[Service]" >> $SERVICE_FILE
echo "Type=simple" >> $SERVICE_FILE
echo "User=root" >> $SERVICE_FILE
echo "ExecStart=${NSFW_DIR}/nsfw.py ${NSFW_DIR}/stocks.conf" >> $SERVICE_FILE
echo "SuccessExitStatus=0" >> $SERVICE_FILE
echo "TimeoutStopSec=10" >> $SERVICE_FILE
echo "Restart=on-failure" >> $SERVICE_FILE
echo "RestartSec=5" >> $SERVICE_FILE
echo "" >> $SERVICE_FILE
echo "[Install]" >> $SERVICE_FILE
echo "WantedBy=multi-user.target" >> $SERVICE_FILE

systemctl daemon-reload
echo "- created nsfw service"

#  Optional - enable nsfw.service
if [ "$ONBOOT" -eq "1" ]; then
	systemctl enable nsfw.service
    echo "- enabled nsfw at boot"
else
    echo "- nsfw not enabled at boot. To enable at boot, run"
    echo "systemctl enable nsfw.service"
fi


