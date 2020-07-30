all:

clean:

install:
	mkdir bin/
	nim c --nimcache:/tmp --out:bin/dnstool nimsrc/extra-tools/dnstool.nim
	nim c --nimcache:/tmp --out:bin/make-torrc nimsrc/anonsurf/make_torrc.nim
	nim c --nimcache:/tmp --out:bin/anonsurf-gtk nimsrc/anonsurf/AnonSurfGTK.nim