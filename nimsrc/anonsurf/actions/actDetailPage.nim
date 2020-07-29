import gintro / [gtk, glib]


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
  # if spawnCommandLineAsync("gksudo /usr/bin/anonsurf restart"):
  #   let imgStatus = newImageFromIconName("system-restart-panel", 3)
  #   b.setImage(imgStatus)
  # else:
  #   discard
  discard spawnCommandLineAsync("gksudo /usr/bin/anonsurf restart")
