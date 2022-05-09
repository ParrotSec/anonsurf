import gintro / gtk
import ansurf_gtk_objects
import ansurf_icons
import ansurf_get_status
import strutils
import .. / cores / commons / dns_utils


proc upd_boot_is_enabled(btn: Button, label: Label, img: Image) =
  btn.label = "Disable"
  label.setLabel("Enabled at boot")
  img.setFromPixbuf(surfImages.imgBootOn)


proc upd_boot_is_disabled(btn: Button, label: Label, img: Image) =
  btn.label = "Enable"
  label.setLabel("Not enabled at boot")
  img.setFromPixbuf(surfImages.imgBootOn)


proc updateDetail*(args: DetailObjs, myStatus: Status) =
  # AnonSurf is Enabled at boot
  if myStatus.isAnonSurfBoot:
    upd_boot_is_enabled(args.btnBoot, args.lblBoot, args.imgBoot)
  else:
    upd_boot_is_disabled(args.btnBoot, args.lblBoot, args.imgBoot)

  # Check current status of daemon services and control ports
  if myStatus.isAnonSurfService:
    # Check status of Tor
    if myStatus.isTorService:
      args.lblServices.setMarkup("Servc:  <b><span background=\"#333333\" foreground=\"#00FF00\">Activated</span></b>")
    else:
      # Give error msg with red color
      args.lblServices.setMarkup("Servc:  <b><span background=\"#333333\" foreground=\"#FF0000\">Tor is not running</span></b>")
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
        args.lblPorts.setMarkup(cstring("Ports:  <b><span background=\"#333333\" foreground=\"#FF0000\">Error on " & join(onErrPorts, ", ") & "</span></b>"))
      else:
        # Give error msg with red color
        args.lblPorts.setMarkup(cstring("Ports:  <b<span background=\"#333333\" foreground=\"#FF0000\">>Error on " & onErrPorts[0] & "</span></b>"))

  elif not myStatus.isAnonsurfSErvice:
    # Deactivated cyan color
    args.lblServices.setMarkup("Servc:  <b><span background=\"#333333\" foreground=\"#00FFFF\">Deactivated</span></b>")
    args.lblPorts.setMarkup("Ports:  <b><span background=\"#333333\" foreground=\"#00FFFF\">Deactivated</span></b>")

  # Update DNS status
  # TODO remove all text shadow
  let dns_status = dnsStatusCheck()
  if dns_status.err == ERR_TOR:
    let myPorts = getStatusPorts()
    if myPorts.isReadError:
      # ERROR RED
      args.lblDns.setMarkup("DNS:   <b><span background=\"#333333\" foreground=\"#FF0000\"> Can't read Tor config<span></b>")
    elif myPorts.isDNSPort:
      # Activated green
      args.lblDns.setMarkup("DNS:   <b><span background=\"#333333\" foreground=\"#00FF00\">Tor DNS</span></b>")
    else:
      # Give error msg with red color
      args.lblDns.setMarkup("DNS:   <b><span background=\"#333333\" foreground=\"#FF0000\"> Can't bind port</span></b>")
  elif dns_status.err == ERR_LOCAL_HOST:
    # Give error style with red color
    args.lblDns.setMarkup("DNS:   <b><span background=\"#333333\" foreground=\"#FF0000\"> LocalHost</span></b>")
  elif dns_status.err == ERR_FILE_EMPTY:
    # Give error msg with red color
    args.lblDns.setMarkup("DNS:   <b><span background=\"#333333\" foreground=\"#FF0000\">resolv.conf is empty</span></b>")
  elif dns_status.err == ERR_FILE_NOT_FOUND:
    # Give error msg with red color
    args.lblDns.setMarkup("DNS:   <b><span background=\"#333333\" foreground=\"#FF0000\">resolv.conf not found</span></b>")
  elif dns_status.err == ERR_UNKNOWN:
    # Give error msg with red color
    args.lblDns.setMarkup("DNS:   <b><span background=\"#333333\" foreground=\"#FF0000\">Unknown error</span></b>")
  else:
    if dns_status.is_static:
    # Use cyan for opennic or custom addresses
      args.lblDns.setMarkup("DNS:   <b><span background=\"#333333\" foreground=\"#00FFFF\">Custom servers</span></b>")
    else:
      args.lblDns.setMarkup("DNS:   <b><span background=\"#333333\" foreground=\"#00FFFF\">DHCP servers</span></b>")


proc updateMain*(args: MainObjs, myStatus: Status) =
  #[
    Always check status of current widget
      to show correct state of buttons
  ]#
  # args.btnRestart.label = "Restart"
  if myStatus.isAnonSurfService:
    # Idea: Restart when AnonSurf is failed
    args.btnRestart.setSensitive(true)
    # Check status of tor service
    if myStatus.isTorService:
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
    args.btnRestart.setSensitive(false)
    args.lDetails.setText("AnonSurf is not running")
    # args.imgStatus.setFromIconName("security-medium", 6)
    args.imgStatus.setFromPixBuf(surfImages.imgSecMed)
    args.btnRun.label = "Start"
    args.btnID.setSensitive(false)
    args.btnStatus.setSensitive(false)

  if ansurf_workers_myip.running:
    args.btnIP.setSensitive(false)
  else:
    ansurf_workers_myip.joinThread()
    args.btnIP.setSensitive(true)
