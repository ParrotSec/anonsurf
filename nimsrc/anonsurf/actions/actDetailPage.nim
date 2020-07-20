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
  if spawnCommandLineAsync("gksudo /usr/bin/anonsurf restart"):
    b.label = "Wait"
  else:
    discard
