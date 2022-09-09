## Anonsurf

A tool by [ParrotSec](https://www.parrotsec.org/docs/anonsurf.html) written in Nim as an anonymous mode wrapper to force connections through [Tor](https://www.torproject.org/)

This fork changes the debian style service and directory structure, able to run on Archlinux which assumes
networkmanager, tor, iptables and dnsmasq are installed

### Tor Bridges
- List of default bridges are at https://gitlab.torproject.org/tpo/anti-censorship/team/-/wikis/Default-Bridges
### Thank to
- Ranjeetsih, who wrote example of sys-tray with GTK at https://www.codeproject.com/Articles/27142/Minimize-to-tray-with-GTK
- Vivek Gite, who wrote tutorial of hook script for dhclient https://www.cyberciti.biz/faq/dhclient-etcresolvconf-hooks/