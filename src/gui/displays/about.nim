import gintro / [gtk, gdkpixbuf]
import system


proc onClickAbout*(b: Button) =
  #[
    Show help for main and credit in new dialog
  ]#
  const readImgLogo = staticRead("../../../icons/anon-about.svg")
  let
    dlgAbout = newAboutDialog()
    bufLoader = newPixbufLoader()
  
  discard bufLoader.write(readImgLogo)
  discard bufLoader.close()
  let imgLogo: Pixbuf = bufLoader.getPixbuf()
  # discard dlgAbout.setIconFromFile("/usr/share/icons/anonsurf.png")
  dlgAbout.setLogo(imgLogo)
  dlgAbout.setProgramName("AnonSurf")
  dlgAbout.setVersion("3.0.0")
  dlgAbout.setArtists([
    "Federica \"marafed\" Marasà",
    "Manuel \"Serverket\" Hernandez",
  ]) # Artwork by
  # dlgAbout.setDocumenters([]) # Documented by
  # dlgAbout.setTranslatorCredits([]) # Translated by
  dlgAbout.setAuthors([
    "Lorenzo \"Palinuro\" Faletra",
    "Nong Hoang \"DmKnght\" Tu",
    "Lisetta \"Sheireen\" Ferrero",
    "Francesco \"Mibofra\" Bonanno",
  ])
  dlgAbout.setComments("Anonymous Toolkit for Parrot OS")
  dlgAbout.setCopyright(
    "Copyright © 2013 - 2020 Lorenzo \"Palinuro\" Faletra\nCopyright © 2020 Parrot Security CIC"
  )
  dlgAbout.setLicenseType(gpl_3_0)
  dlgAbout.setWebsite("https://nest.parrot.sh/packages/tools/anonsurf")
  dlgAbout.setWebsiteLabel("Source")

  discard dlgAbout.run()
  dlgAbout.destroy()
