all:

clean:

install:
	#nim c src/AnonSurfGUI.nim
	nim c --nimcache:/tmp src/dnstool.nim
	mkdir -p $(DESTDIR)/etc/anonsurf/
	mkdir -p $(DESTDIR)/etc/tor/
	mkdir -p $(DESTDIR)/etc/init.d/
	mkdir -p $(DESTDIR)/usr/bin/
	mkdir -p $(DESTDIR)/usr/share/applications/
	mkdir -p $(DESTDIR)/usr/share/parrot-menu/applications/
	mkdir -p $(DESTDIR)/lib/systemd/system/
	cp onion.pac $(DESTDIR)/etc/anonsurf/onion.pac
	ln -s /etc/anonsurf/onion.pac $(DESTDIR)/etc/tor/onion.pac
	cp torrc $(DESTDIR)/etc/anonsurf/torrc
	
	# cp src/AnonSurfGUI $(DESTDIR)/usr/bin/anonsurf-gtk
	cp -r src/dnstool $(DESTDIR)/usr/bin/
	cp daemon/anondaemon $(DESTDIR)/etc/anonsurf/
	cp sys-units/anonsurfd.service $(DESTDIR)/lib/systemd/system/
	# cp sys-units/anonsurfd $(DESTDIR)/etc/init.d/
	cp binaries/anonsurf $(DESTDIR)/usr/bin/
	# cp resolv.conf.opennic $(DESTDIR)/etc/anonsurf/resolv.conf.opennic

	cp -rf launchers/* $(DESTDIR)/usr/share/applications/
	chown root:root $(DESTDIR)/usr/bin/anonsurf
	# chown root:root $(DESTDIR)/etc/anonsurf/resolv.conf.opennic
	chmod 775 $(DESTDIR)/usr/bin/anonsurf
	ln -s /usr/bin/anonsurf $(DESTDIR)/usr/bin/anon
	chown root:root $(DESTDIR)/etc/anonsurf -R
	chmod 644 $(DESTDIR)/etc/anonsurf -R
	chmod 775 $(DESTDIR)/etc/anonsurf/anondaemon
	chmod 775 $(DESTDIR)/usr/bin/dnstool
