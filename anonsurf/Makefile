INSTALL=install -m 0644


all:

clean:

install:
	mkdir -p $(DESTDIR)/etc/anonsurf/
	mkdir -p $(DESTDIR)/etc/tor/
	mkdir -p $(DESTDIR)/usr/bin/
	mkdir -p $(DESTDIR)/etc/init.d/
	cp onion.pac $(DESTDIR)/etc/anonsurf/
	ln -s /etc/anonsurf/onion.pac $(DESTDIR)/etc/tor/onion.pac
	cp profile_for_tor.tar.gz $(DESTDIR)/etc/anonsurf/
	cp torrc $(DESTDIR)/etc/anonsurf/
	cp anonsurf.sh $(DESTDIR)/usr/bin/anonsurf
	cp anonsurf.sh $(DESTDIR)/etc/init.d/anonsurf
	chown root:root $(DESTDIR)/usr/bin/anonsurf
	chmod 775 $(DESTDIR)/usr/bin/anonsurf
	ln -s /usr/bin/anonsurf $(DESTDIR)/usr/bin/anon
	cp -rf anonsurf/* $(DESTDIR)/
	chown root:root $(DESTDIR)/etc/anonsurf -R
	chmod 644 $(DESTDIR)/etc/anonsurf -R
