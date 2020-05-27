import gintro / [gtk, glib, gobject]#, notify, vte]
import utils / [status, dnsutils, help]

type
  rObject = ref object
    rLabelFastStatus: Label
    rLabelAnonStatus: Label
    rLabelTorStatus: Label
    rLabelDNSStatus: Label
    rLabelStatusBoot: Label
    rImgStatus: Image
    rBtnNyx: Button
    rBtnStart: Button
    rBtnStartBridge: Button
    rBtnStop: Button
    rBtnRestart: Button
    rBtnChangeID: Button
    rBtnSetBoot: Button

const # TODO change icon path here
  imageFailed = "/home/dmknght/Parrot_Projects/anonsurf/icons/50px/anon_50px_failed.png"
  imageUnprotected = "/home/dmknght/Parrot_Projects/anonsurf/icons/50px/anon_50px_unprotected.png"
  imageProtected = "/home/dmknght/Parrot_Projects/anonsurf/icons/50px/anon_50px_protected.png"


proc onClickDashboard(b: Button, s: Stack) =
  #[
    init action for back button and button in Dashboard
  ]#
  if b.label == "Back" or b.label == "":
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


proc refreshStatus(args: rObject): bool =
  #[
    Update current status everytime
  ]#
  let
    basicStatus = getSurfStatus()
    dnsStatus = dnsStatusCheck()
  
  case dnsStatus
  of 0:
    args.rLabelDNSStatus.text = "Under Tor Tunnel"
  of -1:
    args.rLabelDNSStatus.text = "Localhost (error)"
  of -2:
    args.rLabelDNSStatus.text = "/etc/resolv.conf not found"
  of -3:
    args.rLabelDNSStatus.text = "/etc/resolv.conf is empty"
  of 11:
    args.rLabelDNSStatus.text = "Static: OpenNIC DNS"
  of 12:
    args.rLabelDNSStatus.text = "Static: custom DNS"
  of 13:
    args.rLabelDNSStatus.text = "Static: OpenNIC + Custom DNS"
  of 20:
    args.rLabelDNSStatus.text = "Dynamic: DHCP"
  of 21:
    args.rLabelDNSStatus.text = "Dynamic: DHCP with OpenNIC DNS"
  of 22:
    args.rLabelDNSStatus.text = "Dynamic: DHCP with Custom DNS"
  of 23:
    args.rLabelDNSStatus.text = "Dynamic: DHCP with OpenNIC + Custom DNS"
  else:
    discard

  #[
    Update boot's status by the label
  ]#
  if basicStatus.isAnonSurfBoot:
    args.rLabelStatusBoot.text = "It is enabled"
    args.rBtnSetBoot.setLabel("Disable")
  else:
    args.rLabelStatusBoot.text = "It is not enabled"
    args.rBtnSetBoot.setLabel("Enable")

  #[
    Update Tor's status by the label
  ]#
  case basicStatus.isTorService
  of 1: # Tor is running
    args.rLabelTorStatus.text = "Tor is running"
  of 0: # Tor is not running
    args.rLabelTorStatus.text = "Tor is not running"
  else: # Tor failed to run
    args.rLabelTorStatus.text = "Tor start failed (error)"

  #[
    Update other labels and buttons base on AnonSurf status
  ]#
  case basicStatus.isAnonSurfService
  of 1: # AnonSurf is running
    # Show status of labels
    args.rLabelAnonStatus.text = "AnonSurf is running"
    # Disable buttons that can start AnonSurf
    args.rBtnStart.setSensitive(false)
    args.rBtnStartBridge.setSensitive(false)
    # Enable buttons that can change AnonSurf running state
    args.rBtnRestart.setSensitive(true)
    args.rBtnStop.setSensitive(true)
    args.rBtnChangeID.setSensitive(true)
    # Enable nyx to check AnonSurf status
    args.rBtnNyx.setSensitive(true)
    # Check fast status
    if basicStatus.isTorService == 1:
      args.rImgStatus.setFromFile(imageProtected)
      args.rLabelFastStatus.text = "AnonSurf is running"
    elif basicStatus.isTorService == 0:
      args.rImgStatus.setFromFile(imageFailed)
      args.rLabelFastStatus.text = "AnonSurf is running but Tor isn't"
    else:
      args.rImgStatus.setFromFile(imageFailed)
      args.rLabelFastStatus.text = "AnonSurf is running but Tor failed"
  of 0: # AnonSurf is not running
    # Update image
    args.rImgStatus.setFromFile(imageUnprotected)
    # Show status of label
    args.rLabelAnonStatus.text = "AnonSurf is not running"
    # Enable buttons that can start AnonSurf
    args.rBtnStart.setSensitive(true)
    args.rBtnStartBridge.setSensitive(true)
    # Disable buttons that can change AnonSurf running state
    args.rBtnRestart.setSensitive(false)
    args.rBtnStop.setSensitive(false)
    args.rBtnChangeID.setSensitive(false)
    # Disable nyx button
    args.rBtnNyx.setSensitive(false)
    # Update fast status
    args.rLabelFastStatus.text = "AnonSurf is not running"
  else:
    # Update image
    args.rImgStatus.setFromFile(imageFailed)
    # Show status of label
    args.rLabelAnonStatus.text = "AnonSurf failed to run (error)"
    # Disable buttons can start AnonSurf
    args.rBtnStart.setSensitive(false)
    args.rBtnStartBridge.setSensitive(false)
    # Disable restart button because it is having error
    args.rBtnRestart.setSensitive(false)
    args.rBtnChangeID.setSensitive(false)
    # Enable stop button
    args.rBtnStop.setSensitive(true)
    # Disable nyx button
    args.rBtnNyx.setSensitive(false)
    # Update fast status
    args.rLabelFastStatus.text = "AnonSurf failed to run"

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

  boxStatus.setSizeRequest(300, 70)
  boxStatusDetails.add(labelStatus)
  # boxStatus.

  boxStatusDetails.add(btnDetails)

  let # TODO change icon path here
    imgStatus = newImageFromFile(imageUnprotected)

  boxStatusIcon.add(imgStatus)

  boxStatus.packStart(boxStatusIcon, true, true, 3)
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
    imgMainHelp = newImageFromIconName("help-about", 3)
    imgMainExit = newImageFromIconName("exit", 3)

  btnExit.connect("clicked", onClickExit)
  btnExit.setImage(imgMainExit)
  boxBottomButtons.packStart(btnExit, false, true, 3)
  btnMainHelp.connect("clicked", onClickMainHelp)
  btnMainHelp.setImage(imgMainHelp)
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
    btnRestart = newButton("Restart")
    labelRestart = newLabel("Restart AnonSurf")
    boxAnonRestart = newBox(Orientation.vertical, 3)
    
  boxAnonRestart.add(labelRestart)
  boxAnonRestart.add(btnRestart)

  let
    btnStop = newButton("Stop")
    labelStop = newLabel("Stop AnonSurf")
    boxAnonStop = newBox(Orientation.vertical, 3)

  boxAnonStop.add(labelStop)
  boxAnonStop.add(btnStop)

  let
    boxAnonBottomButtons = newBox(Orientation.horizontal, 3)
    btnAnonBack = newButton("")
    btnAnonHelp = newButton("Help")
    imgAnonHelp = newImageFromIconName("help-about", 3)
    imgAnonBack = newImageFromIconName("back", 3)
  
  btnAnonBack.connect("clicked", onClickDashboard, mainStack)
  btnAnonBack.setImage(imgAnonBack)
  btnAnonHelp.setImage(imgAnonHelp)
  boxAnonBottomButtons.packStart(btnAnonBack, false, true, 3)
  boxAnonBottomButtons.packEnd(btnAnonHelp, false, true, 3)

  let
    boxAnonArea = newBox(Orientation.vertical, 3)

  boxAnonArea.add(boxAnonStartArea)
  boxAnonArea.add(boxAnonRestart)
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
    labelTorStatus = newLabel("Tor: Not running")
    labelDNSStatus = newLabel("DNS: DNS status")

  boxStatusServices.add(labelAnonStatus)
  boxStatusServices.add(labelTorStatus)
  boxStatusServices.add(labelDNSStatus)

  #[
    Add buttons
  ]#
  let
    boxStatusButtons = newBox(Orientation.horizontal, 3)
    btnChangeID = newButton("Change ID")
    btnCheckIP = newButton("Check IP")
    btnNyx = newButton("Nyx")

  btnDetails.connect("clicked", onClickDashboard, mainStack)
  
  boxStatusButtons.add(btnChangeID)
  boxStatusButtons.add(btnCheckIP)
  boxStatusButtons.add(btnNyx)

  let
    boxDetailsBottomButtons  = newBox(Orientation.horizontal, 3)
    btnDetailsBack = newButton("")
    imgDetailsBack = newImageFromIconName("back", 3)

  btnDetailsBack.connect("clicked", onClickDashboard, mainStack)
  btnDetailsBack.setImage(imgDetailsBack)
  boxDetailsBottomButtons.add(btnDetailsBack)

  let
    boxDetails = newBox(Orientation.vertical, 3)

  boxDetails.add(boxStatusServices)
  boxDetails.add(boxStatusButtons)
  boxDetails.packEnd(boxDetailsBottomButtons, false, true, 3)

  boxDetails.showAll()
  
  mainStack.addNamed(boxDetails, "details")

  # End of full details dashboard

  var
    refreshObjs: rObject

  refreshObjs = rObject(
    rLabelFastStatus: labelStatus,
    rLabelAnonStatus: labelAnonStatus,
    rLabelTorStatus: labelTorStatus,
    rLabelDNSStatus: labelDNSStatus,
    rLabelStatusBoot: labelBootStatus,
    rImgStatus: imgStatus,
    rBtnNyx: btnNyx, 
    rBtnStart: btnStart,
    rBtnStartBridge: btnStartBridge,
    rBtnStop: btnStop,
    rBtnRestart: btnRestart,
    rBtnChangeID: btnChangeID,
    rBtnSetBoot: btnBootSwitch,
  )

  discard timeoutAdd(200, refreshStatus, refreshObjs)
  
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
