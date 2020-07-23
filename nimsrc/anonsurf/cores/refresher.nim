import gintro / gtk
import .. / .. / utils / dnsutils
import status
import .. / actions / actMainPage
import images
import .. / displays / noti
import strutils

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


proc updateDetail*(args: DetailObjs, myStatus: Status) =
  args.btnRestart.label = "Restart"
  # AnonSurf is Enabled at boot
  if myStatus.isAnonSurfBoot:
    args.btnBoot.label = "Disable"
    args.lblBoot.setLabel("Enabled at boot")
    # args.imgBoot.setFromIconName("security-high", 6)
    args.imgBoot.setFromPixbuf(surfImages.imgBootOn)
  else:
    args.btnBoot.label = "Enable"
    args.lblBoot.setLabel("Not enabled at boot")
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
    let myPorts = getStatusPorts()
    if myPorts.isReadError:
      args.lblPorts.setText("Ports: Parse torrc failed")
    else:
      var
        onErrPorts: seq[string]
        szErr = 0
      if not myPorts.isControlPort:
        onErrPorts.add("Control")
        szErr += 1
      if not myPorts.isSocksPort:
        onErrPorts.add("Socks")
        szErr += 1
      if not myPorts.isTransPort:
        onErrPorts.add("Trans")
        szErr += 1
    
      if szErr == 0:
        args.lblPorts.setText("Ports: Activated")
      elif szErr == 3:
        args.lblPorts.setText("Ports: All port are not open")
      elif szErr == 2:
        args.lblPorts.setText("Ports: Error on " & join(onErrPorts, ", "))
      else:
        args.lblPorts.setText("Ports: Error on " & onErrPorts[0])

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
    let myPorts = getStatusPorts()
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


proc updateMain*(args: MainObjs, myStatus: Status) =
  #[
    Always check status of current widget
      to show correct state of buttons
  ]#
  if myStatus.isAnonSurfService == 1:
    # Check status of tor service
    if myStatus.isTorService == 1:
      let myPorts = getStatusPorts()
      # If everything (except DNS port) is okay
      if myPorts.isControlPort and myPorts.isSocksPort and myPorts.isTransPort and
        not myPorts.isReadError:
        args.btnID.setSensitive(true)
        args.btnStatus.setSensitive(true)
        # Check DNS
        if myPorts.isDNSPort:
          # args.imgStatus.setFromIconName("security-high", 6)
          args.imgStatus.setFromPixBuf(surfImages.imgSecHigh)
          args.lDetails.setText("AnonSurf is running")
        else:
          # args.imgStatus.setFromIconName("security-medium", 6)
          args.imgStatus.setFromPixBuf(surfImages.imgSecMed)
          args.lDetails.setText("Error with DNS port")
      else:
        # args.imgStatus.setFromIconName("security-low", 6)
        args.imgStatus.setFromPixBuf(surfImages.imgSecLow)
        args.lDetails.setText("Error with Tor ports")
        args.btnID.setSensitive(false)
        args.btnStatus.setSensitive(false)
    else:
      # args.imgStatus.setFromIconName("security-low", 6)
      args.imgStatus.setFromPixBuf(surfImages.imgSecLow)
      args.lDetails.setText("Tor service doesn't start")
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
    let finalAddr = channel.tryRecv()
    if finalAddr.dataAvailable:
      # channel.close()
      worker.joinThread()
      sendNotify($finalAddr.msg.thisAddr, $finalAddr.msg.isUnderTor, $finalAddr.msg.iconName)
    args.btnIP.setSensitive(true)
