import gintro / gtk
import ansurf_gtk_objects
import ansurf_get_status
import strutils
import refresher / [main_widget_refresher, detail_widget_refresher]


proc updateDetail*(args: DetailObjs, myStatus: Status) =
  # AnonSurf is Enabled at boot
  if myStatus.isAnonSurfBoot:
    w_detail_update_enabled_boot(args.btnBoot, args.lblBoot, args.imgBoot)
  else:
    w_detail_update_disabled_boot(args.btnBoot, args.lblBoot, args.imgBoot)

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

  elif not myStatus.isAnonsurfService:
    # Deactivated cyan color
    w_detail_update_deactivated(args.lblServices, args.lblPorts)

  # Update DNS status
  w_detail_update_dns_status(args.lblDns)


proc updateMain*(args: MainObjs, myStatus: Status) =
  #[
    Always check status of current widget
      to show correct state of buttons
  ]#
  if not myStatus.isAnonSurfService:
    w_main_update_ansurf_not_running(args.btnRun, args.btnID, args.btnStatus, args.btnRestart, args.lDetails, args.imgStatus)
  else:
    w_main_update_btn_run_and_restart(args.btnRun, args.btnRestart)
    # Check status of tor service
    if myStatus.isTorService:
      let myPorts = getStatusPorts()
      # If everything (except DNS port) is okay
      if myPorts.isControlPort and myPorts.isSocksPort and myPorts.isTransPort and
        not myPorts.isReadError:
        w_main_update_btn_id_and_status(args.btnID, args.btnStatus)
        # Check DNS
        if myPorts.isDNSPort:
          w_main_update_anonsurf_is_running(args.imgStatus, args.lDetails)
        else:
          w_main_update_error_dns_port(args.imgStatus, args.lDetails)
      else:
        w_main_update_tor_ports_error(args.btnID, args.btnSTatus, args.lDetails, args.imgStatus)
    else:
      w_main_update_tor_not_running(args.btnId, args.btnStatus, args.lDetails, args.imgStatus)

  w_main_update_btn_check_ip(args.btnIP)
