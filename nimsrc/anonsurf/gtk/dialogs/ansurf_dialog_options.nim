import gintro / gtk


proc onClickOptions*(b: Button) =
  let
    dialogSettings = newDialog()
    dialogArea = dialogSettings.getContentArea()
    optionBridge = newComboBoxText()

  optionBridge.appendText("No Bridge")
  optionBridge.appendText("Automation")
  optionBridge.appendText("Manual Selection")
  optionBridge.active = 0


  dialogSettings.setTitle("AnonSurf Settings")
  dialogSEttings.setIconName("preferences-desktop")

  dialogArea.add(optionBridge)
  dialogSettings.showAll()
  discard dialogSettings.run()
  dialogSettings.destroy()
