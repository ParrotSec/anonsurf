import gintro / [gtk, vte, gobject, glib]
import .. / ansurf_icons
import .. / gui_activities / core_activities


proc callback_dummy(terminal: ptr Terminal00; pid: int32; error: ptr glib.Error; userData: pointer) {.cdecl.} =
  #[
    Dummy callback proc to fix problem of VTE
  ]#
  discard


proc onVTEExit(v: Terminal, signal: int, d: Dialog) =
  ansurf_gtk_close_dialog(d)


proc onClickTorStatus*() =
  #[
    Spawn a native GTK terminal and run nyx with it to show current tor status
  ]#
  let
    statusDialog = newDialog()
    statusArea = statusDialog.getContentArea()
    nyxTerm = newTerminal()

  statusDialog.setTitle("Tor bandwidth")
  statusDialog.setResizable(false)
  statusDialog.setIcon(nyxIcon)

  nyxTerm.connect("child-exited", onVTEExit, statusDialog)
  nyxTerm.spawnAsync(
    {noLastlog}, # pty flags
    nil, # working directory
    ["/usr/bin/nyx", "--config", "/etc/anonsurf/nyxrc"], # args
    [], # envv
    {}, # spawn flag
    nil, # Child setup
    nil, # child setup data
    nil, # chlid setup data destroy
    -1, # timeout
    nil, # cancellabel
    callback_dummy, # callback
    nil, # pointer
  )

  statusArea.packStart(nyxTerm, false, true, 3)
  statusDialog.showAll()
