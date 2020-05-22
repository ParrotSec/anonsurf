import gintro / [gtk, glib, gobject]#, notify, vte]
import utils / status


proc onClickDashboard(b: Button, s: Stack) =
  #[
    init action for back button and button in Dashboard
  ]#
  if b.label == "Back":
    s.setVisibleChildName("main")
  else:
    if b.label == "AnonSurf":
      s.setVisibleChildName("anonsurf")
    elif b.label == "Set Boot":
      s.setVisibleChildName("boot")
    elif b.label == "More Tools":
      s.setVisibleChildName("tools")
    elif b.label == "Details":
      s.setVisibleChildName("details")


proc onClickExit(b: Button) =
  mainQuit()


proc onClickMainHelp(b: Button) =
  #[
    Show help for main and credit in new dialog
  ]#
  discard


proc onClickAnonHelp(b: Button) =
  #[
    Show help about AnonSurf in new dialog
    1. How to use
    2. Explain
  ]#
  discard

proc refreshStatus(): bool =
  #[
    Update current status everytime
  ]#
  let
    basicStatus = getSurfStatus()
  return SOURCE_CONTINUE


proc createArea(boxMainWindow: Box) =
  #[
    Create a Kaspersky-like UI or XFCE4 control Pannel like UI
    When we click on a Button, main widget changes to button's display
    Use the Button name (TODO change button object) as same as child name
  ]#
  let
    #[
      Box dashboard is the main object when we open new AnonSurf.
      It should have:
        1. First row: Status of current AnonSurf
        2. Second row: All buttons to switch to other widgets / pages
    ]#
    boxDashboard = newBox(Orientation.vertical, 3)
    #[
      Main stack is the "page manager" for our job
      It manages all page as child object
    ]#
    mainStack = newstack()

  #[  Draw first row
  First column: Icon of AnonSurf. Color as current status
    1. Error: Red
    2. Not connected: yellow
    3. Connected, no error: green
  Second column:
    Show current status of AnonSurf fast status like actived / inactived
    Show details button
  Detail:
    When we click on it, it will show something like:
      Tor: is actived
      AnonSurf: is actived
      DNS under tor
      Nyx in vte terminal
      A button that can change id
      Check IP
  ]#
  let
    # TODO Use icon here
    boxStatus = newBox(Orientation.horizontal, 3)
    boxStatusIcon = newBox(Orientation.vertical, 3)
    boxStatusDetails = newBox(Orientation.vertical, 3)
    labelStatus = newLabel("Your connection isn't protected")
    btnDetails = newButton("Details")
    # statusImage = newImageFromFile("/home/dmknght/Parrot_Projects/anonsurf/icons/50px/Anonsurf_Nobg.png")
    # statusImage = newImageFromFile("/home/dmknght/Parrot_Projects/anonsurf/icons/Anonsurf_Logo_by_Serverket.png")
    # statusBackground = newImageFromFile("/home/dmknght/Parrot_Projects/anonsurf/icons/background_warn.png")

  boxStatus.setSizeRequest(300, 70)
  boxStatusDetails.add(labelStatus)
  # boxStatus.

  # btnDetails.connect("clicked", showCurrentDetails)
  boxStatusDetails.add(btnDetails)

  # boxStatusIcon.add(statusImage)

  boxStatus.packStart(boxStatusIcon, false, true, 3)
  boxStatus.packEnd(boxStatusDetails, false, true, 3)
  
  boxDashboard.add(boxStatus)

  #[
    Draw the second row
    It has button: AnonSurf, Boot, Extra.
    Each button uses to switch from main widget (dashboard) to its widget
  ]#
  let
    btnAnon = newButton("AnonSurf")
    btnBoot = newButton("Set Boot")
    btnExtra = newButton("More Tools")
    boxMainButtons = newBox(Orientation.horizontal, 3)

  btnAnon.connect("clicked", onClickDashboard, mainStack)
  btnAnon.setSizeRequest(80, 80)
  boxMainButtons.packStart(btnAnon, false, true, 3)

  btnBoot.connect("clicked", onClickDashboard, mainStack)
  btnBoot.setSizeRequest(80, 80)
  boxMainButtons.add(btnBoot)

  btnExtra.connect("clicked", onClickDashboard, mainStack)
  btnExtra.setSizeRequest(80, 80)
  boxMainButtons.packEnd(btnExtra, false, true, 3)
  boxMainButtons.show()
  boxDashboard.add(boxMainButtons)

  let
    boxBottomButtons = newBox(Orientation.horizontal, 3)
    btnMainHelp = newButton("Help")
    btnExit = newButton("Exit")

  btnExit.connect("clicked", onClickExit)
  boxBottomButtons.packStart(btnExit, false, true, 3)
  boxBottomButtons.packEnd(btnMainHelp, false, true, 3)

  boxDashboard.packEnd(boxBottomButtons, false, true, 3)


  ## End of draw second row
  boxDashboard.showAll()
  mainStack.addNamed(boxDashboard, "main")
  # End of draw dashboard

  #[
    Draw AnonSurf board
    This board is used to use main AnonSurf procedures
    It has start / start bridge / stop / restart
  ]#
  let
    btnStart = newButton("Start")
    btnStartBridge = newButton("Start Bridge")
    labelAnonStart = newLabel("Start Normal")
    labelAnonStartBridge = newLabel("Start with Obfs4 Bridge")
    boxAnonStart = newBox(Orientation.vertical, 3)
    boxAnonStartBridge = newBox(Orientation.vertical, 3)

  boxAnonStart.add(labelAnonStart)
  boxAnonStart.add(btnStart)

  boxAnonStartBridge.add(labelAnonStartBridge)
  boxAnonStartBridge.add(btnStartBridge)
  
  let
    boxAnonStartArea = newBox(Orientation.horizontal, 3)
  boxAnonStartArea.add(boxAnonStart)
  boxAnonStartArea.packEnd(boxAnonStartBridge, false, true, 3)

  let
    btnStop = newButton("Stop")
    labelStop = newLabel("Stop AnonSurf")
    boxAnonStop = newBox(Orientation.vertical, 3)
  
  boxAnonStop.add(labelStop)
  boxAnonStop.add(btnStop)

  let
    boxAnonBottomButtons = newBox(Orientation.horizontal, 3)
    btnAnonBack = newButton("Back")
    btnAnonHelp = newButton("Help")
  
  btnAnonBack.connect("clicked", onClickDashboard, mainStack)
  boxAnonBottomButtons.packStart(btnAnonBack, false, true, 3)
  boxAnonBottomButtons.packEnd(btnAnonHelp, false, true, 3)

  let
    boxAnonArea = newBox(Orientation.vertical, 3)

  boxAnonArea.add(boxAnonStartArea)
  boxAnonArea.add(boxAnonStop)
  boxAnonArea.packEnd(boxAnonBottomButtons, false, true, 3)

  boxAnonArea.show()
  
  mainStack.addNamed(boxAnonArea, "anonsurf")
  # End of AnonSurf board
  
  #[
    Draw Boot option board
    The label will be updated by using refresh
    btnBoot will be changed by current boot status
  ]#
  let
    boxBoot = newBox(Orientation.vertical, 3)
    labelBootStatus = newLabel("disabled")
    btnBootSwitch = newButton("Enable")
    btnBootBack = newButton("Back")

  boxBoot.add(labelBootStatus)
  boxBoot.add(btnBootSwitch)
  btnBootBack.connect("clicked", onClickDashboard, mainStack)
  boxBoot.add(btnBootBack)
  boxBoot.show()

  mainStack.addNamed(boxBoot, "boot")
  # End of boot dashboard

  #[
      Draw Extra option dashboard
      It will have DNS tool in GUI and MAC changer
  ]#
  let
    boxExtra = newBox(Orientation.vertical, 3)
    btnDNS = newButton("dns")
    # btnMAC = newButton("mac")
    btnToolsBack = newButton("Back")

  boxExtra.add(btnDNS)
  # boxExtra.add(btnMAC)
  btnToolsBack.connect("clicked", onClickDashboard, mainStack)
  boxExtra.add(btnToolsBack)
  boxExtra.show()

  mainStack.addNamed(boxExtra, "tools")
  # End of extra dashboard

  #[
    Show a new dialog about all details
    Services:
      Tor: is actived
      AnonSurf: is actived
    DNS:
      DNS under tor
    Buttons:
      A button that can change id
      Check IP
    Monitor:
      Nyx in vte terminal - click button
  ]#
  #[
    Box 1: vertical: AnonSurf, Tor, DNS details
    Box 2: Horizontal: Buttons: changeID, checkIP
  ]#

  #[
    Add status
  ]#
  let
    boxStatusServices = newBox(Orientation.vertical, 3)
    labelAnonStatus = newLabel("AnonSurf: Not running")
    labelTor = newLabel("Tor: Not running")
    labelDNS = newLabel("DNS: DNS status")

  boxStatusServices.add(labelAnonStatus)
  boxStatusServices.add(labelTor)
  boxStatusServices.add(labelDNS)

  #[
    Add buttons
  ]#
  let
    boxStatusButtons = newBox(Orientation.horizontal, 3)
    btnChangeID = newButton("Change ID")
    btnCheckIP = newButton("Check IP")
    btnDetailsBack = newButton("Back")
    
  btnDetails.connect("clicked", onClickDashboard, mainStack)
  boxStatusButtons.add(btnDetailsBack)
  boxStatusButtons.add(btnChangeID)
  boxStatusButtons.add(btnCheckIP)

  let
    boxDetails = newBox(Orientation.vertical, 3)

  boxDetails.add(boxStatusServices)
  boxDetails.add(boxStatusButtons)

  boxDetails.showAll()
  
  btnDetailsBack.connect("clicked", onClickDashboard, mainStack)

  mainStack.addNamed(boxDetails, "details")

  # End of full details dashboard
  
  # Add everything to window
  boxMainWindow.add(mainStack)
  boxMainWindow.showAll()


proc stop(w: Window) =
  mainQuit()

proc main =
  #[
    Create new window
  ]#
  gtk.init()
  let
    mainBoard = newWindow()
    boxMainWindow = newBox(Orientation.vertical, 3)
  
  mainBoard.title = "AnonSurf GUI"
  discard mainBoard.setIconFromFile("/usr/share/icons/anonsurf.png")

  createArea(boxMainWindow)

  mainBoard.add(boxMainWindow)
  mainBoard.setBorderWidth(3)

  mainBoard.show()
  mainBoard.connect("destroy", stop)
  gtk.main()

main()
