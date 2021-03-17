all: build install

clean:
	rm -rf bin

uninstall:
	rm -rf /etc/anonsurf/
	rm -rf /usr/lib/anonsurf/
	rm /usr/bin/anonsurf /usr/bin/anonsurf-gtk /lib/systemd/system/anonsurfd.service /usr/share/applications/anonsurf*.desktop

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
	nim c --nimcache:/tmp --out:bin/dnstool -d:release nimsrc/extra-tools/dnstool.nim
	nim c --nimcache:/tmp --out:bin/make-torrc -d:release nimsrc/anonsurf/make_torrc.nim
	nim c --nimcache:/tmp --out:bin/anonsurf-gtk -d:release nimsrc/anonsurf/AnonSurfGTK.nim
	nim c --nimcache:/tmp --out:bin/anonsurf -d:release nimsrc/anonsurf/AnonSurfCli.nim

install:
	mkdir -p /etc/anonsurf/
	mkdir -p /usr/lib/anonsurf/
	cp bin/anonsurf /usr/bin/anonsurf
	cp bin/anonsurf-gtk /usr/bin/anonsurf-gtk
	cp launchers/non-native/*.desktop /usr/share/applications/
	cp daemon/anondaemon /usr/lib/anonsurf/anondaemon
	cp configs/* /etc/anonsurf/.
	cp sys-units/anonsurfd.service /lib/systemd/system/anonsurfd.service