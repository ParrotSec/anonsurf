all:

clean:

install:
	mkdir bin/
	nim c --nimcache:/tmp --out:bin/dnstool -d:release nimsrc/extra-tools/dnstool.nim
	nim c --nimcache:/tmp --out:bin/make-torrc -d:release nimsrc/anonsurf/make_torrc.nim
	nim c --nimcache:/tmp --out:bin/anonsurf-gtk -d:release nimsrc/anonsurf/AnonSurfGTK.nim