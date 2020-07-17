import gintro / gtk
import .. / .. / utils / [status, dnsutils]
import toolbar

type
  MainObjs* = ref object
    btnRun*: Button
    btnID*: Button
    btnDetail*: Button
    btnStatus*: Button
    btnIP*: Button
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
    if myPorts.isReadError:
      args.lblPorts.setText("Ports: Parse torrc failed")
    elif not myPorts.isControlPort and not myPorts.isSocksPort and
      not myPorts.isTransPort:
      args.lblPorts.setText("Ports: Tor Ports failed") # FIXME
    elif myPorts.isControlPort and myPorts.isTransPort and
      myPorts.isSocksPort:
        args.lblPorts.setText("Ports: Activated")
    else:
      # TODO complex check here
      args.lblPorts.setText("Ports: Some port are not opened") # Fix Me

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
    if myPorts.isReadError:
      args.lblDns.setText("DNS: Read config failed") # Fixme
    elif myPorts.isDNSPort:
      args.lblDns.setText("DNS: Tor") # FIXME
    else:
      args.lblDns.setText("DNS: Port failed") # FIX ME
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
  if myStatus.isAnonSurfService == 1:
    # Check status of tor service
    if myStatus.isTorService == 1:
      # If everything (except DNS port) is okay
      if myPorts.isControlPort and myPorts.isSocksPort and myPorts.isTransPort and
        not myPorts.isReadError:
        args.btnID.setSensitive(true)
        args.btnStatus.setSensitive(true)
        # Check DNS
        if myPorts.isDNSPort:
          args.imgStatus.setFromIconName("security-high", 6)
          args.lDetails.setText("AnonSurf is running") # Fix me
        else:
          args.imgStatus.setFromIconName("security-medium", 6)
          args.lDetails.setText("Error with DNS port") # Fix me
      else:
        args.imgStatus.setFromIconName("security-low", 6)
        args.lDetails.setText("Error with tor ports") # Fix me
        args.btnID.setSensitive(false)
        args.btnStatus.setSensitive(false)
    else:
      args.imgStatus.setFromIconName("security-low", 6)
      args.lDetails.setText("Tor service doesn't start") # Fix me
      args.btnID.setSensitive(false)
      args.btnStatus.setSensitive(false)
    
    args.btnRun.label = "Stop"
  else:
    if myStatus.isAnonSurfService == -1:
      args.lDetails.setText("Start AnonSurf failed") # Fix me
      args.imgStatus.setFromIconName("security-low", 6)
    else:
      args.lDetails.setText("AnonSurf is not running")
      args.imgStatus.setFromIconName("security-medium", 6)
    args.btnRun.label = "Start"
    args.btnID.setSensitive(false)
    args.btnStatus.setSensitive(false)

  if worker.running:
    args.btnIP.setSensitive(false)
  else:
    args.btnIP.setSensitive(true)
