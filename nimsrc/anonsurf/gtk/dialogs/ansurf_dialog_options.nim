import gintro / gtk


proc initOptionBridge(cb: ComboBoxText, active: int) =
  cb.appendText("No Bridge")
  cb.appendText("Automation")
  cb.appendText("Manual")
  cb.active = active 


proc initEntryBridge(en: Entry) =
  en.setPlaceholderText("Bridge address")
  en.setTooltipText("We should put format here?")


proc onClickOptions*(b: Button) =
  let
    dialogSettings = newDialog()
    dialogArea = dialogSettings.getContentArea()
    optionBridge = newComboBoxText()
    addrBridge = newEntry()
    optionSandbox = newCheckButton("Sandbox mode")

  initOptionBridge(optionBridge, 0) # TODO load active number from settings instead
  initEntryBridge(addrBridge)

  dialogArea.add(optionBridge)
  dialogArea.add(addrBridge)
  dialogArea.add(optionSandbox)

  dialogSettings.setTitle("AnonSurf Settings")
  dialogSEttings.setIconName("preferences-desktop")

  dialogSettings.showAll()
  discard dialogSettings.run()
  dialogSettings.destroy()
