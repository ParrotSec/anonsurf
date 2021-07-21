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
      args.lblServices.setMarkup("Servc:  <b><span background=\"#333333\" foreground=\"#00FF00\">Activated</span></b>")
    elif myStatus.isTorService == 0:
      # Give error msg with red color
      args.lblServices.setMarkup("Servc:  <b><span background=\"#333333\" foreground=\"#FF0000\">Tor is not running</span></b>")
    elif myStatus.isTorService == -1:
      # Give error msg with red color
      args.lblServices.setMarkup("Servc:  <b><span background=\"#333333\" foreground=\"#FF0000\">Can't start Tor</span></b>")
    # Check status of Port
    let myPorts = getStatusPorts()
    if myPorts.isReadError:
      # Give error msg with red color
      args.lblPorts.setMarkup("Ports:  <b><span background=\"#333333\" foreground=\"#FF0000\">Parse torrc failed</span></b>")
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
        # ACtivated green
        args.lblPorts.setMarkup("Ports:  <b><span background=\"#333333\" foreground=\"#00FF00\">Activated</span></b>")
      elif szErr == 3:
        # Give error msg with red color
        args.lblPorts.setMarkup("Ports:  <b><span background=\"#333333\" foreground=\"#FF0000\">Can't bind ports</span></b>")
      elif szErr == 2:
        # Give error msg with red color
        args.lblPorts.setMarkup("Ports:  <b><span background=\"#333333\" foreground=\"#FF0000\">Error on " & join(onErrPorts, ", ") & "</span></b>")
      else:
        # Give error msg with red color
        args.lblPorts.setMarkup("Ports:  <b<span background=\"#333333\" foreground=\"#FF0000\">>Error on " & onErrPorts[0] & "</span></b>")

  elif myStatus.isAnonsurfSErvice == 0:
    # Deactivated cyan color
    args.lblServices.setMarkup("Servc:  <b><span background=\"#333333\" foreground=\"#00FFFF\">Deactivated</span></b>")
    args.lblPorts.setMarkup("Ports:  <b><span background=\"#333333\" foreground=\"#00FFFF\">Deactivated</span></b>")
  else:
    # Deactivated cyan color and error red color
    args.lblServices.setMarkup("Servc:  <b><span background=\"#333333\" foreground=\"#FF0000\">Can't start AnonSurf</span></b>")
    args.lblPorts.setMarkup("Ports:  <b><span background=\"#333333\" foreground=\"#00FFFF\">Deactivated</span></b>")

  # Update DNS status
  # TODO remove all text shadow
  case dnsStatusCheck()
  of STT_DNS_TOR:
    let myPorts = getStatusPorts()
    if myPorts.isReadError:
      # ERROR RED
      args.lblDns.setMarkup("DNS:   <b><span background=\"#333333\" foreground=\"#FF0000\"> Can't read Tor config<span></b>")
    elif myPorts.isDNSPort:
      # Activated green
      args.lblDns.setMarkup("DNS:   <b><span background=\"#333333\" foreground=\"#00FF00\">Activated</span></b>")
    else:
      # Give error msg with red color
      args.lblDns.setMarkup("DNS:   <b><span background=\"#333333\" foreground=\"#FF0000\"> Can't bind port</span></b>")
  of ERROR_DNS_LOCALHOST:
    # Give error style with red color
    args.lblDns.setMarkup("DNS:   <b><span background=\"#333333\" foreground=\"#FF0000\"> LocalHost</span></b>")
  of ERROR_FILE_EMPTY:
    # Give error msg with red color
    args.lblDns.setMarkup("DNS:   <b><span background=\"#333333\" foreground=\"#FF0000\">resolv.conf is empty</span></b>")
  of ERROR_FILE_NOT_FOUND:
    # Give error msg with red color
    args.lblDns.setMarkup("DNS:   <b><span background=\"#333333\" foreground=\"#FF0000\">resolv.conf not found</span></b>")
  of ERROR_UNKNOWN:
    # Give error msg with red color
    args.lblDns.setMarkup("DNS:   <b><span background=\"#333333\" foreground=\"#FF0000\">Unknown error</span></b>")
  of 11:
    # Use cyan for opennic or custom addresses
    args.lblDns.setMarkup("DNS:   <b><span background=\"#333333\" foreground=\"#00FFFF\">OpenNIC server</span></b>")
  of 21:
    # Use cyan for opennic or custom addresses
    args.lblDns.setMarkup("DNS:   <b><span background=\"#333333\" foreground=\"#00FFFF\">OpenNIC server</span></b>")
  else:
    # Use cyan for opennic or custom addresses
    args.lblDns.setMarkup("DNS:   <b><span background=\"#333333\" foreground=\"#00FFFF\">Custom setting</span></b>")



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
