import gintro / [gtk]

proc onClickMainHelp*(b: Button) =
  #[
    Show help for main and credit in new dialog
  ]#
  let
    anonAbout = newAboutDialog()
  
  anonAbout.setProgramName("AnonSurf")
  anonAbout.setVersion("2.13.0")
  anonAbout.setAuthors(["Nong Hoang Tu", "Palinuro"])
  anonAbout.setComments("Anonymous Toolkit for Parrot OS")
  anonAbout.setCopyright("2020 Palinuro")
  anonAbout.setLicense("GPL-3.0")
  anonAbout.setWebsite("https://nest.parrot.sh/packages/tools/anonsurf")
  anonAbout.setWebsiteLabel("Source")

  discard anonAbout.run()
  anonAbout.destroy()


proc onClickAnonHelp*(b: Button) =
  #[
    Show help about AnonSurf in new dialog
    1. How to use
    2. Explain
  ]#
  discard