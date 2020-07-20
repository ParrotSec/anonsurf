import gintro / [gtk, vte, glib]


proc onClickTorStatus*(b: Button) =
  #[
    Spawn a native GTK terminal and run nyx with it to show current tor status
  ]#
  let
    statusDialog = newDialog()
    statusArea = statusDialog.getContentArea()
    nyxTerm = newTerminal()

  statusDialog.setTitle("Tor bandwidth")

  nyxTerm.spawnAsync(
    {noLastlog}, # pty flags
    nil, # working directory
    ["/usr/bin/nyx", "--config", "/etc/anonsurf/nyxrc"], # args
    [], # envv
    {doNotReapChild}, # spawn flag
    nil, # Child setup
    nil, # child setup data
    nil, # chlid setup data destroy
    -1, # timeout
    nil, # cancellabel
    nil, # callback
    nil, # pointer
  )

  statusArea.packStart(nyxTerm, false, true, 3)
  statusDialog.showAll()


proc onClickBoot*(b: Button) =
  #[
    Create condition to enable or disable anonsurf at boot
    when we click on button
  ]#
  if b.label == "Enable":
    if spawnCommandLineAsync("gksudo /usr/bin/anonsurf enable-boot"):
      b.label = "Enabling"
    else:
      discard
  else:
    if spawnCommandLineAsync("gksudo /usr/bin/anonsurf disable-boot"):
      b.label = "Disabling"
    else:
      discard


proc onClickRestart*(b: Button) =
  #[
    Run anonsurf restart
  ]#
  if spawnCommandLineAsync("gksudo /usr/bin/anonsurf restart"):
    b.label = "Wait"
  else:
    discard
