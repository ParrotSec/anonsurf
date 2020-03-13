import gintro / [gtk, glib, gobject, notify, vte]
import os
import osproc
import strutils
import net
import utils / [dnsutils, macutils]

type
  Obj = ref object
    btnRun: Button
    btnStatus: Button
    btnChange: Button
    btnSetDNS: Button

var serviceThread: system.Thread[tuple[command: string]]


proc runThread(argv: tuple[command: string]) {.thread.} =
  #[
    Create a thread to run system progress in background
    The main GUI won't be hanged
  ]#
  discard execShellCmd(argv.command)


proc anonsurfControl(b: Button) =
  #[
    Enable / disable anonsurf.
    Automatically check for task (enable or disable) by button title
  ]#
  if b.label == "Enable":
    createThread(serviceThread, runThread, ("gksu anonsurf start",))
  else:
    createThread(serviceThread, runThread, ("gksu anonsurf stop",))


proc actionCancel(b: Button, d: Dialog) =
  #[
    Destroy dialog when user click on a button
  ]#
  d.destroy()


proc actionSystemdSwitch(b: Button, l: Label) =
  #[
    Enable / disable anonsurf start at boot
    1. Automatically choose enable and disable by using button's title
    2. Check anonsurfd (daemon unit) and showing current status of anonsurfd
    # TODO show `failed to enable / disable`
  ]#
  if b.label == "Enable":
    discard execShellCmd("gksu systemctl enable anonsurfd")
  else:
    discard execShellCmd("gksu systemctl disable anonsurfd")
  
  let currentStatus = execProcess("systemctl list-unit-files | grep anonsurfd | awk '{print $2}'")
  #[
    Check REAL status of anonsurfd on the system.
    1. If output == enabled -> it is enabled
    2. If output == disabled -> it is disabled
    3. If output != [enabled, disabled] -> failed or error
    Check if task (enable, disable) failed
    1. User click on Enable and status == disabled -> failed to disable
    -> label == "Enable" and status == "disabled"
    2. User click on Disable and status == enabled -> failed to enable
    -> label == "Disable" and status == "enabled"
  ]#
  if currentStatus == "enabled\n":
    l.label = "AnonSurf on boot is actived"
    if b.label == "Disable":
      l.label = "Failed to disable anonsurf. " & l.label
    b.setLabel("Disable")
  else:
    l.label = "AnonSurf on boot is inactived"
    if b.label == "Enable":
      l.label = "Failed to enable anonsurf. " & l.label
    b.setLabel("Enable")


proc actionChange(b: Button) =
  #[
    Send change node command to Control port then restart tor service
    Host: 127.0.0.1 | localhost
    Port: 9051
    Data:
    """
      authenticate "kuhNygbtfu76fFUbgv"
      signal newnym
      quit
    """
    URL: https://stackoverflow.com/a/33726166
  ]#
  let
    sock_data = "authenticate \"kuhNygbtfu76fFUbgv\"\nsignal newnym\nquit"
  var socket = newSocket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
  socket.connect("127.0.0.1", Port(9051))

  discard notify.init("Change Tor Node")

  let noti = newNotification("Changed node succesfully")

  if socket.trySend(sock_data):
    let recvData = socket.recvLine()
    if recvData == "250 OK":
      discard execShellCmd("gksu service tor restart")
    else:
      discard noti.update("Failed to change new identify")
  else:
    discard noti.update("Can't connect to Tor control port")
  socket.close()

  discard noti.show()


proc drawDNSDialog(b: Button) =
  #[
    Draw a Dialog and
      1. Show current DNS status:
        a) AnonSurf: Tor is running and DNS is using localhost. Disable buttons
        b) Localhost: Use localhost without Tor setting
        c) Static: Doesn't apply settingss from DHCP
          - OpenNIC
          - User settings
          - Sometime settings of 1 DHCP server is saved in system. Check it (TODO)
        d) Dynamic: Use only settings from DHCP
        e) TODO check the mix of DHCP and other static settings
      2. Apply settings # TODO think about how to apply it (drop down menu?)
  ]#
  let
    dnsDialog = newDialog()
    dnsArea = dnsDialog.getContentArea()
  dnsDialog.setTitle("AnonSurf - DNS")

  let
    labelStatus = newLabel(dnsStatusCheck())
  dnsArea.packStart(labelStatus, false, true, 3)
  
  let
    btnCancel = newButton("Cancel")
  btnCancel.connect("clicked", actionCancel, dnsDialog)
  dnsArea.packStart(btnCancel, false, true, 3)

  dnsDialog.showAll

proc drawMACDialog(b: Button) =
  let
    macDialog = newDialog()
    macArea = macDialog.getContentArea()

  macDialog.setTitle("AnonSurf - Random MAC")

  let
    boxIfaceSelector = newBox(Orientation.horizontal, 3)
    labelSelect = newLabel("Network Interface")
    ifaceSelector = newComboBoxText()
    allIfaces = getValidIfaces()
  
  if len(allIfaces) > 1:
    for iface in allIfaces:
      ifaceSelector.append_text(iface)
    ifaceSelector.append_text("all")
  else:
    ifaceSelector.append_text(allIfaces[0])
    ifaceSelector.active = 0

  boxIfaceSelector.packStart(labelSelect, false, true, 3)
  boxIfaceSelector.packStart(ifaceSelector, true, true, 3)

  macArea.packStart(boxIfaceSelector, false, true, 3)

  let
    boxButton =  newBox(Orientation.horizontal, 3)
    btnRestore = newButton("Restore")
    btnRandom = newButton("Random MAC")
    btnCancel = newButton("Cancel")

  btnRestore.setSensitive(false) # TODO change it by click on the iface
  boxButton.packStart(btnRestore, false, true, 3)
  boxButton.packStart(btnRandom, false, true, 3)
  btnCancel.connect("clicked", actionCancel, macDialog)
  boxButton.packStart(btnCancel, false, true, 3)

  macArea.packStart(boxButton, false, true, 3)

  macDialog.showAll


proc actionStatus(b: Button) =
  #[
    Spawn a native GTK terminal and run nyx with it to show current tor status
  ]#
  let
    statusDialog = newDialog()
    statusArea = statusDialog.getContentArea()
    nyxTerm = newTerminal()

  nyxTerm.spawnAsync(
    {noLastlog}, # pty flags
    nil, # working directory
    ["/usr/bin/nyx"], # args
    [], # envv
    {leaveDescriptorsOpen}, # spawn flag
    nil, # Child setup
    nil, # child setup data
    nil, # chlid setup data destroy
    -1, # timeout
    nil, # cancellabel
    nil, # callback
    nil, # pointer
  )

  statusArea.packStart(nyxTerm, false, true, 3)
  statusDialog.showAll


# proc actionSetDNS(b: Button) =
#   discard execShellCmd("gksu anonsurf dns")


proc actionSetStartup(b: Button) =
  let
    bootDialog = newDialog()
    bootArea = bootDialog.getContentArea()
    labelStatus = newLabel("Boot status")
    btnArea = newBox(Orientation.horizontal, 3)
    btnClose = newButton("Close")
    btnAction = newButton("Enable AnonSurf at boot")
    currentStatus = execProcess("systemctl list-unit-files | grep anonsurfd | awk '{print $2}'")

  labelStatus.setXalign(0.0)
  bootDialog.setTitle("System Startup")

  if currentStatus == "disabled\n":
    labelStatus.label = "AnonSurf on boot is inactived"
    btnAction.setLabel("Enable")
  else:
    labelStatus.label = "AnonSurf on boot is actived\n"
    btnAction.setLabel("Disable")
  
  btnAction.connect("clicked", actionSystemdSwitch, labelStatus)
  btnClose.connect("clicked", actionCancel, bootDialog)

  btnArea.packStart(btnAction, false, true, 3)
  btnArea.packStart(btnClose, false, true, 3)

  bootArea.packStart(labelStatus, false, true, 3)
  bootArea.packStart(btnArea, false, true, 3)

  bootDialog.showAll


proc refreshStatus(args: Obj): bool =
  # TODO work with update ip label
  let
    output = execProcess("systemctl is-active anonsurfd").replace("\n", "")
    # dnsLock = "/etc/anonsurf/opennic.lock"
  
  if serviceThread.running():
    args.btnRun.label = "Switching"
    args.btnSetDNS.label = "Generating"
    args.btnChange.label = "Changing"
    args.btnRun.setSensitive(false)
    args.btnStatus.setSensitive(false)
    args.btnChange.setSensitive(false)
    args.btnSetDNS.setSensitive(false)
    
  else:
    if output == "active":
      # Settings for button anonsurf
      args.btnRun.label = "Disable"
      args.btnRun.setTooltipText("Stop identify protection")
      args.btnRun.setSensitive(true)

      args.btnStatus.label = "Check Status"
      args.btnStatus.setTooltipText("Check your current Tor connection")
      args.btnStatus.setSensitive(true)

      args.btnChange.label = "Change Tor Node"
      args.btnChange.setTooltipText("Change current Tor node")
      args.btnChange.setSensitive(true)

      args.btnSetDNS.label = "Tor DNS"
      args.btnSetDNS.setTooltipText("Using Tor DNS")
      args.btnSetDNS.setSensitive(false)

    else:
      args.btnRun.label = "Enable"
      args.btnRun.setTooltipText("Enable Anonsurf to hide your identify")
      args.btnRun.setSensitive(true)

      args.btnStatus.label = "AnonSurf Off"
      args.btnStatus.setTooltipText("You are not connecting to Tor network")
      args.btnStatus.setSensitive(false)

      args.btnChange.label = "Not connected"
      args.btnChange.setTooltipText("You are not connecting to Tor network")
      args.btnChange.setSensitive(false)

      args.btnSetDNS.setSensitive(true)
      # if existsFile(dnsLock):
      #   # OpenNic is already set. Disable it
      #   args.btnSetDNS.label = "Disable" # Todo change to shorter name
      #   args.btnSetDNS.setTooltipText("Start using OpenNIC DNS")
      # else:
      #   # OpenNic is not set. Enable it
      #   args.btnSetDNS.label = "Enable"
      #   args.btnSetDNS.setTooltipText("Stop using OpenNIC DNS")

  return SOURCE_CONTINUE


proc createArea(boxMain: Box) =
  #[
    Generate area to control anonsurf with:
      Enable / disable anonsurf service button
      Check current status and monitor status
      Change exists Node
      # TODO restart button or forget about it
  ]#
  let
    boxAnonsurf = newBox(Orientation.horizontal, 3) # The whole box

  #[
    Draw the anonsurf section.
    It has
    1. Title
    2. Label of buttons
    3. Buttons
    4. The big button System startup
  ]#

  # Create Main label for anonsurf section and add it to main section
  let
    labelAnonsurf = newLabel("AnonSurf")
  boxMain.packStart(labelAnonsurf, false, true, 3)
  
  #[
    Create a vertical boxes to have
    1. label of the button
    2. button
  ]#

  # Add section run to anonsurf section
  let
    boxRun = newBox(Orientation.vertical, 3) # The box to generate Run button and its label
    labelRun = newLabel("Service")
    btnRunAnon = newButton("Start AnonSurf")

  # init label, button
  labelRun.setXalign(0.0)
  btnRunAnon.connect("clicked", anonsurfControl)

  # Add label and button to box run
  boxRun.packStart(labelRun, false, true, 3)
  boxRun.packStart(btnRunAnon, false, true, 3)
  # Add box Run to anonsurf section
  boxAnonsurf.packstart(boxRun, false, true, 3)

  # Add section Status to anonsurf section
  let
    btnCheckStatus = newButton("Check Status")
    labelStatus = newLabel("Status")
    boxStatus = newBox(Orientation.vertical, 3) # The box to generate Check status button and its label

  # init label and button
  labelStatus.setXalign(0.0)
  btnCheckStatus.connect("clicked", actionStatus)
  # Add them to box
  boxStatus.packStart(labelStatus, false, true, 3)
  boxStatus.packStart(btnCheckStatus, false, true,3)
  # Add the box to anonsurf section
  boxAnonsurf.packstart(boxStatus, false, true, 3)

  # Add Change Node to Anosnurf section
  let
    btnChangeID = newButton("Change ID")
    labelChange = newLabel("Change Node")
    boxChange = newBox(Orientation.vertical, 3) # The box to generate Change current node button and its label
  
  # Init label and button
  labelChange.setXalign(0.0)
  btnChangeID.connect("clicked", actionChange)
  # Add label and button to the box
  boxChange.packStart(labelChange, false, true, 3)
  boxChange.packStart(btnChangeID, false, true ,3)
  # Add the box to the anonsurf box
  boxAnonsurf.packstart(boxChange, false, true, 3)
  
  # Add the Anonsurf section to Main section
  boxMain.packStart(boxAnonsurf, false, true, 3)

  #[
    Add "Startup button" to main
  ]#
  let
    btnAtBoot = newButton("System Startup")

  btnAtBoot.connect("clicked", actionSetStartup)
  boxMain.packStart(btnAtBoot, false,  true, 3)

  #[
    Create boxExtra for OpenNIC, McChanger and other feature in future
  ]#
  let
    boxExtra = newBox(Orientation.horizontal, 3)
    labelExtra = newLabel("Extra") # TODO edit here
  labelExtra.setXalign(0.0)
  boxMain.packStart(labelExtra, false, true, 3)

  #[
    Create box DNS for OpenNIC service
  ]#
  let
    # boxDNS = newBox(Orientation.vertical, 3) # Create a box for DNS area
    # labelDNS = newLabel("OpenNIC DNS")
    btnDNS = newButton("DNS Manager")

  # init label and button
  # labelDNS.setXalign(0.0)
  btnDNS.connect("clicked", drawDNSDialog)
  # Add label and button to box DNS
  # boxDNS.packStart(labelDNS, false, true, 3)
  # boxDNS.packStart(btnDNS, false, true, 3)
  # Add box DNS to Extra section
  # boxExtra.packStart(boxDNS, false, true, 3)
  boxExtra.packStart(btnDNS, false, true, 3)
  
  let
    # boxMacChanger = newBox(Orientation.vertical, 3)
    # labelMacChanger = newLabel("MAC Changer")
    btnMacChange = newButton("MAC Changer")

  # init label and button
  # labelMacChanger.setXalign(0.0)
  btnMacChange.connect("clicked", drawMACDialog)
  # Add label and button to box Mac Change
  # boxMacChanger.packstart(labelMacChanger, false, true, 3)
  # boxMacChanger.packStart(btnMacChange, false, true, 3)

  # boxExtra.packStart(boxMacChanger, false, true, 3)

  boxExtra.packStart(btnMacChange, false, true, 3)

  # Add box Extra  to main section
  boxMain.packStart(boxExtra, false, true, 3)

  var args = Obj(btnRun: btnRunAnon, btnStatus: btnCheckStatus, btnChange: btnChangeID, btnSetDNS: btnDNS)
  discard timeoutAdd(200, refreshStatus, args)


proc stop(w: Window) =
  mainQuit()

proc main =
  gtk.init()
  let
    mainBoard = newWindow()
    boxMain = newBox(Orientation.vertical, 3)
  
  mainBoard.title = "AnonSurf GUI"

  createArea(boxMain)

  mainBoard.add(boxMain)
  mainBoard.setBorderWidth(3)

  mainBoard.showAll
  mainBoard.connect("destroy", stop)
  gtk.main()

main()
