import gintro / [gtk, glib]


proc onClickBoot*(b: Button) =
  #[
    Create condition to enable or disable anonsurf at boot
    when we click on button
  ]#
  if b.label == "Enable":
    if spawnCommandLineAsync("gksudo /usr/bin/systemctl enable anonsurfd"):
      b.label = "Enabling"
    else:
      discard
  else:
    if spawnCommandLineAsync("gksudo /usr/bin/systemctl disable anonsurfd"):
      b.label = "Disabling"
    else:
      discard
