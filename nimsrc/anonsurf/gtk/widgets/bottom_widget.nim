import gintro / [gtk, gobject]
import .. / ansurf_icons
import about_widget
import options_widget


proc makeBottomBar*(bSwitchWidget: Button): Box =
  let
    btnAbout = newButton("")
    btnSettings = newButton("")
    imgAbout = newImageFromPixbuf(aboutIcon)
    bxBottomBar = newBox(Orientation.horizontal, 3)
  
  btnAbout.setImage(imgAbout)
  btnAbout.connect("clicked", onClickAbout)

  btnSettings.setImage(newImageFromIconName("preferences-desktop", 4))
  btnSettings.connect("clicked", onClickOptions)

  bxBottomBar.packStart(bSwitchWidget, false, true, 3)
  bxBottomBar.packEnd(btnAbout, false, true, 3)
  # bxBottomBar.packEnd(btnSettings, false, true, 3)

  return bxBottomBar
