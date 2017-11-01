#!/usr/bin/env python
infotext="""
    .##....##..########..########.##......##
    .###...##.##..##..##.##.......##..##..##
    .####..##.##..##.....##.......##..##..##
    .##.##.##..########..######...##..##..##
    .##..####.....##..##.##.......##..##..##
    .##...###.##..##..##.##.......##..##..##
    .##....##..########..##........###..###.

    Nano Stocks 'Folio Widget

    Lightweight stock ticker tape for the Raspberry Pi Zero W,
    and Pimoroni's Four Letter pHAT. Configuration in stocks.conf, or
    in config file specified as a command line argument.

    Usage: `python nsfwidget.py [stocks_file.conf]`

    Ian McLinden 2017
    https://github.com/ianmclinden
"""


import sys
try:
    from collections import defaultdict
    from functools import partial
    import fourletterphat as flp
    import socket
    import urllib2
    from yahoo_finance import Share
    import time
except Exception as e:
    sys.exit( str(e) +"\nTry installing the module with `pip install %s`"%str(e).split()[-1] )

def main():
    flp.clear()
    flp.print_str("NSFW")
    flp.show()

    print(infotext)
    print("\nPress Ctrl-C to exit.\n")

    wait_for_internet_connection()
    stocks = get_stocks_from_config("stocks.conf")

    flp.glow(period=0.5, duration=4)
    flp.clear()
    flp.show()

    print("Watching Stocks:")
    print("\n".join([sym+": "+share.get_name()+" ("+str(own)+" owned)" for sym,own,share in stocks]))

    while(len(stocks)>0):
        show_latest(stocks)

    print("No stocks...")


# Stock info logic
def show_latest(stocks):
    folio = defaultdict(float) # {'USD':'123.45'}, e.g.

    for symbol,owned,share in stocks:
        flp.clear()
        flp.print_str(symbol)
        flp.show()

        pstr = symbol

        try:
            share.refresh()
        except Exception as e:
            time.sleep(0.5)

        pstr +="  $"+ share.get_price() +" "+ share.get_currency()

        if (owned>0):
            # Append folio info if any stocks owned
            total = float(share.get_price())*float(owned)
            pstr +=", "+ str(round(owned,3))+ " OWNED, VAL $"+ str(round(total,2)) +" "+ share.get_currency()
            folio[share.get_currency()] += total

        scroll_print_float_str(pstr, interval=0.2)
        flp.clear()
        flp.show()
        time.sleep(1)

    # If any stocks were owned
    if (len(folio)>0):
        # Print a value for every currency
        folio_str = "    FOLIO VAL"
        for currency,val in folio.items():
            folio_str += "  $"+str(round(val,2))+" "+currency

        scroll_print_float_str(folio_str, interval=0.25)
        flp.clear()
        flp.show()
        time.sleep(1)


# Four Letter pHAT helper
def scroll_print_float_str(strn, interval=0.3):
    if (len(strn)>0):
        time.sleep(interval*3.0)

        for ln in [strn[x:x+5] if ('.' in strn[x:x+5]) else strn[x:x+4] for x in xrange(0,len(strn)-3)]:
            if (ln[0]!='.'):
                flp.print_number_str(ln)
                flp.show()
                time.sleep(interval)

        time.sleep(interval*2.0)

# Configuration Loader
def get_stocks_from_config(conf_filename):
    if (len(sys.argv)>1):
        conf_filename = sys.argv[1]

    while True:
        try:
            with open(conf_filename) as conf_f:
                lines = conf_f.readlines()
                # Strip whitespace and capitalize, remove comments and empty lines
                lines[:] = [x.strip().upper() for x in lines if x.strip()]
                lines[:] = [x.split() for x in lines if not x.startswith("#")]

                # Stocks list of ('symbol', shares, Share())
                return [(x[0], float(x[1]), Share(x[0])) if len(x)>1 else (x[0],0.0,Share(x[0])) for x in lines]

        except urllib2.HTTPError as e:
            # wait for a good config load
            if (e.code == 400):
                pass
        except Exception as e:
            print(e)
            sys.exit("Error loading stock info from file: "+conf_filename)

def wait_for_internet_connection():
    while True:
        try:
            socket.setdefaulttimeout(1)
            socket.socket(socket.AF_INET, socket.SOCK_STREAM).connect(("8.8.8.8", 53))
            return
        except Exception:
            pass

# System and error handler
if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt, SystemExit:
        print('Exiting...')
        sys.exit(0)
