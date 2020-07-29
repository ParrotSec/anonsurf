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
    btnRestart*: Button
  DetailObjs* = ref object
    lblServices*: Label
    lblPorts*: Label
    lblDns*: Label
    lblBoot*: Label
    btnBoot*: Button
    imgBoot*: Image


proc updateDetail*(args: DetailObjs, myStatus: Status) =
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
    # Check status of Tor
    if myStatus.isTorService == 1:
      args.lblServices.setMarkup("Servc:  <b>Activated</b>")
    elif myStatus.isTorService == 0:
      args.lblServices.setMarkup("Servc:  <b>Tor is not running</b>")
    elif myStatus.isTorService == -1:
      args.lblServices.setMarkup("Servc:  <b>Tor failed to start</b>")
    # Check status of Port
    let myPorts = getStatusPorts()
    if myPorts.isReadError:
      args.lblPorts.setMarkup("Ports:  <b>Parse torrc failed</b>")
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
        args.lblPorts.setMarkup("Ports:  <b>Activated</b>")
      elif szErr == 3:
        args.lblPorts.setMarkup("Ports:  <b>All ports are not opened</b>")
      elif szErr == 2:
        args.lblPorts.setMarkup("Ports:  <b>Error on " & join(onErrPorts, ", ") & "</b>")
      else:
        args.lblPorts.setMarkup("Ports:  <b>Error on " & onErrPorts[0] & "</b>")

  elif myStatus.isAnonsurfSErvice == 0:
    args.lblServices.setMarkup("Servc:  <b>Deactivated</b>")
    args.lblPorts.setMarkup("Ports:  <b>Deactivated</b>")
  else:
    args.lblServices.setMarkup("Servc:  <b>AnonSurf failed to start</b>")
    args.lblPorts.setMarkup("Ports:  <b>Deactivated</b>")

  # Update DNS status
  let dns = dnsStatusCheck()
  if dns == 0:
    let myPorts = getStatusPorts()
    if myPorts.isReadError:
      args.lblDns.setMarkup("DNS:   <b>[Err] Failed to read config</b>")
    elif myPorts.isDNSPort:
      args.lblDns.setMarkup("DNS:   <b>Using Tor DNS servers</b>")
    else:
      args.lblDns.setMarkup("DNS:   <b>[Err] Failed to bind DNS port</b>")
  elif dns == 1:
    args.lblDns.setMarkup("DNS:   <b>[Warn] LocalHost</b>")
  elif dns == -2:
    args.lblDns.setMarkup("DNS:   <b>[Err] resolv.conf not found</b>")
  elif dns == -3:
    args.lblDns.setMarkup("DNS:   <b>[Err] resolv.conf is empty</b>")
  elif dns == 21 or dns == 11:
    args.lblDns.setMarkup("DNS:   <b>OpenNIC server</b>")
  else:
    args.lblDns.setMarkup("DNS:   <b>Custom setting</b>")


proc updateMain*(args: MainObjs, myStatus: Status) =
  #[
    Always check status of current widget
      to show correct state of buttons
  ]#
  # args.btnRestart.label = "Restart"
  if myStatus.isAnonSurfService == 1:
    # Idea: Restart when AnonSurf is failed
    args.btnRestart.setSensitive(true)
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
      args.btnRestart.setSensitive(false)
      args.lDetails.setText("AnonSurf start failed") # Fix me
      # args.imgStatus.setFromIconName("security-low", 6)
      args.imgStatus.setFromPixBuf(surfImages.imgSecLow)
    else:
      args.btnRestart.setSensitive(false)
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
