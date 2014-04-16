#!/bin/sh

# AnonSurf is inspired to the original backbox-anonymous script 
# distributed as part of backbox-default-settings package.
# It was modified and forked from the homonimous module of PenMode in order to make it fully compatible with
# Parrot Security OS and other debian-based systems, and it is part of
# parrot-anon package.
#
#
# Devs:
#    Lorenzo 'EclipseSpark' Faletra <eclipse@frozenbox.org>
#    Lisetta 'Sheireen' Ferrero <sheireen@frozenbox.org>
#
#
# anonsurf is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as 
# published by the Free Software Foundation, either version 3 of the 
# License, or (at your option) any later version.
# You can get a copy of the license at www.gnu.org/licenses
#
# anonsurf is distributed in the hope that it will be 
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with backbox-anonymous. If not, see <http://www.gnu.org/licenses/>.


export BLUE='\033[1;94m'
export GREEN='\033[1;92m'
export RED='\033[1;91m'
export RESETCOLOR='\033[1;00m'

# Destinations you don't want routed through Tor
TOR_EXCLUDE="192.168.0.0/16 172.16.0.0/12 10.0.0.0/8"

# The UID Tor runs as
# change it if, starting tor, the command 'ps -e | grep tor' returns a different UID
TOR_UID="debian-tor"

# Tor's TransPort
TOR_PORT="9040"



case "$1" in
    start)
		# Make sure only root can run this script
		if [ $(id -u) -ne 0 ]; then
		  echo "\n$GREEN[$RED!$GREEN] $RED R U DRUNK?? This script must be run as root$RESETCOLOR\n" >&2
		  exit 1
		fi
		
		# Check defaults for Tor
		grep -q -x 'RUN_DAEMON="yes"' /etc/default/tor
		if [ $? -ne 0 ]; then
			echo "\n$GREEN[$RED!$GREEN]$RED Please add the following to your /etc/default/tor and restart service:$RESETCOLOR\n" >&2
			echo "$BLUE#----------------------------------------------------------------------#$RESETCOLOR"
			echo 'RUN_DAEMON="yes"'
			echo "$BLUE#----------------------------------------------------------------------#$RESETCOLOR\n"
			exit 1
		fi		
		
		# Check torrc config file
		grep -q -x 'VirtualAddrNetwork 10.192.0.0/10' /etc/tor/torrc
		if [ $? -ne 0 ]; then
			echo "\n$RED[!] Please add the following to your /etc/tor/torrc and restart service:$RESETCOLOR\n" >&2
			echo "$BLUE#----------------------------------------------------------------------#$RESETCOLOR"
			echo 'VirtualAddrNetwork 10.192.0.0/10'
			echo 'AutomapHostsOnResolve 1'
			echo 'TransPort 9040'
			echo 'DNSPort 53'
			echo "$BLUE#----------------------------------------------------------------------#$RESETCOLOR\n"
			exit 1
		fi
		grep -q -x 'AutomapHostsOnResolve 1' /etc/tor/torrc
		if [ $? -ne 0 ]; then
			echo "\n$RED[!] Please add the following to your /etc/tor/torrc and restart service:$RESETCOLOR\n" >&2
			echo "$BLUE#----------------------------------------------------------------------#$RESETCOLOR"
			echo 'VirtualAddrNetwork 10.192.0.0/10'
			echo 'AutomapHostsOnResolve 1'
			echo 'TransPort 9040'
			echo 'DNSPort 53'
			echo "$BLUE#----------------------------------------------------------------------#$RESETCOLOR\n"
			exit 1
		fi
		grep -q -x 'TransPort 9040' /etc/tor/torrc
		if [ $? -ne 0 ]; then
			echo "\n$RED[!] Please add the following to your /etc/tor/torrc and restart service:$RESETCOLOR\n" >&2
			echo "$BLUE#----------------------------------------------------------------------#$RESETCOLOR"
			echo 'VirtualAddrNetwork 10.192.0.0/10'
			echo 'AutomapHostsOnResolve 1'
			echo 'TransPort 9040'
			echo 'DNSPort 53'
			echo "$BLUE#----------------------------------------------------------------------#$RESETCOLOR\n"
			exit 1
		fi
		grep -q -x 'DNSPort 53' /etc/tor/torrc
		if [ $? -ne 0 ]; then
			echo "\n$RED[!] Please add the following to your /etc/tor/torrc and restart service:$RESETCOLOR\n" >&2
			echo "$BLUE#----------------------------------------------------------------------#$RESETCOLOR"
			echo 'VirtualAddrNetwork 10.192.0.0/10'
			echo 'AutomapHostsOnResolve 1'
			echo 'TransPort 9040'
			echo 'DNSPort 53'
			echo "$BLUE#----------------------------------------------------------------------#$RESETCOLOR\n"
			exit 1
		fi

		echo "\n$GREEN[$BLUE i$GREEN ]$BLUE Starting anonymous mode:$RESETCOLOR\n"
		
		if [ ! -e /var/run/tor/tor.pid ]; then	
			echo " $RED*$BLUE Tor is not running! $GREEN starting $BLUE for you\n" >&2
			service tor start
			sleep 6
		fi
		
		if ! [ -f /etc/network/iptables.rules ]; then
			iptables-save > /etc/network/iptables.rules
			echo " $GREEN*$BLUE Saved iptables rules"
		fi

		iptablesip -F
		iptables -t nat -F
		
		echo -n " $GREEN*$BLUE Service "
		service resolvconf stop 2>/dev/null || echo "resolvconf already stopped"

		echo 'nameserver 127.0.0.1' > /etc/resolv.conf
		echo " $GREEN*$BLUE Modified resolv.conf to use Tor"

		iptables -t nat -A OUTPUT -m owner --uid-owner $TOR_UID -j RETURN #-m owner --uid-owner $TOR_UID
		iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 53
		for NET in $TOR_EXCLUDE 127.0.0.0/9 127.128.0.0/10; do
			iptables -t nat -A OUTPUT -d $NET -j RETURN
		done
		iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports $TOR_PORT
		iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
		for NET in $TOR_EXCLUDE 127.0.0.0/8; do
				iptables -A OUTPUT -d $NET -j ACCEPT
		done
		iptables -A OUTPUT -j ACCEPT # -m owner --uid-owner $TOR_UID 
		iptables -A OUTPUT -j REJECT
		echo "$GREEN *$BLUE Redirected all traffic throught Tor\n"
		echo "$GREEN[$BLUE i$GREEN ]$BLUE Are you using Tor?$RESETCOLOR\n"
		echo "$GREEN *$BLUE Please refer to $RED http://penmode.tk/ipphos$RESETCOLOR\n"
		
	;;
    stop)
    	sleep 1
		# Make sure only root can run our script
		if [ $(id -u) -ne 0 ]; then
		  echo "\n$GREEN[$RED!$GREEN] $RED R U DRUNK?? This script must be run as root$RESETCOLOR\n" >&2
		  exit 1
		fi
		
		echo "\n$GREEN[$BLUE i$GREEN ]$BLUE Stopping anonymous mode:$RESETCOLOR\n"
		
		iptables -F
		iptables -t nat -F
		echo " $GREEN*$BLUE Deleted all iptables rules"
		
		if [ -f /etc/network/iptables.rules ]; then
			iptables-restore < /etc/network/iptables.rules
			rm /etc/network/iptables.rules
			echo " $GREEN*$BLUE Restored iptables rules"
		fi
		
		echo -n " $GREEN*$BLUE Service "
		service resolvconf start 2>/dev/null || echo "resolvconf already started"
		sleep 1
		
		echo " $GREEN*$BLUE Stopped anonymous mode\n"
	;;
    restart)
    	sleep 1
		$0 stop
		sleep 1
		$0 start
	;;
    *)
	echo "Usage: $0 {start|stop|restart}"
	exit 1
	;;
esac

echo $RESETCOLOR
exit 0
