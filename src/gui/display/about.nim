import gintro / [gtk]


proc onClickAbout*(b: Button) =
  #[
    Show help for main and credit in new dialog
  ]#
  let
    dlgAbout = newAboutDialog()
  
  dlgAbout.setProgramName("AnonSurf")
  dlgAbout.setVersion("2.13.0")
  dlgAbout.setAuthors(["Nong Hoang Tu", "Palinuro"])
  dlgAbout.setComments("Anonymous Toolkit for Parrot OS")
  dlgAbout.setCopyright("2020 Palinuro")
  dlgAbout.setLicense("GPL-3.0")
  dlgAbout.setWebsite("https://nest.parrot.sh/packages/tools/anonsurf")
  dlgAbout.setWebsiteLabel("Source")

  discard dlgAbout.run()
  dlgAbout.destroy()