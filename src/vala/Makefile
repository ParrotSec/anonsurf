all:
	mkdir -p build/
	nim c -d:release --noMain --app:staticlib -o:build/anonsurf.so anonsurf_api.nim
	# valac --pkg gtk+-3.0 anonsurf_gtk.vala gui/layout_main.vala gui/layout_titlebar.vala gui/dialog_about.vala gui/layout_systray.vala gui/dialog_options.vala gui/window_anonsurf.vala -X build/anonsurf.so -X -I. -o build/anonsurf-gtk
	valac --pkg gtk+-3.0 anonsurf_gtk.vala gui/layout_main.vala gui/layout_titlebar.vala gui/dialog_about.vala gui/layout_systray.vala gui/dialog_options.vala gui/window_anonsurf.vala -X build/anonsurf.so -o build/anonsurf-gtk