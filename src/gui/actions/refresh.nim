import gintro / gtk
import .. / .. / utils / [status, dnsutils]

type
  MainObjs* = ref object
    btnRun*: Button
    btnID*: Button
    btnDetail*: Button
    btnStatus*: Button
    lDetails*: Label
    imgStatus*: Image
  DetailObjs* = ref object
    lblServices*: Label
    lblPorts*: Label
    lblDns*: Label
    lblBoot*: Label
    btnBoot*: Button
    btnRestart*: Button
    imgBoot*: Image


proc updateDetail*(args: DetailObjs, myStatus: Status, myPorts: PortStatus) =
  args.btnRestart.label = "Restart"
  # AnonSurf is Enabled at boot
  if myStatus.isAnonSurfBoot:
    args.btnBoot.label = "Disable"
    args.lblBoot.setLabel("Enabled at boot")
    args.imgBoot.setFromIconName("security-high", 6)
  else:
    args.btnBoot.label = "Enable"
    args.lblBoot.setLabel("Not Enabled at boot")
    args.imgBoot.setFromIconName("security-low", 6)
  
  # Check current status of daemon services and control ports
  if myStatus.isAnonSurfService == 1:
    args.btnRestart.setSensitive(true)
    # Check status of Tor
    if myStatus.isTorService == 1:
      args.lblServices.setText("Services: Activated")
    elif myStatus.isTorService == 0:
      args.lblServices.setText("Services: Tor is Inactivated")
    elif myStatus.isTorService == -1:
      args.lblServices.setText("Services: Start Tor failed")
    # Check status of Port
    # var failedPort = ""
    if myPorts.isReadError:
      args.lblPorts.setText("Ports: Parse torrc failed")
    elif not myPorts.isControlPort and not myPorts.isSocksPort and
      not myPorts.isTransPort:
      if not myPorts.isDNSPort:
        args.lblPorts.setText("Ports: Doesn't open") # FIXME
      else:
        args.lblPorts.setText("Ports: Tor Ports failed") # FIXME
    elif myPorts.isControlPort and myPorts.isTransPort and
      myPorts.isSocksPort and myPorts.isDNSPort:
        args.lblPorts.setText("Ports: Activated")
    else:
      discard # TODO do analysis here
    
  elif myStatus.isAnonsurfSErvice == 0:
    args.btnRestart.setSensitive(false)
    args.lblServices.setText("Services: Inactivated")
    args.lblPorts.setText("Ports: Inactivated")
  else:
    args.btnRestart.setSensitive(false)
    args.lblServices.setText("Services: Start AnonSurf failed")
    args.lblPorts.setText("Ports: Inactivated")

  # Update DNS status
  let dns = dnsStatusCheck()
  if dns == 0:
    args.lblDns.setText("DNS: Tor") # FIXME
  elif dns == 1:
    args.lblDns.setText("DNS: LocalHost")
  elif dns == -2:
    args.lblDns.setText("DNS: resolv.conf not found")
  elif dns == -3:
    args.lblDns.setText("DNS: resolv.conf is empty")
  elif dns == 21 or dns == 11:
    args.lblDns.setText("DNS: OpenNIC server")
  else:
    args.lblDns.setText("DNS: Custom setting")


proc updateMain*(args: MainObjs, myStatus: Status, myPorts: PortStatus) =
  #[
    Always check status of current widget
      to show correct state of buttons
  ]#
  # TODO complex analysis for AnonSurf status and image
  if myStatus.isAnonSurfService == 1:
    args.btnRun.label = "Stop"
    args.btnID.setSensitive(true)
    # args.btnDetail.label= "AnonSurf is running"
    args.lDetails.setText("AnonSurf is running")
    args.btnStatus.setSensitive(true)
    args.imgStatus.setFromIconName("security-high", 6) # TODO check actual status
  else:
    args.btnRun.label = "Start"
    args.btnID.setSensitive(false)
    # args.btnDetail.label= "AnonSurf is not running"
    args.lDetails.setText("AnonSurf is not running")
    args.btnStatus.setSensitive(false)
    args.imgStatus.setFromIconName("security-medium", 6) # TODO check actual status
