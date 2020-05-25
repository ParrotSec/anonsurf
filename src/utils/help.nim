import gintro / [gtk]

proc onClickMainHelp*(b: Button) =
  #[
    Show help for main and credit in new dialog
  ]#
  let
    mainDialog = newDialog()
    area = mainDialog.getContentArea()
  
  mainDialog.setTitle("Help")

  let
    helpStack = newStack()
    helpStackSwitcher = newStackSwitcher()

  helpStackSwitcher.setStack(helpStack)
  
  let
    boxWhatIsAnonSurf = newBox(Orientation.vertical, 3)
    labelTest = newLabel("This is test label for help of AnonSurf")

  boxWhatIsAnonSurf.add(labelTest)

  helpStack.addTitled(boxWhatIsAnonSurf, "anonsurf", "AnonSurf")

  area.add(helpStack)
  area.add(helpStackSwitcher)

  let
    boxCredit = newBox(Orientation.vertical, 3)
    labelTestCredit = newLabel("All authors of anonsurf and all URL")
  
  boxCredit.add(labelTestCredit)
  helpStack.addTitled(boxCredit, "credit", "Credit")
  mainDialog.showAll()


proc onClickAnonHelp*(b: Button) =
  #[
    Show help about AnonSurf in new dialog
    1. How to use
    2. Explain
  ]#
  discard