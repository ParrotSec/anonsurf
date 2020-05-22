all:

clean:

install:
	#nim c src/AnonSurfGUI.nim
	nim c --nimcache:/tmp src/dnstool.nim
	nim c --nimcache:/tmp src/make_torrc.nim

	# Make dest folders for Deb packaging
	mkdir -p $(DESTDIR)/etc/anonsurf/
	mkdir -p $(DESTDIR)/etc/tor/
	# mkdir -p $(DESTDIR)/etc/init.d/
	mkdir -p $(DESTDIR)/usr/bin/
	mkdir -p $(DESTDIR)/usr/share/applications/
	mkdir -p $(DESTDIR)/usr/share/parrot-menu/applications/
	mkdir -p $(DESTDIR)/lib/systemd/system/

	# Add basfiles to /etc
	cp onion.pac $(DESTDIR)/etc/anonsurf/onion.pac
	ln -s /etc/anonsurf/onion.pac $(DESTDIR)/etc/tor/onion.pac
	cp torrc.base $(DESTDIR)/etc/anonsurf/torrc.base
	cp obfs4bridge.list $(DESTDIR)/etc/anonsurf/obfs4bridge.list

	# Add core files
	cp binaries/anonsurf $(DESTDIR)/usr/bin/
	cp -rf launchers/* $(DESTDIR)/usr/share/applications/
	ln -s /usr/bin/anonsurf $(DESTDIR)/usr/bin/anon

	# Add custom binaries from nim sources
	# cp src/AnonSurfGUI $(DESTDIR)/usr/bin/anonsurf-gtk
	cp src/dnstool $(DESTDIR)/usr/bin/
	cp src/make_torrc $(DESTDIR)/etc/anonsurf/make-torrc

	# Add system units
	cp daemon/anondaemon $(DESTDIR)/etc/anonsurf/
	cp sys-units/anonsurfd.service $(DESTDIR)/lib/systemd/system/
	cp sys-units/anonsurfd@tor.service $(DESTDIR)/lib/systemd/system/
	# cp sys-units/anonsurfd $(DESTDIR)/etc/init.d/

	# Init permission for folders
	chown root:root $(DESTDIR)/etc/anonsurf -R
	chmod 644 $(DESTDIR)/etc/anonsurf -R

	# Init permission for files
	chown root:root $(DESTDIR)/usr/bin/anonsurf
	chmod 775 $(DESTDIR)/usr/bin/anonsurf
	chmod 775 $(DESTDIR)/etc/anonsurf/anondaemon
	chmod 775 $(DESTDIR)/usr/bin/dnstool
	chmod 775 $(DESTDIR)/etc/anonsurf/make-torrc
