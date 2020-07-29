import gintro / [gtk, gobject]
import .. / actions / gtkClick
import about


proc makeTitleBar*(): Box =
  #[
    "Simulate" Title bar for AnonSurf
    This version should use less RAM
  ]#
  let
    boxTitle = newBox(Orientation.horizontal, 3)
    labelTitle = newLabel("AnonSurf GTK")
    btnExit = newButton("")
    imgExit = newImageFromIconName("exit", 3)
    btnAbout = newButton("")
    imgAbout = newImageFromIconName("help-about", 3)
  
  btnExit.setImage(imgExit)
  btnExit.connect("clicked", onClickExit)

  btnAbout.setImage(imgAbout)
  btnAbout.connect("clicked", onClickAbout)

  boxTitle.packStart(labelTitle, true, true, 3)
  boxTitle.packEnd(btnExit, false, true, 0)
  boxTitle.packEnd(btnAbout, false, true, 0)

  return boxTitle


# proc makeTitleBar*(): Box =
  # #[
  #   "Simulate" Title bar for AnonSurf
  #   This is more RAM version and should be more beautiful
  # ]#
  # let
  #   boxTitle = newBox(Orientation.horizontal, 3)
  #   boxLabel = newBox(Orientation.horizontal, 3)
  #   boxButtons = newBox(Orientation.horizontal, 3)
  #   labelTitle = newLabel("AnonSurf GTK")
  #   btnExit = newButton("")
  #   imgExit = newImageFromIconName("exit", 3)
  #   btnAbout = newButton("")
  #   imgAbout = newImageFromIconName("help-about", 3)
  
  # btnExit.setImage(imgExit)
  # btnExit.connect("clicked", onClickExit)

  # btnAbout.setImage(imgAbout)
  # btnAbout.connect("clicked", onClickAbout)

  # boxButtons.add(btnAbout)
  # boxButtons.add(btnExit)

  # boxLabel.add(labelTitle)

  # boxTitle.packStart(boxLabel, true, true, 3)
  # boxTitle.packEnd(boxButtons, false, true, 3)
  # # boxTitle.packEnd(btnExit, false, true, 0)
  # # boxTitle.packEnd(btnAbout, false, true, 0)

  # return boxTitle
