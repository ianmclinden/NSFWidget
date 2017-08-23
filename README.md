
# NSFW: Nano Stocks 'Folio Widget

    .##....##..########..########.##......##
    .###...##.##..##..##.##.......##..##..##
    .####..##.##..##.....##.......##..##..##
    .##.##.##..########..######...##..##..##
    .##..####.....##..##.##.......##..##..##
    .##...###.##..##..##.##.......##..##..##
    .##....##..########..##........###..###.

Lightweight stock ticker tape for the Raspberry Pi Zero W, and Pimoroni's Four Letter pHAT.

## About:
![NSFWidget Preview Image](https://user-images.githubusercontent.com/8931381/29596957-454cade8-8785-11e7-8d44-068dc45133a3.gif)

## Hardware List:
- [Raspberry Pi Zero W](https://www.raspberrypi.org/products/raspberry-pi-zero-w/)
- Raspberry Pi Zero W GPIO Male Header
- [Pimoroni Four Letter pHAT](https://shop.pimoroni.com/products/four-letter-phat)
- Raspberry Pi Accessories - SD card, power, etc.

## Setup:
- Solder GPIO Header onto Raspberry Pi Zero W
- Follow the [Pimoroni pHAT Setup Guide](https://learn.pimoroni.com/tutorial/sandyj/soldering-phats) to solder pHAT Headers, and attach to Pi.
- Follow the [Raspberry Pi Hardware Guide](https://www.raspberrypi.org/learning/hardware-guide/) to set up a Raspberry Pi Zero W with raspbian, connect the Raspberry Pi to your Wifi AP/Router, and log in via SSH.

## Installation / Use:
Log into the Raspberry Pi and clone the NSFWidget Repository and enter the directory:
```
    git clone https://github.com/ianmclinden/NSFWidget.git
    cd NSFWidget/
```

An [installation script](install.sh) has been provided to install NSFWidget and the required dependencies, and automatically load NSFWidget at boot. Just run
```
    sudo ./install.sh
```

or run with the `--noboot` flag to keep from automatically starting NSFWidget at boot.
```
    sudo ./install.sh --noboot
```

After installation, edit your stock preferences in `/etc/nsfw/stocks.conf`. Then, run NSFWidget, using
```
    $nsfw
```

#### Manual Installation / Use:
NSFWidget requires the following python libraries:
- [fourletterphat](https://github.com/pimoroni/fourletter-phat)
- [yahoo-finance](https://pypi.python.org/pypi/yahoo-finance)
which can be installed via pip.

Then, run using the python environment using 
```
    python nsfwidget.py [stocks_file.conf]
```

## Files:
- [nsfw.pi](nsfw.pi): Main logic
- [stocks.conf](stocks.conf): Configures what stocks to watch
- [install.sh](install.sh): Installation script

## Author
Ian McLinden 2017
https://github.com/ianmclinden
