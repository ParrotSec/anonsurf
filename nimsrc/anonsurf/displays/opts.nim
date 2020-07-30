import gintro / [gtk, gobject]


proc test(b: CheckButton) =
  echo "test"

# TODO check button state
proc makeOptionsDialog*(b: Button) =
  let
    optDialog = newDialog()
    optArea = optDialog.getContentArea()
  # TODO set image for dialog
  let
    bxBridges = newBox(Orientation.vertical, 3)
    btnBridge = newCheckButtonWithLabel("Use obfs4 bridge")
    btnCustomAddr = newCheckButtonWithLabel("Use custom address")
    txtAddr = newEntry()
    txtFingerPrint = newEntry()
    txtParameters = newEntry()
  
  txtAddr.setPlaceholderText("Address:Port")
  txtFingerPrint.setPlaceholderText("Fingerprint")
  txtParameters.setPlaceholderText("Parameters")

  # let
  #   boxTypes = newBox(Orientation.horizontal, 3)
  #   labelTypes = newLabel("Type")
  #   cmbTypes = newComboBoxText()
  # cmbTypes.appendText("obfs4")
  # cmbTypes.appendText("meek_lite")
  # cmbTypes.appendText("snowflake")
  # cmbTypes.setActive(0)

  # boxTypes.packStart(labelTypes, false, true, 5)
  # boxTypes.packstart(cmbTypes, false, true, 3)

  # btnBridge.connect("toggled", test)
  bxBridges.add(btnBridge)
  bxBridges.add(btnCustomAddr)
  # bxBridges.add(boxTypes)
  bxBridges.add(txtAddr)
  bxBridges.add(txtFingerPrint)
  bxBridges.add(txtParameters)

  let
    frmBridge = newFrame()

  frmBridge.setLabel("Bridge")
  frmBridge.add(bxBridges)
  optArea.add(frmBridge)
  optDialog.showAll()
# TODO apply and close button
