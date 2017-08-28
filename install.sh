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
            echo "--noboot         do not start at boot"
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
echo "- Copying files"

printf "#!/bin/sh\ncd /etc/nsfw/\npython nsfw.py /etc/nsfw/stocks.conf" > /usr/local/bin/nsfw
chmod a+x /usr/local/bin/nsfw
echo "  * nsfw copied to /usr/local/bin/nsfw"

mkdir -p /etc/nsfw/

chmod a+x nsfw.py
cp nsfw.py /etc/nsfw/
echo "  * nsfw.py copied to /etc/nsfw/nsfw.py"

chmod a+r stocks.conf
cp stocks.conf /etc/nsfw/
echo "  * stocks.conf copied to /etc/nsfw/stocks.conf"

#  Add crontab job for startup - optional
if [ "$ONBOOT" -eq "1" ]; then
    crontab -l | { cat; echo "@reboot /usr/local/bin/nsfw >/var/log/nsfw.log 2>&1"; } | crontab -
    echo "- Added crontab job at reboot"
fi
