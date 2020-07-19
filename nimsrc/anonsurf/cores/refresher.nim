import gintro / gtk
import .. / .. / utils / [services, dnsutils]
import status
import ../ actions / actMainPage
import images

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
    # args.imgBoot.setFromIconName("security-high", 6)
    args.imgBoot.setFromPixbuf(surfImages.imgBootOn)
  else:
    args.btnBoot.label = "Enable"
    args.lblBoot.setLabel("Not Enabled at boot")
    # args.imgBoot.setFromIconName("security-low", 6)
    args.imgBoot.setFromPixbuf(surfImages.imgBootOff)
  
  # Check current status of daemon services and control ports
  if myStatus.isAnonSurfService == 1:
    args.btnRestart.setSensitive(true)
    # Check status of Tor
    if myStatus.isTorService == 1:
      args.lblServices.setText("Services: Activated")
    elif myStatus.isTorService == 0:
      args.lblServices.setText("Services: Tor is Deactivated")
    elif myStatus.isTorService == -1:
      args.lblServices.setText("Services: Tor failed to start")
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
      args.lblPorts.setText("Ports: Some ports didn't open") # Fix Me

  elif myStatus.isAnonsurfSErvice == 0:
    args.btnRestart.setSensitive(false)
    args.lblServices.setText("Services: Deactivated")
    args.lblPorts.setText("Ports: Deactivated")
  else:
    args.btnRestart.setSensitive(false)
    args.lblServices.setText("Services: AnonSurf failed to start")
    args.lblPorts.setText("Ports: Deactivated")

  # Update DNS status
  let dns = dnsStatusCheck()
  if dns == 0:
    if myPorts.isReadError:
      args.lblDns.setText("DNS: Config read failed") # Fixme
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
          # args.imgStatus.setFromIconName("security-high", 6)
          args.imgStatus.setFromPixBuf(surfImages.imgSecHigh)
          args.lDetails.setText("AnonSurf is running") # Fix me
        else:
          # args.imgStatus.setFromIconName("security-medium", 6)
          args.imgStatus.setFromPixBuf(surfImages.imgSecMed)
          args.lDetails.setText("Error with DNS port") # Fix me
      else:
        # args.imgStatus.setFromIconName("security-low", 6)
        args.imgStatus.setFromPixBuf(surfImages.imgSecLow)
        args.lDetails.setText("Error with Tor ports") # Fix me
        args.btnID.setSensitive(false)
        args.btnStatus.setSensitive(false)
    else:
      # args.imgStatus.setFromIconName("security-low", 6)
      args.imgStatus.setFromPixBuf(surfImages.imgSecLow)
      args.lDetails.setText("Tor service doesn't start") # Fix me
      args.btnID.setSensitive(false)
      args.btnStatus.setSensitive(false)
    
    args.btnRun.label = "Stop"
  else:
    if myStatus.isAnonSurfService == -1:
      args.lDetails.setText("AnonSurf start failed") # Fix me
      # args.imgStatus.setFromIconName("security-low", 6)
      args.imgStatus.setFromPixBuf(surfImages.imgSecLow)
    else:
      args.lDetails.setText("AnonSurf is not running")
      # args.imgStatus.setFromIconName("security-medium", 6)
      args.imgStatus.setFromPixBuf(surfImages.imgSecMed)
    args.btnRun.label = "Start"
    args.btnID.setSensitive(false)
    args.btnStatus.setSensitive(false)

  if worker.running:
    args.btnIP.setSensitive(false)
  else:
    args.btnIP.setSensitive(true)
