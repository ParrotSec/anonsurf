all: build install

clean:
	rm -rf bin

uninstall:
	rm -rf /etc/anonsurf/
	rm -rf /usr/lib/anonsurf/
	rm $(DESTDIR)/usr/bin/anonsurf $(DESTDIR)/usr/bin/anonsurf-gtk $(DESTDIR)/lib/systemd/system/anonsurfd.service $(DESTDIR)/usr/share/applications/anonsurf*.desktop

build-parrot:
	# Compile binary on parrot's platform. libnim-gintro-dev is required. Developed with version 0.8.0
	mkdir -p bin/
	nim c --nimcache:/tmp --out:bin/dnstool -d:release nimsrc/extra-tools/dnstool.nim
	nim c --nimcache:/tmp --out:bin/make-torrc -d:release nimsrc/anonsurf/make_torrc.nim
	nim c --nimcache:/tmp --out:bin/anonsurf-gtk -p:/usr/include/nim/ -d:release nimsrc/anonsurf/AnonSurfGTK.nim
	nim c --nimcache:/tmp --out:bin/anonsurf -p:/usr/include/nim/ -d:release nimsrc/anonsurf/AnonSurfCli.nim

build:
	# Build on other system. nimble install gintro is required
	# Note: The project was made with gintro 0.8.0. 
	mkdir -p bin/
	nim c --out:bin/dnstool -d:release nimsrc/extra-tools/dnstool.nim
	nim c --out:bin/make-torrc -d:release nimsrc/anonsurf/make_torrc.nim
	nim c --out:bin/anonsurf-gtk -d:release nimsrc/anonsurf/AnonSurfGTK.nim
	nim c --out:bin/anonsurf -d:release nimsrc/anonsurf/AnonSurfCli.nim

install:
	mkdir -p $(DESTDIR)/etc/anonsurf/
	mkdir -p $(DESTDIR)/usr/lib/anonsurf/
	mkdir -p $(DESTDIR)/usr/bin/anonsurf/
	mkdir -p $(DESTDIR)/usr/share/applications/
	mkdir -p $(DESTDIR)/lib/systemd/system/
	cp bin/anonsurf $(DESTDIR)/usr/bin/anonsurf
	cp bin/anonsurf-gtk $(DESTDIR)/usr/bin/anonsurf-gtk
	cp launchers/non-native/*.desktop $(DESTDIR)/usr/share/applications/
	cp daemon/anondaemon $(DESTDIR)/usr/lib/anonsurf/anondaemon
	cp configs/* $(DESTDIR)/etc/anonsurf/.
	cp sys-units/anonsurfd.service $(DESTDIR)/lib/systemd/system/anonsurfd.service
